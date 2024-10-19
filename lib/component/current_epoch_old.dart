/*
class CurrentEpoch extends StatefulWidget {
  const CurrentEpoch({
    Key? key,
    required this.currentLayer,
  }) : super(key: key);

  final num currentLayer;

  @override
  State<CurrentEpoch> createState() => _CurrentEpochState();
}

class _CurrentEpochState extends State<CurrentEpoch> {
  NetworkService networkService = NetworkService();
  DateFormatService dateFormatService = DateFormatService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    Locale locale = Localizations.localeOf(context);

    var brightness = Provider.of<ThemeProvider>(context).getSelectedBrightness(
      MediaQuery.of(context).platformBrightness,
    );

    var epoch = networkService.getEpoch();
    var nextCycleGap = networkService.getNextCycleGap();

    var networkInfo = networkService.getNetworkInfo();

    var endTime = dateFormatService.formatWithLocale(locale, epoch.endTime);

    var cycleGapStartTime =
        dateFormatService.formatWithLocale(locale, nextCycleGap.startTime);
    var cycleGapEndTime =
        dateFormatService.formatWithLocale(locale, nextCycleGap.endTime);

    var nextRewardsTime =
        dateFormatService.formatWithLocale(locale, nextCycleGap.rewardsStart);

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current epoch',
                  style: theme.textTheme.headlineSmall,
                ),
                Text(
                  epoch.epoch.toString(),
                  style: brightness == Brightness.light
                      ? theme.textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor)
                      : theme.textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColorLight),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                const Icon(
                  Icons.date_range_rounded,
                ),
                const SizedBox(width: 8.0),
                RichText(
                  text: TextSpan(
                    text: 'Ending on ',
                    style: theme.textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: endTime,
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
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                const Icon(
                  Icons.layers_rounded,
                ),
                const SizedBox(width: 8.0),
                RichText(
                  text: TextSpan(
                    text: 'Current layer: ',
                    style: theme.textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: widget.currentLayer.toString(),
                        style: theme.textTheme.bodyMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          networkInfo != null
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.drive_folder_upload_rounded,
                      ),
                      const SizedBox(width: 8.0),
                      RichText(
                        text: TextSpan(
                          text: 'Network space: ',
                          style: theme.textTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: networkInfo.networkSize,
                              style: theme.textTheme.bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
          networkInfo != null
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.money_rounded,
                      ),
                      const SizedBox(width: 8.0),
                      RichText(
                        text: TextSpan(
                          text: 'Circulating supply: ',
                          style: theme.textTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: networkInfo.circulatingSupply,
                              style: theme.textTheme.bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
          networkInfo != null && networkInfo.price != null
              ? Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                const Icon(
                  Icons.currency_exchange_outlined,
                ),
                const SizedBox(width: 8.0),
                RichText(
                  text: TextSpan(
                    text: 'Price: ',
                    style: theme.textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: networkInfo.price,
                        style: theme.textTheme.bodyMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ) : const SizedBox(),
          networkInfo != null
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.account_box_rounded,
                      ),
                      const SizedBox(width: 8.0),
                      RichText(
                        text: TextSpan(
                          text: 'Accounts: ',
                          style: theme.textTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: networkInfo.accounts,
                              style: theme.textTheme.bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
          networkInfo != null
              ? Builder(builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      children: [
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
                                text: networkInfo.smeshers,
                                style: theme.textTheme.bodyMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        InkWell(
                          onTap: () async {
                            final box =
                                context.findRenderObject() as RenderBox?;
                            if (box != null) {
                              final Rect rect =
                                  box.localToGlobal(Offset.zero) & box.size;
                              await Share.share(
                                'hex: ${networkInfo.atxHex}, base64: ${networkInfo.atxBase64}',
                                // needed to work on ipad
                                sharePositionOrigin: rect,
                              );
                            }
                          },
                          child: Text(
                            'Get highest atx',
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
                        )
                      ],
                    ),
                  );
                })
              : const SizedBox(),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Next cycle gap',
              style: brightness == Brightness.light
                  ? theme.textTheme.titleMedium!.copyWith(
                      color: theme.primaryColor, fontWeight: FontWeight.bold)
                  : theme.textTheme.titleMedium!.copyWith(
                      color: theme.primaryColorLight,
                      fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: RichText(
              text: TextSpan(
                text: 'From: ',
                style: theme.textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: cycleGapStartTime,
                    style: theme.textTheme.bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: RichText(
              text: TextSpan(
                text: 'To: ',
                style: theme.textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: cycleGapEndTime,
                    style: theme.textTheme.bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: RichText(
              text: TextSpan(
                text: 'Rewards for new joiners: ',
                style: theme.textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: 'Epoch ${nextCycleGap.rewardsOnEpoch}',
                    style: theme.textTheme.bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
          RichText(
            text: TextSpan(
              text: 'Starting on ',
              style: theme.textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: nextRewardsTime,
                  style: theme.textTheme.bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

 */
