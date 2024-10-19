import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacemesh_reward_tracker/service/account_service.dart';

import '../provider/accounts_provider.dart';
import '../provider/settings_provider.dart';

class BalanceCard extends StatefulWidget {
  const BalanceCard({super.key, required this.accountsProvider});

  final AccountsProvider accountsProvider;

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> with WidgetsBindingObserver {
  AccountService accountService = AccountService();

  Timer? refreshTimer;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startRefreshTimer();
  }

  void _startRefreshTimer() {
    refreshTimer = Timer.periodic(
      const Duration(seconds: 30),
      (Timer timer) {
        debugPrint("Refresh account group");
        widget.accountsProvider.refreshAccountGroup();
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      debugPrint("Pause timer");
      refreshTimer?.cancel();
    } else if (state == AppLifecycleState.resumed) {
      debugPrint("Start timer");
      _startRefreshTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var appState = context.watch<AccountsProvider>();
    var accountGroup = appState.accountGroup;

    var settingsProvider = Provider.of<SettingsProvider>(context);

    var brightness = settingsProvider.getSelectedBrightness(
      MediaQuery.of(context).platformBrightness,
    );

    String balance = "0 SMH";
    String? usdValue = "\$0";

    if (accountGroup != null) {
      balance = accountGroup.balance;
      usdValue = accountGroup.usdValue;
    }

    Color fillColor;
    switch (brightness) {
      case Brightness.light:
        fillColor = theme.cardColor.withOpacity(0.9);
        break;
      case Brightness.dark:
        fillColor = Colors.teal.withOpacity(0.15);
        break;
    }
    return Card(
        elevation: 0.3,
        color: fillColor,
        child: ListTile(
          leading: const Icon(Icons.account_balance_rounded),
          title:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              balance,
              style: theme.textTheme.headlineMedium,
            ),
            usdValue != null && settingsProvider.isShowValue
                ? Text(
                    usdValue,
                    style: theme.textTheme.titleLarge,
                  )
                : const SizedBox(
                    height: 0,
                  ),
          ]),
          dense: false,
        ));
  }

  @override
  void dispose() {
    debugPrint("Cancel timer on page dispose");
    refreshTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
