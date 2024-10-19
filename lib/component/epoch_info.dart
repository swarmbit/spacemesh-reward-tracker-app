import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacemesh_reward_tracker/data/client/swarmbit_poet.dart';
import 'package:spacemesh_reward_tracker/data/cycle_gap.dart';
import 'package:spacemesh_reward_tracker/data/rewards_date.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/epoch.dart';
import '../provider/settings_provider.dart';
import '../service/analytics/analytics.dart';
import '../service/date_format_service.dart';
import '../service/network_service.dart';

class EpochInfo extends StatefulWidget {
  const EpochInfo({
    Key? key,
    required this.currentEpoch,
  }) : super(key: key);

  final Epoch currentEpoch;

  @override
  State<EpochInfo> createState() => _EpochInfoState();
}

class _EpochInfoState extends State<EpochInfo> {
  Analytics analytics = Analytics();
  NetworkService networkService = NetworkService();
  DateFormatService dateFormatService = DateFormatService();

  late Epoch epoch;

  late RewardsDate rewardsDate;

  EpochData? epochData;
  CycleGap? cycleGap;

  List<SwarmbitPoet> poets = [];
  SwarmbitPoet? selectedPoet;

  @override
  void initState() {
    super.initState();
    epoch = networkService.getSpecificEpoch(widget.currentEpoch.epoch);
    rewardsDate = networkService.getRewardsDate(widget.currentEpoch.epoch);
    epochData = networkService.getCurrentEpochData();
    getLiveData(widget.currentEpoch.epoch).then((value) {
      if (mounted) {
        setState(() {
          epochData = value;
        });
      }
    });

    var poets = networkService.getPoets();
    if (poets != null) {
      this.poets = poets;
      if (this.poets.isNotEmpty) {
        selectedPoet = poets.first;
        cycleGap = networkService.getCycleGapForEpoch(epoch.epoch,
            selectedPoet!.settings.phaseShift, selectedPoet!.settings.cycleGap);
      }
    }
  }

