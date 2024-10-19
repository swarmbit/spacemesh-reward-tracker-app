import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/account_details_provider.dart';
import '../service/date_format_service.dart';
import 'coloured_label_box.dart';

class RewardList extends StatefulWidget {
  const RewardList({
    Key? key,
  }) : super(key: key);

  @override
  State<RewardList> createState() => _RewardListState();
}

class _RewardListState extends State<RewardList> {
  DateFormatService dateFormatService = DateFormatService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    Locale locale = Localizations.localeOf(context);
    var accountDetailsProvider = context.watch<AccountDetailsProvider>();
    var accountRewards = accountDetailsProvider.accountRewards;
    var numberNewRewards = accountDetailsProvider.numberNewRewards;
    var scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        accountDetailsProvider.loadNextRewardsPage(context);
      }
    });

    return accountRewards != null && accountRewards.isNotEmpty
        ? ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            controller: scrollController,
            itemCount: accountRewards.length,
            itemBuilder: (context, index) {
              var isNewReward = index < numberNewRewards;
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isNewReward
                        ? const ColouredLabelBox(text: 'New')
                        : const SizedBox(height: 0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Amount:',
                          style: theme.textTheme.labelLarge,
                        ),
                        Text(" ${accountRewards[index].rewardDisplay}"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Plot Id:',
                          style: theme.textTheme.labelLarge,
                        ),
                        Text(
                            " ${_formatSmesherId(accountRewards[index].smesherId)}"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Layer:',
                          style: theme.textTheme.labelLarge,
                        ),
                        Text(" ${accountRewards[index].layer}"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Time:',
                          style: theme.textTheme.labelLarge,
                        ),
                        Text(dateFormatService.formatWithLocale(
                            locale,
                            DateTime.fromMillisecondsSinceEpoch(
                                accountRewards[index].time.toInt()))),
                      ],
                    ),
                  ]);
            },
            separatorBuilder: (context, index) => const Divider(),
          )
        : accountRewards != null
            ? const Center(child: Text('No rewards'))
            : const SizedBox(
                height: 0,
              );
  }

  String _formatSmesherId(String smesherId) {
    var length = smesherId.length;
    return "${smesherId.substring(0, 10)}...${smesherId.substring(length - 10, length)}";
  }

  @override
  void dispose() {
    super.dispose();
  }
}
