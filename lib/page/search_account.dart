import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../component/account_card.dart';
import '../component/find_account_form.dart';
import '../data/account.dart';
import '../provider/accounts_provider.dart';
import '../service/config/remote_config.dart';

class SearchAccountPage extends StatefulWidget {
  const SearchAccountPage({
    super.key,
  });

  @override
  State<SearchAccountPage> createState() => _SearchAccountPageState();
}

class _SearchAccountPageState extends State<SearchAccountPage> {
  RemoteConfig remoteConfig = RemoteConfig();

  final TextEditingController searchController = TextEditingController();

  Account? account;
  bool accountNotFound = false;

  Widget displayResult(Account? account, List<String> savedAccounts) {
    var theme = Theme.of(context);

    if (accountNotFound == true) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Center(
            child: Text(
          'Account not found!',
          style: theme.textTheme.labelLarge,
        )),
      );
    }
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

    return Scaffold(
        appBar: AppBar(title: const Text('Find Account')),
        body: Padding(
            padding: const EdgeInsets.only(top: 24.0, left: 16, right: 16),
            child: Column(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FindAccountForm(
                      onSearch: (a) => {
                        if (a == null)
                          {
                            setState(() {
                              accountNotFound = true;
                            })
                          }
                        else
                          {
                            setState(() {
                              accountNotFound = false;
                              account = a;
                            })
                          }
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    displayResult(
                        account, savedAccounts.map((e) => e.address).toList()),
                  ],
                )),
              ],
            )));
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
