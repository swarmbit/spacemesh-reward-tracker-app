import 'dart:async';

import 'package:flutter/material.dart';
import 'package:humanize_duration/humanize_duration.dart';
import 'package:provider/provider.dart';

import '../data/account_rewards.dart';
import '../provider/account_epoch_details_provider.dart';
import '../service/date_format_service.dart';
import '../service/history_rewards_loader.dart';
import '../service/network_service.dart';
import './coloured_reward_status.dart';

class ExpectedRewardsList extends StatefulWidget {
  const ExpectedRewardsList({
    Key? key,
    required this.address,
    required this.epoch,
  }) : super(key: key);

  final String address;
  final num epoch;

  @override
  State<ExpectedRewardsList> createState() => _ExpectedRewardsListState();
}

class _ExpectedRewardsListState extends State<ExpectedRewardsList>
    with SingleTickerProviderStateMixin {
  DateFormatService dateFormatService = DateFormatService();
  NetworkService networkService = NetworkService();

  late TabController _tabController;

  late HistoryRewardsLoader historyRewardsLoader;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    Locale locale = Localizations.localeOf(context);

    var accountEpochDetailsProvider =
        context.watch<AccountEpochDetailsProvider>();

    debugPrint(
        "Show expected rewards list: ${accountEpochDetailsProvider.expectedLayers!.length}");

    var historyScrollController = ScrollController();
    historyScrollController.addListener(() {
      if (historyScrollController.position.pixels ==
          historyScrollController.position.maxScrollExtent) {
        accountEpochDetailsProvider
            .loadNextRewardHistoryPage()
            .then((value) => debugPrint("Load next page"))
            .onError((error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to load next reward history page!'),
            ),
          );
        });
      }
    });

    var historyRewardsList = createHistoryRewardsList(historyScrollController,
        accountEpochDetailsProvider.historyPage, theme, locale);
    var upcomingRewardsList = createUpcomingRewardsList(
        accountEpochDetailsProvider.upcoming, theme, locale);

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              child: Text(
                'History',
                style: theme.textTheme.titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Tab(
              child: Text(
                'Upcoming',
                style: theme.textTheme.titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        Expanded(
            child: TabBarView(
          controller: _tabController,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 0),
              child: historyRewardsList,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 0),
              child: upcomingRewardsList,
            ),
          ],
        ))
      ],
    );
  }

  Widget createHistoryRewardsList(ScrollController scrollController,
      List<HistoryAccountReward> rewards, ThemeData theme, Locale locale) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      itemCount: rewards.length,
      controller: scrollController,
      itemBuilder: (context, index) {
        var reward = rewards[index];
        return createRewardItem(
            reward.status,
            reward.amount,
            reward.reward.smesherId,
            reward.reward.layer,
            reward.reward.time,
            reward.nodeName,
            theme,
            locale);
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }

  Widget createUpcomingRewardsList(
      List<AccountRewards> rewards, ThemeData theme, Locale locale) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      itemCount: rewards.length,
      itemBuilder: (context, index) {
        var reward = rewards[index];
        return createRewardItem(null, null, reward.smesherId, reward.layer,
            reward.time, reward.nodeName, theme, locale);
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }

  String _formatSmesherId(String smesherId) {
    var length = smesherId.length;
    return "${smesherId.substring(0, 10)}...${smesherId.substring(length - 10, length)}";
  }

  Widget createRewardItem(String? status, String? amount, String smesherId,
      num layer, num time, String? nodeName, ThemeData theme, Locale locale) {
    var dateTimeMillis = time.toInt() * 1000;

    var rewardDateString = DateTime.fromMillisecondsSinceEpoch(dateTimeMillis);

    var timeLeft = dateTimeMillis - DateTime.now().millisecondsSinceEpoch;
    String? duration;
    if (timeLeft > 0) {
      var durationObj = Duration(milliseconds: timeLeft);
      if (timeLeft < 60000) {
        // show 1 minute when is below 1 minute
        durationObj = const Duration(milliseconds: 60001);
      }
      duration = humanizeDuration(
        durationObj,
        language: const EnLanguage(),
        options:
            const HumanizeOptions(units: [Units.day, Units.hour, Units.minute]),
      );
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      duration != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("In:"),
                Text(duration),
              ],
            )
          : const SizedBox(
              height: 0,
            ),
      status != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Status:"),
                ColouredRewardStatus(
                  status: status,
                )
              ],
            )
          : const SizedBox(
              height: 0,
            ),
      amount != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Amount:',
                  style: theme.textTheme.labelLarge,
                ),
                Text(" $amount"),
              ],
            )
          : const SizedBox(
              height: 0,
            ),
      nodeName != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Name:',
                  style: theme.textTheme.labelLarge,
                ),
                Text(" $nodeName"),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Plot Id:',
                  style: theme.textTheme.labelLarge,
                ),
                Text(" ${_formatSmesherId(smesherId)}"),
              ],
            ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Layer:',
            style: theme.textTheme.labelLarge,
          ),
          Text(" $layer"),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Time:',
            style: theme.textTheme.labelLarge,
          ),
          Text(dateFormatService.formatWithLocale(locale, rewardDateString)),
        ],
      ),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
