import 'package:flutter/material.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';

class BannerWrapper extends StatelessWidget {
  final bool hasAds;

  BannerWrapper({super.key, required this.hasAds}) {
    Appodeal.setBannerCallbacks(
        onBannerLoaded: (isPrecache) =>
            print('onBannerLoaded: isPrecache - $isPrecache'),
        onBannerFailedToLoad: () => print('onBannerFailedToLoad'),
        onBannerShown: () => print('onBannerShown'),
        onBannerShowFailed: () => print('onBannerShowFailed'),
        onBannerClicked: () => print('onBannerClicked'),
        onBannerExpired: () => print('onBannerExpired'));
  }

  @override
  Widget build(BuildContext context) {
    return hasAds
        ? Directionality(
            textDirection: TextDirection.ltr,
            child: AppodealBanner(adSize: AppodealBannerSize.BANNER))
        : const SizedBox(
            height: 0,
          );
  }
}
