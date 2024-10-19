import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spacemesh_reward_tracker/page/account_epoch_atx_route.dart';
import 'package:url_launcher/url_launcher.dart';

import '../component/expected_reward_list.dart';
import '../provider/account_epoch_details_provider.dart';
import '../provider/settings_provider.dart';
import '../service/account_epoch_layers_service.dart';
import '../service/analytics/analytics.dart';
import '../service/config/remote_config.dart';
import '../service/network_service.dart';

class AccountEpochDetailsRoute extends StatefulWidget {
  const AccountEpochDetailsRoute({
    super.key,
  });

  @override
  State<AccountEpochDetailsRoute> createState() =>
      _AccountEpochDetailsRouteState();
}

class _AccountEpochDetailsRouteState extends State<AccountEpochDetailsRoute> {
  NetworkService networkService = NetworkService();

  RemoteConfig remoteConfig = RemoteConfig();
  AccountEpochLayersService accountEpochLayersService =
      AccountEpochLayersService();

  Analytics analytics = Analytics();
  late num currentEpoch;
  late List<String> epochOptions;

  String infoMessage = 'Eligibility count and reward estimation '
      'values are calculated based on ideal network conditions, '
      'actual values might be different at the end of epoch.';

  String layersFormat1 = '''
  {
    "smesherId1": [
      {
        "layer": 43454,
        "count": 2
      },
      {
        "layer": 43455,
        "count": 1
      }
    ],
    "smesherId2": [
      {
        "layer": 43433,
        "count": 1
      },
      {
        "layer": 43434,
        "count": 1
      }
    ]
  }
  ''';

  String layersFormat2 = '''
  {
    "smesherId1": [
      43454,
      43454,
      43455
    ],
    "smesherId2": [
      37433,
      37434
    ]
  }
  ''';

  String layersFormat3 = '''
  [
      {
          "nodeName": "Node01",
          "nodeID": "xxxxxxxxx",
          "eligibilities": [
              {
                  "layer": 32705,
                  "count": 1
              },
              {
                  "layer": 32555,
                  "count": 1
              }
          ]
      },
      {
          "nodeName": "Node02",
          "nodeID": "2xxxxxxxx",
          "eligibilities": [
              {
                  "layer": 32705,
                  "count": 1
              },
              {
                  "layer": 32555,
                  "count": 1
              }
          ]
      }
  ]
  ''';

