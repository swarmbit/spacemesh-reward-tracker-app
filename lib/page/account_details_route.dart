import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../component/reward_list.dart';
import '../component/transactions_list.dart';
import '../provider/account_details_provider.dart';
import '../provider/account_epoch_details_provider.dart';
import '../provider/accounts_provider.dart';
import '../provider/settings_provider.dart';
import '../service/account_service.dart';
import '../service/analytics/analytics.dart';
import '../service/network_service.dart';
import '../storage/account_storage.dart';
import 'account_epoch_details_route.dart';

class AccountDetailsRoute extends StatefulWidget {
  const AccountDetailsRoute({
    Key? key,
    required this.isSaved,
  }) : super(key: key);

  final bool isSaved;

  @override
  State<AccountDetailsRoute> createState() => _AccountDetailsRouteState();
}

class _AccountDetailsRouteState extends State<AccountDetailsRoute>
    with SingleTickerProviderStateMixin {
  AccountService accountService = AccountService();
  AccountStorage accountStorage = AccountStorage();
  NetworkService networkService = NetworkService();

  Analytics analytics = Analytics();

  late TabController _tabController;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();

    analytics.sendCurrentAnalytics("account_details");

    _textEditingController = TextEditingController();
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<AccountsProvider>();

    var accountDetailsProvider = context.watch<AccountDetailsProvider>();
    var account = accountDetailsProvider.account;

    var settingsProvider = Provider.of<SettingsProvider>(context);
    var brightness = settingsProvider.getSelectedBrightness(
      MediaQuery.of(context).platformBrightness,
    );

    debugPrint('Details route: ${account.toJson().toString()}');

    var labelTheme =
        theme.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account details'),
        actions: [
          IconButton(
            onPressed: () => accountDetailsProvider.refreshData(context),
            icon: accountDetailsProvider.isRefreshing
                ? const CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                  )
                : const Icon(Icons.refresh),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.isSaved
                ? ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: -4.0, vertical: -4.0),
                    leading: const Icon(Icons.flag),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        final label = await openLabelDialog();

                        if (label == null || label.isEmpty) return;
                        account.setLabel(label);
                        await accountStorage.updateAccount(account);

                        setState(() => appState.loadAccounts());
                      },
                    ),
                    title: Text(
                      'Label',
                      style: labelTheme,
                    ),
                    subtitle: Text(
                      account.label != null
                          ? account.label!
                          : '<account label>',
                    ),
                  )
                : const SizedBox(),
            ListTile(
                visualDensity:
                    const VisualDensity(horizontal: -4.0, vertical: -4.0),
                leading: const Icon(Icons.location_on_rounded),
                title: Text(
                  'Address',
                  style: labelTheme,
                ),
                subtitle: InkWell(
                  child: Text(
                    account.address,
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
                      final Rect rect =
                          box.localToGlobal(Offset.zero) & box.size;
                      await Share.share(
                        account.address,
                        // needed to work on ipad
                        sharePositionOrigin: rect,
                      );
                    }
                  },
                )),
            Row(mainAxisSize: MainAxisSize.max, children: [
              Flexible(
                  flex: 10,
                  child: ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: -4.0, vertical: -4.0),
                    leading: const Icon(Icons.account_balance_rounded),
                    title: Text(
                      'Balance',
                      style: labelTheme,
                    ),
                    subtitle: Text(account.balanceDisplay),
                  )),
              Flexible(
                flex: 10,
                child:
                    account.dollarValue != null && settingsProvider.isShowValue
                        ? ListTile(
                            visualDensity: const VisualDensity(
                                horizontal: -4.0, vertical: -4.0),
                            leading: const Icon(Icons.attach_money_outlined),
                            title: Text(
                              'Value',
                              style: labelTheme,
                            ),
                            subtitle: Text(account.dollarValue!),
                          )
                        : const SizedBox(),
              )
            ]),
            Row(mainAxisSize: MainAxisSize.max, children: [
              Flexible(
                flex: 10,
                child: ListTile(
                  visualDensity:
                      const VisualDensity(horizontal: -4.0, vertical: -4.0),
                  leading: const Icon(Icons.account_balance_wallet_rounded),
                  title: Text(
                    'Total rewards',
                    style: labelTheme,
                  ),
                  subtitle: account.totalRewardsDisplay != null
                      ? Text(account.totalRewardsDisplay!)
                      : const Text(""),
                ),
              ),
              Flexible(
                flex: 8,
                child: InkWell(
                  onTap: () async {
                    var accountEpochDetailsProvider =
                        AccountEpochDetailsProvider(
                            account.address, account.label);
                    accountEpochDetailsProvider.initialize(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChangeNotifierProvider(
                            create: (_) => accountEpochDetailsProvider,
                            child: const AccountEpochDetailsRoute()),
                      ),
                    );
                  },
                  child: Text(
                    'Rewards details',
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
                ),
              )
            ]),
            TabBar(
              controller: _tabController,
              tabs: <Widget>[
                Tab(
                  child: Text(
                    'Rewards',
                    style: theme.textTheme.titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  child: Text(
                    'Transactions',
                    style: theme.textTheme.titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Expanded(
                child: TabBarView(
              controller: _tabController,
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 0),
                  child: RewardList(),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 0),
                  child: TransactionsList(),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }

  Future<String?> openLabelDialog() {
    var theme = Theme.of(context);

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Account label',
          style: theme.textTheme.titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        titlePadding: const EdgeInsets.fromLTRB(24.0, 16.0, 16.0, 8.0),
        content: TextField(
          controller: _textEditingController,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Enter account label'),
        ),
        contentPadding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(_textEditingController.text),
            child: const Text('SAVE'),
          )
        ],
        actionsPadding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      ),
    );
  }
}
