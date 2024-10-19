import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:spacemesh_reward_tracker/page/calendar.dart';
import 'package:spacemesh_reward_tracker/service/network_service.dart';

import '../provider/settings_provider.dart';
import '../service/analytics/analytics.dart';
import '../service/config/remote_config.dart';
import 'home.dart';
import 'network.dart';
import 'settings_route.dart';

class ScaffoldPage extends StatefulWidget {
  const ScaffoldPage({
    super.key,
  });

  @override
  State<ScaffoldPage> createState() => _ScaffoldPageState();
}

class _ScaffoldPageState extends State<ScaffoldPage>
    with WidgetsBindingObserver {
  var selectedIndex = 0;
  RemoteConfig remoteConfig = RemoteConfig();
  Analytics analytics = Analytics();

  NetworkService networkService = NetworkService();

  Timer? refreshTimer;

  @override
  void initState() {
    super.initState();
    initialization();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      debugPrint("Pause timer");
      refreshTimer?.cancel();
    } else if (state == AppLifecycleState.resumed) {
      debugPrint("Start timer");
      _startRefreshTimer();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    debugPrint("Scaffold dispose called");
    refreshTimer?.cancel();
    super.dispose();
  }

  void initialization() async {
    if (!kIsWeb) {
      FlutterNativeSplash.remove();
    }
    _startRefreshTimer();
  }

  void _startRefreshTimer() {
    networkService
        .fetchNetworkInfo()
        .then((value) => debugPrint("Fetch network info"));
    refreshTimer = Timer.periodic(
      const Duration(seconds: 30),
      (Timer timer) async {
        debugPrint("Fetch Network Info");
        await networkService.fetchNetworkInfo();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    String title;
    switch (selectedIndex) {
      case 0:
        page = const HomePage();
        title = 'Home';
        analytics.sendCurrentAnalytics("home");
        break;
      case 1:
        page = const NetworkPage();
        title = 'Network';
        analytics.sendCurrentAnalytics("network");
        break;
      case 2:
        page = const CalendarPage();
        title = 'Calendar';
        analytics.sendCurrentAnalytics("calendar");
        break;
      default:
        throw UnimplementedError(
            'No page exists for selected index: $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      var theme = Theme.of(context);
      var brightness =
          Provider.of<SettingsProvider>(context).getSelectedBrightness(
        MediaQuery.of(context).platformBrightness,
      );
      return Scaffold(
        appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 24 icon size + 16 icon padding
                // placeholder for text to be centered
                const SizedBox(width: 40.0),
                Text(
                  title,
                  style: theme.textTheme.headlineMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                )
              ],
            ),
            actions: [
              IconButton(
                  iconSize: 24.0,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SettingsRoute(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.settings)),
            ],
            // centerTitle: false,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(20),
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text: 'Spacemesh',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: brightness == Brightness.light
                                ? theme.primaryColor
                                : theme.primaryColorLight,
                          ),
                          children: [
                            TextSpan(
                              text: ' reward tracker',
                              style: theme.textTheme.labelLarge,
                            )
                          ],
                        ),
                      )),
                ],
              ),
            )),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: page,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.language_rounded),
              label: 'Network',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_rounded),
              label: 'Calendar',
            ),
          ],
          onTap: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
        ),
      );
    });
  }
}