  @override
  void initState() {
    super.initState();
    currentEpoch = networkService.getEpoch().epoch;

    epochOptions = [];
    for (num i = 2; i <= (currentEpoch + 1); i++) {
      epochOptions.add(i.toString());
    }

    debugPrint("Epoch options: $epochOptions");

    analytics.sendCurrentAnalytics("account_epoch_details");
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _showRemoveLayersDialog(
      AccountEpochDetailsProvider provider) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear layers'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to clear saved layers for epoch?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('YES'),
              onPressed: () {
                Navigator.of(context).pop();
                accountEpochLayersService
                    .removeLayers(provider.address, provider.selectedEpoch)
                    .then((value) {
                  provider.removeExpectedLayers();
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var accountEpochDetailsProvider =
        context.watch<AccountEpochDetailsProvider>();

    ExpectedRewardsList? expectedRewardsList;

    if (accountEpochDetailsProvider.expectedLayers != null) {
      expectedRewardsList = ExpectedRewardsList(
        address: accountEpochDetailsProvider.address,
        epoch: accountEpochDetailsProvider.selectedEpoch,
      );
    } else {
      expectedRewardsList = null;
    }

    var labelTheme =
        theme.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold);

    MenuAnchor layersMenu = createMenuAnchor(
        expectedRewardsList, accountEpochDetailsProvider, context, theme);

    var settingsProvider = Provider.of<SettingsProvider>(context);
    var brightness = settingsProvider.getSelectedBrightness(
      MediaQuery.of(context).platformBrightness,
    );

    return Scaffold(
      floatingActionButton: layersMenu,
      appBar: AppBar(
        title: const Text('Rewards details'),
        actions: [
          IconButton(
            onPressed: () async => await accountEpochDetailsProvider
                .refreshRewardDetailsAsync(context),
            icon: accountEpochDetailsProvider.isRefreshing
                ? const CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                  )
                : const Icon(Icons.refresh),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4.0, 16.0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Epoch',
                  style: theme.textTheme.headlineSmall,
                ),
                DropdownButton(
                  value: accountEpochDetailsProvider.selectedEpoch.toString(),
                  style: theme.textTheme.titleLarge,
                  items: epochOptions.map((String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) async {
                    try {
                      await accountEpochDetailsProvider.setSelectedEpoch(
                          int.parse(value.toString()), context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Failed to load epoch rewards details!'),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          accountEpochDetailsProvider.rewardsDetails != null
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(mainAxisSize: MainAxisSize.max, children: [
                        Flexible(
                            flex: 10,
                            child: accountEpochDetailsProvider.label != null
                                ? ListTile(
                                    visualDensity: const VisualDensity(
                                        horizontal: -4.0, vertical: -4.0),
                                    leading: const Icon(Icons.flag),
                                    title: Text(
                                      'Label',
                                      style: labelTheme,
                                    ),
                                    subtitle: Text(
                                      accountEpochDetailsProvider.label!,
                                    ),
                                  )
                                : const SizedBox()),
                        Flexible(
                          flex: 2,
                          child: Tooltip(
                            triggerMode: TooltipTriggerMode.tap,
                            message: infoMessage,
                            showDuration: const Duration(seconds: 10),
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                              child: Icon(Icons.info_outline_rounded),
                            ),
                          ),
                        ),
                      ]),
                      Row(mainAxisSize: MainAxisSize.max, children: [
                        Flexible(
                            flex: 10,
                            child: ListTile(
                                visualDensity: const VisualDensity(
                                    horizontal: -4.0, vertical: -4.0),
                                leading: const Icon(
                                    Icons.drive_folder_upload_rounded),
                                title: Text(
                                  'Data',
                                  style: labelTheme,
                                ),
                                subtitle: InkWell(
                                  onTap: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ChangeNotifierProvider(
                                            create: (_) =>
                                                accountEpochDetailsProvider,
                                            child: AccountEpochAtxRoute(
                                                account:
                                                    accountEpochDetailsProvider
                                                        .address,
                                                epoch:
                                                    accountEpochDetailsProvider
                                                        .selectedEpoch)),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    accountEpochDetailsProvider.rewardsDetails!
                                        .eligibility.postDataSize,
                                    style: brightness == Brightness.light
                                        ? theme.textTheme.bodyMedium!.copyWith(
                                            color: theme.primaryColor,
                                            decoration:
                                                TextDecoration.underline,
                                          )
                                        : theme.textTheme.bodyMedium!.copyWith(
                                            color: theme.primaryColorLight,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                  ),
                                ))),
                        Flexible(
                            flex: 10,
                            child: ListTile(
                              visualDensity: const VisualDensity(
                                  horizontal: -4.0, vertical: -4.0),
                              leading: const Icon(Icons.numbers_outlined),
                              title: Text(
                                'Count',
                                style: labelTheme,
                              ),
                              subtitle: accountEpochDetailsProvider
                                          .expectedLayers !=
                                      null
                                  ? Text(
                                      "${accountEpochDetailsProvider.rewardsDetails!.rewardsCount}/${accountEpochDetailsProvider.expectedLayers!.length}")
                                  : Text(
                                      "${accountEpochDetailsProvider.rewardsDetails!.rewardsCount}/${accountEpochDetailsProvider.rewardsDetails!.eligibility.count}"),
                            )),
                      ]),
                      Row(mainAxisSize: MainAxisSize.max, children: [
                        Flexible(
                            flex: 10,
                            child: ListTile(
                              visualDensity: const VisualDensity(
                                  horizontal: -4.0, vertical: -4.0),
                              leading: const Icon(
                                  Icons.account_balance_wallet_rounded),
                              title: Text(
                                'Received',
                                style: labelTheme,
                              ),
                              subtitle: Text(accountEpochDetailsProvider
                                  .rewardsDetails!.rewardsSum),
                            )),
                        Flexible(
                            flex: 10,
                            child: ListTile(
                              visualDensity: const VisualDensity(
                                  horizontal: -4.0, vertical: -4.0),
                              leading: const Icon(Icons.calculate),
                              title: Text(
                                'Estimated',
                                style: labelTheme,
                              ),
                              subtitle: Text(accountEpochDetailsProvider
                                  .rewardsDetails!
                                  .eligibility
                                  .predictedRewards),
                            )),
                      ]),
                    ],
                  ),
                )
              : !accountEpochDetailsProvider.isRefreshing &&
                      !accountEpochDetailsProvider.failedLoading
                  ? Expanded(
                      child: Center(
                          child: accountEpochDetailsProvider.selectedEpoch >
                                  currentEpoch
                              ? const Text('No activations submitted')
                              : const Text('Not eligible for epoch')))
                  : const SizedBox(
                      height: 0,
                    ),
          accountEpochDetailsProvider.rewardsDetails != null &&
                  expectedRewardsList != null
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 6.0, 8.0, 0),
                    child: expectedRewardsList!,
                  ),
                )
              : const Expanded(
                  child: SizedBox(
                  height: 0,
                ))
        ],
      ),
    );
  }

  MenuAnchor createMenuAnchor(
      expectedRewardsList,
      AccountEpochDetailsProvider accountEpochDetailsProvider,
      BuildContext context,
      ThemeData theme) {
    var menuOptions = [
      MenuItemButton(
        onPressed: () {
          analytics.saveEvent("epochLayersSet", null);
          FilePicker.platform.pickFiles(withData: true).then((result) {
            if (result != null) {
              var file = result.files.firstOrNull;
              if (file != null && file.path != null) {
                accountEpochDetailsProvider.setRefreshing(true);
                accountEpochLayersService
                    .saveLayers(accountEpochDetailsProvider.address,
                        accountEpochDetailsProvider.selectedEpoch, file.path!)
                    .then((value) {
                  accountEpochDetailsProvider.setExpectedLayers(value);
                  accountEpochDetailsProvider.setRefreshing(false);
                }).onError((error, stackTrace) {
                  debugPrintStack(stackTrace: stackTrace);
                  accountEpochDetailsProvider.setRefreshing(false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Failed to import layers, check file format!'),
                    ),
                  );
                });
              }
            }
          });
        },
        child: const Text('Import layers'),
      ),
      MenuItemButton(
        onPressed: () async {
          final box = context.findRenderObject() as RenderBox?;
          if (box != null) {
            final Rect rect = box.localToGlobal(Offset.zero) & box.size;
            await Share.share(
              "File can be used on multiple accounts. App filter active smeshers for each individual account."
              "\n\nSupported Formats:\n\n- Format 1:\n$layersFormat1\n- Format 2:\n$layersFormat2\n- Format 3:\n$layersFormat3",
              // needed to work on ipad
              sharePositionOrigin: rect,
            );
          }
        },
        child: const Text('Export template json'),
      ),
    ];

    if (remoteConfig.showImportLayersTutorial()) {
      menuOptions.add(MenuItemButton(
        onPressed: () async {
          await launchURL(Uri.parse(remoteConfig.importLayersTutorialLink()));
        },
        child: const Text('Tutorial'),
      ));
    }

    menuOptions.add(MenuItemButton(
      onPressed: () {
        _showRemoveLayersDialog(accountEpochDetailsProvider);
      },
      child: const Text('Clear layers'),
    ));

    var layersMenu = MenuAnchor(
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
        if (expectedRewardsList != null) {
          return FloatingActionButton(
            onPressed: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            tooltip: 'Show menu',
            backgroundColor: theme.colorScheme.surfaceVariant,
            child: const Icon(Icons.info_outline_rounded),
          );
        } else {
          return FloatingActionButton.extended(
            onPressed: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            tooltip: 'Show menu',
            backgroundColor: theme.colorScheme.surfaceVariant,
            icon: const Icon(Icons.add), // Icon inside the button
            label: const Text('Add Layers'),
          );
        }
      },
      menuChildren: menuOptions,
      alignmentOffset: Offset.fromDirection(1.0, 10.0),
    );
    return layersMenu;
  }

  Future<bool> launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
      return true;
    } else {
      throw 'Could not launch ${url.toString()}';
    }
  }
}