  Future<EpochData?> getLiveData(num epoch) async {
    return networkService.getEpochData(epoch);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    Locale locale = Localizations.localeOf(context);

    var brightness =
        Provider.of<SettingsProvider>(context).getSelectedBrightness(
      MediaQuery.of(context).platformBrightness,
    );

    var epochOptions = List.generate(
        (widget.currentEpoch.epoch - 1).toInt(), (index) => index + 1);

    epochOptions.addAll(List.generate(
        24, (index) => (index + widget.currentEpoch.epoch).toInt()));

    var now = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Epoch',
                  style: theme.textTheme.headlineMedium,
                ),
                DropdownButton(
                  value: epoch.epoch,
                  style: theme.textTheme.titleLarge,
                  items: epochOptions.map((num value) {
                    return DropdownMenuItem(
                      value: value,
                      child: DropdownMenuItem(
                        value: value,
                        child: Text(value.toString()),
                      ),
                    );
                  }).toList(),
                  onChanged: (selected) => {
                    if (selected! > widget.currentEpoch.epoch + 1)
                      {setState(() => refreshData(selected, null))}
                    else
                      {
                        getLiveData(selected).then((value) {
                          if (mounted) {
                            setState(() => refreshData(selected, value));
                          }
                        })
                      }
                  },
                ),
              ],
            )),
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Row(
            children: [
              const Icon(
                Icons.date_range_rounded,
              ),
              const SizedBox(width: 8.0),
              RichText(
                text: TextSpan(
                  text: now.compareTo(epoch.startTime) < 0
                      ? 'Starts on '
                      : 'Started on ',
                  style: theme.textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: dateFormatService.formatWithLocale(
                          locale, epoch.startTime),
                      style: theme.textTheme.bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              children: [
                const Icon(
                  Icons.date_range_rounded,
                ),
                const SizedBox(width: 8.0),
                RichText(
                  text: TextSpan(
                    text: now.compareTo(epoch.endTime) < 0
                        ? 'Ends on '
                        : 'Ended on ',
                    style: theme.textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: dateFormatService.formatWithLocale(
                            locale, epoch.endTime),
                        style: theme.textTheme.bodyMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ],
            )),
        epochData != null
            ? Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(children: [
                  const Icon(
                    Icons.drive_folder_upload_rounded,
                  ),
                  const SizedBox(width: 8.0),
                  RichText(
                    text: TextSpan(
                      text: 'Network Space: ',
                      style: theme.textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: epochData!.networkSize,
                          style: theme.textTheme.bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 8.0),
                ]))
            : const SizedBox(
                height: 0,
              ),
        epochData != null
            ? Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(children: [
                  const Icon(
                    Icons.desktop_windows_rounded,
                  ),
                  const SizedBox(width: 8.0),
                  RichText(
                    text: TextSpan(
                      text: 'Activations: ',
                      style: theme.textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: epochData!.activeSmeshers,
                          style: theme.textTheme.bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ]))
            : const SizedBox(
                height: 0,
              ),
        epoch.epoch >= widget.currentEpoch.epoch
            ? Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: RichText(
                  text: TextSpan(
                      text: "Register on ",
                      style: theme.textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: 'epoch ${epoch.epoch}',
                          style: theme.textTheme.bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' with poet and start earning rewards on ',
                          style: theme.textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: 'epoch ${rewardsDate.rewardsOnEpoch}.',
                          style: theme.textTheme.bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ]),
                ))
            : const SizedBox(
                height: 0,
              ),
        selectedPoet != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Poet',
                    style: theme.textTheme.titleLarge,
                  ),
                  DropdownButton(
                    value: selectedPoet,
                    style: theme.textTheme.titleMedium,
                    items: poets.map((SwarmbitPoet value) {
                      return DropdownMenuItem(
                        value: value,
                        child: DropdownMenuItem(
                          value: value,
                          child: Text(value.name),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) => {
                      if (mounted)
                        {
                          setState(() {
                            selectedPoet = value;
                            cycleGap = networkService.getCycleGapForEpoch(
                                epoch.epoch,
                                selectedPoet!.settings.phaseShift,
                                selectedPoet!.settings.cycleGap);
                          })
                        }
                    },
                  ),
                ],
              )
            : const SizedBox(
                height: 0,
              ),
        selectedPoet != null
            ? Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  "${selectedPoet!.info.description}.",
                  style: theme.textTheme.bodyMedium,
                ),
              )
            : const SizedBox(
                height: 0,
              ),
        selectedPoet != null
            ? Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: InkWell(
                  child: Text(
                    "More info on poet Discord.",
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
                    Map<String, Object> params = {};
                    params["poet"] = selectedPoet!.name;
                    analytics.saveEvent("clickDiscord", params);
                    launchURL(Uri.parse(selectedPoet!.info.discordLink));
                  },
                ),
              )
            : const SizedBox(
                height: 0,
              ),
        cycleGap != null
            ? Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Cycle gap',
                  style: brightness == Brightness.light
                      ? theme.textTheme.titleMedium!.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold)
                      : theme.textTheme.titleMedium!.copyWith(
                          color: theme.primaryColorLight,
                        ),
                ),
              )
            : const SizedBox(
                height: 0,
              ),
        cycleGap != null
            ? Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(children: [
                  const Icon(
                    Icons.date_range_rounded,
                  ),
                  const SizedBox(width: 8.0),
                  RichText(
                    text: TextSpan(
                      text: now.compareTo(cycleGap!.startTime) < 0
                          ? 'Starts on '
                          : 'Started on ',
                      style: theme.textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: dateFormatService.formatWithLocale(
                              locale, cycleGap!.startTime),
                          style: theme.textTheme.bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ]))
            : const SizedBox(
                height: 0,
              ),
        cycleGap != null
            ? Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(children: [
                  const Icon(
                    Icons.date_range_rounded,
                  ),
                  const SizedBox(width: 8.0),
                  RichText(
                    text: TextSpan(
                      text: now.compareTo(cycleGap!.endTime) < 0
                          ? 'Ends on '
                          : 'Ended on ',
                      style: theme.textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: dateFormatService.formatWithLocale(
                              locale, cycleGap!.endTime),
                          style: theme.textTheme.bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ]))
            : const SizedBox(
                height: 0,
              ),
      ],
    );
  }

  void refreshData(num selected, EpochData? value) {
    epoch = networkService.getSpecificEpoch(selected);
    rewardsDate = networkService.getRewardsDate(selected);
    if (selectedPoet != null) {
      cycleGap = networkService.getCycleGapForEpoch(epoch.epoch,
          selectedPoet!.settings.phaseShift, selectedPoet!.settings.cycleGap);
    }
    epochData = value;
  }

  void launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch ${url.toString()}';
    }
  }
}
