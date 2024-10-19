import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';

import './global_configs.dart';
import 'component/banner.dart';
import 'firebase_options.dart';
import 'page/scaffold.dart';
import 'provider/accounts_provider.dart';
import 'provider/settings_provider.dart';
import 'service/config/remote_config.dart';
import 'storage/account_storage.dart';
import 'storage/network_info_storage.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  }

  // Font license
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  GoogleFonts.config.allowRuntimeFetching = false;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  initializeFirebaseMessaging();

  var config = RemoteConfig();
  await config.init();

  var hasAds = !kIsWeb && !GlobalConfigs.noAds && config.showAds();

  debugPrint("Has ads: $hasAds");

  if (hasAds) {
    await adsInitialization(config);
  }
  // Initialize storage and service
  await AccountStorage().afterInit();
  await NetworkInfoStorage().afterInit();

  runApp(MyApp(hasAds: hasAds));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

void initializeFirebaseMessaging() {
  FirebaseMessaging.instance.requestPermission().then((value) {
    FirebaseMessaging.instance
        .subscribeToTopic(GlobalConfigs.messageTopic)
        .then((value) {
      debugPrint("Initialize cloud messaging");
    });
  });
}

Future<void> adsInitialization(RemoteConfig config) async {
  final String _appodealKey = Platform.isAndroid ? "" : "";

  Appodeal.setLogLevel(Appodeal.LogLevelNone);
  Appodeal.setUseSafeArea(true);
  var testAds =
      kReleaseMode ? (!GlobalConfigs.forceRealAds && config.testAds()) : true;
  debugPrint("Set test ads: $testAds");
  Appodeal.setTesting(testAds);
  Appodeal.initialize(
      appKey: _appodealKey,
      adTypes: [
        AppodealAdType.Banner,
      ],
      onInitializationFinished: (errors) {
        errors?.forEach((error) => print(error));
        print("onInitializationFinished: errors - ${errors?.length ?? 0}");
      });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.hasAds});

  final bool hasAds;
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(
    analytics: analytics,
  );

  @override
  Widget build(BuildContext context) {
    var app = MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsProvider>(
          create: (_) => SettingsProvider(),
        ),
        ChangeNotifierProvider<AccountsProvider>(
          create: (_) => AccountsProvider(),
        ),
      ],
      builder: (context, _) {
        final themeProvider = Provider.of<SettingsProvider>(context);

        return MaterialApp(
          title: 'Spacemesh Rewards Tracker',
          themeMode: themeProvider.themeMode,
          theme: _buildTheme(
            Brightness.light,
            Colors.teal,
          ),
          darkTheme: _buildTheme(
            Brightness.dark,
            Colors.teal.shade200,
          ),
          home: const ScaffoldPage(),
          navigatorObservers: <NavigatorObserver>[observer],
        );
      },
    );
    return hasAds
        ? SafeArea(
            top: false,
            child: Column(
              children: [
                Expanded(child: app),
                BannerWrapper(hasAds: hasAds),
              ],
            ))
        : app;
  }

  ThemeData _buildTheme(Brightness brightness, Color seedColor) {
    var baseTheme = ThemeData(
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        // Add other platforms if needed
      }),
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: brightness,
      ),
      useMaterial3: true,
    );

    return baseTheme.copyWith(
      textTheme: GoogleFonts.sourceCodeProTextTheme(baseTheme.textTheme),
    );
  }
}
