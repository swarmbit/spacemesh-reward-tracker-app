import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacemesh_reward_tracker/component/coloured_transaction_status_box.dart';

import '../page/account_details_route.dart';
import '../provider/account_details_provider.dart';
import '../provider/settings_provider.dart';
import '../service/date_format_service.dart';

class TransactionsList extends StatefulWidget {
  const TransactionsList({
    Key? key,
  }) : super(key: key);

  @override
  State<TransactionsList> createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
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
    var transactions = accountDetailsProvider.accountTransactions;
    var scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        accountDetailsProvider.loadNextTransactionsPage(context);
      }
    });

    var brightness =
        Provider.of<SettingsProvider>(context).getSelectedBrightness(
      MediaQuery.of(context).platformBrightness,
    );

    return transactions != null && transactions.isNotEmpty
        ? ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            controller: scrollController,
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              var transaction = transactions[index];
              var spawn = false;
              var vaultDrain = false;
              var status = "";
              if (transaction.method == "Spawn") {
                spawn = true;
                status = "Spawn ${transaction.status}";
              }
              if (transaction.method == "DrainVault") {
                vaultDrain = true;
                status = "Vault Drain ${transaction.status}";
              } else if (transaction.received) {
                status = "Received ${transaction.status}";
              } else {
                status = "Sent ${transaction.status}";
              }

              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${transaction.id.substring(0, 8)}"),
                        ColouredTransactionStatusBox(
                          text: status,
                          status: transaction.status,
                          method: transaction.method,
                          received: transaction.received,
                        )
                      ],
                    ),
                    !spawn && transaction.received
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'From:',
                                style: theme.textTheme.labelLarge,
                              ),
                              InkWell(
                                child: Text(
                                  _formatLongId(transaction.principalAccount),
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
                                  onAccountTap(transaction.principalAccount);
                                },
                              )
                            ],
                          )
                        : const SizedBox(
                            height: 0,
                          ),
                    vaultDrain
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Vault:',
                                style: theme.textTheme.labelLarge,
                              ),
                              InkWell(
                                child: Text(
                                  _formatLongId(transaction.vaultAccount),
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
                                  onAccountTap(transaction.vaultAccount);
                                },
                              )
                            ],
                          )
                        : const SizedBox(
                            height: 0,
                          ),
                    !spawn && !transaction.received
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'To:',
                                style: theme.textTheme.labelLarge,
                              ),
                              InkWell(
                                child: Text(
                                  _formatLongId(transaction.receiverAccount),
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
                                  onAccountTap(transaction.receiverAccount);
                                },
                              )
                            ],
                          )
                        : const SizedBox(
                            height: 0,
                          ),
                    transactions[index].amount != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Amount:',
                                style: theme.textTheme.labelLarge,
                              ),
                              Text(" ${transaction.amount}"),
                            ],
                          )
                        : const SizedBox(
                            height: 0,
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Fee:',
                          style: theme.textTheme.labelLarge,
                        ),
                        Text(" ${transaction.fee}"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Layer:',
                          style: theme.textTheme.labelLarge,
                        ),
                        Text(" ${transaction.layer}"),
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
                                transaction.timestamp.toInt()))),
                      ],
                    ),
                  ]);
            },
            separatorBuilder: (context, index) => const Divider(),
          )
        : transactions != null
            ? const Center(child: Text('No transactions'))
            : const SizedBox(
                height: 0,
              );
  }

  void onAccountTap(String address) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
            create: (_) => AccountDetailsProvider(false, null, address),
            child: AccountDetailsRoute(isSaved: false)),
      ),
    );
  }

  String _formatLongId(String id) {
    var length = id.length;
    return "${id.substring(0, 10)}...${id.substring(length - 10, length)}";
  }

  @override
  void dispose() {
    super.dispose();
  }
}
