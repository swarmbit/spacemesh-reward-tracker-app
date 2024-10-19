import 'package:flutter/material.dart';
import 'package:spacemesh_reward_tracker/service/account_epoch_atx_loader.dart';

import '../data/account_epoch_atx.dart';
import '../service/analytics/analytics.dart';
import '../service/date_format_service.dart';

class AccountEpochAtxRoute extends StatefulWidget {
  const AccountEpochAtxRoute({
    super.key,
    required this.account,
    required this.epoch,
  });

  final String account;
  final num epoch;

  @override
  State<AccountEpochAtxRoute> createState() => _AccountEpochAtxRouteState();
}

class _AccountEpochAtxRouteState extends State<AccountEpochAtxRoute> {
  Analytics analytics = Analytics();

  late AccountEpochAtxLoader loader;

  DateFormatService dateFormatService = DateFormatService();

  List<AccountEpochAtx>? accountEpochAtxs;

  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
    loader =
        AccountEpochAtxLoader(address: widget.account, epoch: widget.epoch);
    loadAtx();
    analytics.sendCurrentAnalytics("account_epoch_atx");
  }

  void loadAtx() {
    if (!isRefreshing) {
      isRefreshing = true;
      if (mounted) {
        setState(() {
          isRefreshing = true;
        });
      }
      loader.loadAccountEpochAtx().then((value) {
        if (mounted) {
          setState(() {
            isRefreshing = false;
            accountEpochAtxs = value;
          });
        }
      }).onError((error, stackTrace) {
        if (mounted) {
          setState(() {
            isRefreshing = false;
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load atx epoch!'),
          ),
        );
      });
    }
  }

  void loadNextAtxPage() {
    if (!isRefreshing) {
      isRefreshing = true;
      if (mounted) {
        setState(() {
          isRefreshing = true;
        });
      }
      loader.loadNextPage().then((value) {
        if (mounted) {
          setState(() {
            isRefreshing = false;
            if (value.isNotEmpty) {
              accountEpochAtxs = value;
            }
          });
        }
      }).onError((error, stackTrace) {
        if (mounted) {
          setState(() {
            isRefreshing = false;
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load atx epoch!'),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        loadNextAtxPage();
      }
    });
    var theme = Theme.of(context);
    Locale locale = Localizations.localeOf(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Activations'),
          actions: [
            IconButton(
              onPressed: () => loadAtx(),
              icon: isRefreshing
                  ? const CircularProgressIndicator(
                      backgroundColor: Colors.transparent,
                    )
                  : const Icon(Icons.refresh),
            )
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
            child: accountEpochAtxs != null && accountEpochAtxs!.isNotEmpty
                ? ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    controller: scrollController,
                    itemCount: accountEpochAtxs!.length,
                    itemBuilder: (context, index) {
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'ATX ID:',
                                  style: theme.textTheme.labelLarge,
                                ),
                                Text(
                                    " ${_formatId(accountEpochAtxs![index].atxId)}"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Node ID:',
                                  style: theme.textTheme.labelLarge,
                                ),
                                Text(
                                    " ${_formatId(accountEpochAtxs![index].nodeId)}"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Data Size:',
                                  style: theme.textTheme.labelLarge,
                                ),
                                Text(
                                    " ${accountEpochAtxs![index].postDataSize}"),
                              ],
                            ),
                          ]);
                    },
                    separatorBuilder: (context, index) => const Divider(),
                  )
                : accountEpochAtxs != null && accountEpochAtxs!.isEmpty
                    ? const Center(child: Text('No atx'))
                    : const SizedBox(
                        height: 0,
                      )));
  }

  String _formatId(String smesherId) {
    var length = smesherId.length;
    return "${smesherId.substring(0, 10)}...${smesherId.substring(length - 10, length)}";
  }
}
