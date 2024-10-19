import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacemesh_reward_tracker/component/balance_card.dart';

import '../component/account_card.dart';
import '../data/account.dart';
import '../provider/accounts_provider.dart';
import './search_account.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Account? account;

  Widget displayResult(Account? account, List<String> savedAccounts) {
    var theme = Theme.of(context);

    if (account != null) {
      if (savedAccounts.any((element) => element == account.address)) {
        return AccountCard(
            address: account.address, icon: Icons.bookmark_remove);
      }
      return AccountCard(
          account: account,
          address: account.address,
          icon: Icons.bookmark_add_outlined);
    } else {
      return const SizedBox(height: 4.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var appState = context.watch<AccountsProvider>();
    var savedAccounts = appState.savedAccounts;
    var accountsInitFinished = appState.initFinished;

    return Scaffold(
        floatingActionButton: savedAccounts.isNotEmpty
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SearchAccountPage(),
                    ),
                  );
                },
                tooltip: 'Add account',
                backgroundColor: theme.colorScheme.surfaceVariant,
                child: const Icon(Icons.add),
              )
            : FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SearchAccountPage(),
                    ),
                  );
                },
                tooltip: 'Add account',
                backgroundColor: theme.colorScheme.surfaceVariant,
                icon: const Icon(Icons.add), // Icon inside the button
                label: const Text('Add account'),
              ),
        body: Column(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BalanceCard(
                  accountsProvider: appState,
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 16.0, left: 8),
                    child: Text(
                      'Accounts',
                      style: theme.textTheme.titleLarge,
                    )),
                accountsInitFinished && savedAccounts.isEmpty
                    ? const Expanded(
                        child: Center(child: Text('No saved accounts yet!')))
                    : Expanded(
                        child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: RefreshIndicator(
                          onRefresh: () {
                            return appState
                                .refreshAccountGroup()
                                .then((value) => debugPrint("Refresh account"))
                                .onError((error, stackTrace) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Failed to refresh accounts'),
                                ),
                              );
                            });
                          },
                          child: ListView.builder(
                            itemCount: savedAccounts.length,
                            itemBuilder: (BuildContext context, int index) {
                              return AccountCard(
                                address: savedAccounts[index].address,
                                icon: Icons.bookmark_remove,
                              );
                            },
                          ),
                        ),
                      )),
              ],
            )),
          ],
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
