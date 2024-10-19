import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/account.dart';
import '../data/state/address_label.dart';
import '../page/account_details_route.dart';
import '../page/account_epoch_details_route.dart';
import '../provider/account_details_provider.dart';
import '../provider/account_epoch_details_provider.dart';
import '../provider/accounts_provider.dart';
import '../provider/settings_provider.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({
    super.key,
    required this.address,
    required this.icon,
    // when account passed card assumes it is to save account
    this.account,
  });

  final String address;
  final IconData icon;
  final Account? account;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var brightness =
        Provider.of<SettingsProvider>(context).getSelectedBrightness(
      MediaQuery.of(context).platformBrightness,
    );
    var isLightTheme = brightness == Brightness.light;

    var appState = context.watch<AccountsProvider>();
    var addressLabel = appState.savedAccounts.firstWhere(
      (a) => a.address == address,
      orElse: () => AddressLabel(address, null),
    );

    return Card(
      color: isLightTheme ? theme.cardColor : Colors.teal.withOpacity(0.15),
      clipBehavior: Clip.hardEdge,
      child: Column(children: [
        InkWell(
          splashColor: theme.dialogBackgroundColor,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider(
                    create: (_) => AccountDetailsProvider(
                        isAccountSaved(), account, address),
                    child: AccountDetailsRoute(isSaved: isAccountSaved())),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: ListTile(
              title: _displayTitle(theme, isLightTheme, addressLabel),
              subtitle: _displaySubTitle(theme, addressLabel),
              trailing: IconButton(
                icon: Icon(
                  icon,
                  color: isLightTheme
                      ? theme.iconTheme.color
                      : theme.primaryColorLight,
                ),
                onPressed: () {
                  if (account == null) {
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Remove account'),
                          content: const SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text('Do you want to remove saved account?'),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('YES'),
                              onPressed: () {
                                Navigator.of(context).pop();
                                appState.removeAccount(address);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    account!.setDefaultLabel();
                    appState.addAccount(account!);
                  }
                },
              ),
            ),
          ),
        ),
        isAccountSaved()
            ? Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Column(
                  children: [
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChangeNotifierProvider(
                                    create: (_) => AccountDetailsProvider(
                                        isAccountSaved(), account, address),
                                    child: AccountDetailsRoute(
                                        isSaved: isAccountSaved())),
                              ),
                            );
                          },
                          child: Text(
                            'Details',
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
                        const SizedBox(
                          width: 10,
                        ),
                        const SizedBox(
                          height: 20,
                          child: VerticalDivider(),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            var accountEpochDetailsProvider =
                                AccountEpochDetailsProvider(
                                    address, addressLabel.label);

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
                        )
                      ],
                    )
                  ],
                ))
            : const SizedBox(
                height: 0,
              )
      ]),
    );
  }

  bool isAccountSaved() => account != null ? false : true;

  Widget? _displayTitle(
    ThemeData theme,
    bool isLightTheme,
    AddressLabel details,
  ) {
    TextStyle textStyle = isLightTheme
        ? theme.textTheme.titleMedium!.copyWith(color: theme.primaryColor)
        : theme.textTheme.titleMedium!.copyWith(color: Colors.white);

    if (details.label == null) {
      return Text(
        details.address,
        style: theme.textTheme.bodyMedium!.copyWith(
          color: theme.textTheme.bodyMedium!.color!.withOpacity(0.6),
        ),
      );
    }

    return Text(
      details.label!,
      style: textStyle,
    );
  }

  Widget? _displaySubTitle(
    ThemeData theme,
    AddressLabel details,
  ) {
    if (details.label != null) {
      var label = details.address;
      if (label.length > 22 && isAccountSaved()) {
        label = details.address.substring(details.address.length - 22);
      }
      return Text(
        label,
        style: theme.textTheme.bodyMedium!.copyWith(
          color: theme.textTheme.bodyMedium!.color!.withOpacity(0.6),
        ),
      );
    }
    return null;
  }
}
