import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spacemesh_reward_tracker/service/config/remote_config.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../global_configs.dart';
import '../provider/settings_provider.dart';
import '/component/theme_mode_menu.dart';

class SettingsRoute extends StatelessWidget {
  SettingsRoute({super.key});

  final RemoteConfig remoteConfig = RemoteConfig();

  @override
  Widget build(BuildContext context) {
    String appLinks =
        "Android:\nhttps://play.google.com/store/apps/details?id=io.swarmbit.spacemesh_reward_tracker\n\n"
        "iOS:\nhttps://apps.apple.com/pt/app/spacemesh-reward-tracker/id6463492791";

    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var settingsProvider = Provider.of<SettingsProvider>(context);
    var brightness = settingsProvider.getSelectedBrightness(
      MediaQuery.of(context).platformBrightness,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 32.00),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose a color theme:',
              style:
                  textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
            const ThemeModeMenu(),
            Expanded(
                flex: 20,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Show value",
                            style: textTheme.titleMedium!
                                .copyWith(fontWeight: FontWeight.bold)),
                        Switch(
                          value: settingsProvider.isShowValue,
                          onChanged: (value) {
                            settingsProvider.isShowValue = value;
                          },
                        ),
                      ],
                    )
                  ],
                )),
            const Divider(),
            Text('Version: ${GlobalConfigs.version}',
                style: textTheme.bodyMedium),
            InkWell(
              child: Text(
                "Please donate to keep the app going",
                style: brightness == Brightness.light
                    ? theme.textTheme.bodyMedium!.copyWith(
                        color: theme.primaryColor,
                        decoration: TextDecoration.underline,
                      )
                    : theme.textTheme.bodyMedium!.copyWith(
                        color: theme.primaryColorLight,
                        decoration: TextDecoration.underline,
                      ),
              ),
              onTap: () async {
                final box = context.findRenderObject() as RenderBox?;
                if (box != null) {
                  final Rect rect = box.localToGlobal(Offset.zero) & box.size;
                  await Share.share(
                    remoteConfig.donationAccount(),
                    // needed to work on ipad
                    sharePositionOrigin: rect,
                  );
                }
              },
            ),
            InkWell(
              child: Text(
                "Share app with friends",
                style: brightness == Brightness.light
                    ? theme.textTheme.bodyMedium!.copyWith(
                        color: theme.primaryColor,
                        decoration: TextDecoration.underline,
                      )
                    : theme.textTheme.bodyMedium!.copyWith(
                        color: theme.primaryColorLight,
                        decoration: TextDecoration.underline,
                      ),
              ),
              onTap: () async {
                final box = context.findRenderObject() as RenderBox?;
                if (box != null) {
                  final Rect rect = box.localToGlobal(Offset.zero) & box.size;
                  await Share.share(
                    appLinks,
                    // needed to work on ipad
                    sharePositionOrigin: rect,
                  );
                }
              },
            ),
            InkWell(
              child: Text(
                "Terms of Use",
                style: brightness == Brightness.light
                    ? textTheme.bodyMedium!.copyWith(
                        color: theme.primaryColor,
                        decoration: TextDecoration.underline,
                      )
                    : textTheme.bodyMedium!.copyWith(
                        color: theme.primaryColorLight,
                        decoration: TextDecoration.underline,
                      ),
              ),
              onTap: () async {
                launchURL(Uri(
                    scheme: "https",
                    host: "swarmbit.github.io",
                    path: "terms-of-use"));
              },
            ),
            InkWell(
              child: Text(
                "https://spacemesh.io/",
                style: brightness == Brightness.light
                    ? textTheme.bodyMedium!.copyWith(
                        color: theme.primaryColor,
                        decoration: TextDecoration.underline,
                      )
                    : textTheme.bodyMedium!.copyWith(
                        color: theme.primaryColorLight,
                        decoration: TextDecoration.underline,
                      ),
              ),
              onTap: () async {
                launchURL(Uri(scheme: "https", host: "spacemesh.io"));
              },
            ),
          ],
        ),
      ),
    );
  }

  void launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch ${url.toString()}';
    }
  }
}
