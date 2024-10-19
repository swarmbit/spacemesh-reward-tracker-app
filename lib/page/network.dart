import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spacemesh_reward_tracker/data/network_info.dart';

import '../component/network_details.dart';
import '../data/epoch.dart';
import '../service/network_service.dart';

class NetworkPage extends StatefulWidget {
  const NetworkPage({super.key});

  @override
  State<NetworkPage> createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkPage> with WidgetsBindingObserver {
  NetworkService networkService = NetworkService();

  late num currentLayer;
  late NetworkInfo? networkInfo;
  Timer? refreshTimer;
  late Epoch epoch;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    currentLayer = networkService.getCurrentLayer();
    networkInfo = networkService.getNetworkInfo();
    epoch = networkService.getEpoch();
    _startRefreshTimer();
  }

  void _startRefreshTimer() {
    if (mounted) {
      setState(() {
        epoch = networkService.getEpoch();
        currentLayer = networkService.getCurrentLayer();
        networkInfo = networkService.getNetworkInfo();
      });
    }
    refreshTimer = Timer.periodic(
      const Duration(seconds: 10),
      (Timer timer) {
        debugPrint("Refresh | Network");
        if (mounted) {
          setState(() {
            epoch = networkService.getEpoch();
            currentLayer = networkService.getCurrentLayer();
            networkInfo = networkService.getNetworkInfo();
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () {
          return networkService.fetchNetworkInfo().then((value) {
            if (mounted) {
              setState(() {
                epoch = networkService.getEpoch();
                currentLayer = networkService.getCurrentLayer();
                networkInfo = networkService.getNetworkInfo();
              });
            }
          }).onError((error, stackTrace) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to refresh network'),
              ),
            );
          });
        },
        child: NetworkDetails(
          epoch: epoch,
          currentLayer: currentLayer,
          networkInfo: networkInfo,
        ));
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
    debugPrint("Cancel timer on page dispose");
    refreshTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
