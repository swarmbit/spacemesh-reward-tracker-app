import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';

class Analytics {
  static final Analytics _singleton = Analytics._internal();

  Analytics._internal();

  factory Analytics() {
    return _singleton;
  }

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  void sendCurrentAnalytics(currentScreen) {
    analytics
        .logScreenView(
          screenName: currentScreen,
        )
        .then((value) => print("Current screen set to $currentScreen"));
  }

  void saveEvent(
    String name,
    Map<String, Object>? parameters,
  ) {
    analytics
        .logEvent(name: name, parameters: parameters)
        .then((value) => debugPrint("Sent analytics event: $name"));
  }
}
