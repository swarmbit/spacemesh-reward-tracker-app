import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';

const String _showAds = "showAds";
const String _swarmbitUrl = "swarmbitUrl";

const String _showImportLayersTutorial = "showImportLayersTutorial";
const String _importLayersTutorialLink = "importLayersTutorialLink";
const String _donationAccount = "donationAccount";

const String _testAds = "testAds";

class RemoteConfig {
  static final RemoteConfig _singleton = RemoteConfig._internal();

  late FirebaseRemoteConfig remoteConfig;
  late StreamSubscription? subscription;

  RemoteConfig._internal();

  factory RemoteConfig() {
    return _singleton;
  }

  Future<bool> init() async {
    FirebaseRemoteConfig.instance.ensureInitialized();
    remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 6),
    ));
    await remoteConfig.setDefaults(const {
      _showAds: true,
      _swarmbitUrl: "spacemesh-api-v2.swarmbit.io",
      _testAds: true,
      _showImportLayersTutorial: true,
      _importLayersTutorialLink: "https://www.youtube.com/watch?v=BB3AU_DmKxk",
      _donationAccount: "sm1qqqqqqy7947u3s0a4af099udd7p9n5msx65hj8srcqq4n"
    });
    await remoteConfig.fetchAndActivate();

    if (!kIsWeb) {
      subscription = remoteConfig.onConfigUpdated.listen((event) async {
        await remoteConfig.activate();
        debugPrint(remoteConfig.getBool(_testAds).toString());

        var isTestAds = testAds();
        debugPrint("Load Test Ads Config: " + isTestAds.toString());
        Appodeal.setTesting(isTestAds);

        print("Remote config updated");
      });
    }

    return Future.value(true);
  }

  Future<void> clean() async {
    if (subscription != null) {
      await subscription!.cancel();
    }
  }

  bool showAds() {
    return remoteConfig.getBool(_showAds);
  }

  bool testAds() {
    return remoteConfig.getBool(_testAds);
  }

  String swarmbitUrl() {
    return remoteConfig.getString(_swarmbitUrl);
  }

  bool showImportLayersTutorial() {
    return remoteConfig.getBool(_showImportLayersTutorial);
  }

  String importLayersTutorialLink() {
    return remoteConfig.getString(_importLayersTutorialLink);
  }

  String donationAccount() {
    return remoteConfig.getString(_donationAccount);
  }
}
