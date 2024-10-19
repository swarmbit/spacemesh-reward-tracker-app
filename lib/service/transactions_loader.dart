import 'package:flutter/cupertino.dart';
import '../../data/account_transactions.dart';
import './account_service.dart';

class TransactionsLoader {
  TransactionsLoader({
    required this.address,
  });

  String address;
  final _pageSize = 20;

  AccountService accountService = AccountService();
  List<AccountTransactions> loadedTransactions = [];
  num nextOffset = 0;
  num lastTotal = 0;
  bool hasMore = true;

  Future<List<AccountTransactions>> loadNextPage() async {
    if (hasMore) {
      var transactionsFull = await accountService.getAccountTransactions(address, _pageSize, nextOffset);
      if (lastTotal < transactionsFull.total) {
        // if new rewards were added need to adjust offset and get elements again
        nextOffset = nextOffset + (transactionsFull.total - lastTotal);
        lastTotal = transactionsFull.total;
        transactionsFull = await accountService.getAccountTransactions(address, _pageSize, nextOffset);
      }

      nextOffset = nextOffset + transactionsFull.transactions.length;
      debugPrint("Loaded next page: $nextOffset, $_pageSize");
      var transactionsList = transactionsFull.transactions.toList();
      loadedTransactions.addAll(transactionsList);
      if (transactionsList.length < _pageSize) {
        hasMore = false;
      }
    }
    return loadedTransactions;
  }

  Future<List<AccountTransactions>> loadTransactions() async {
    var offset = 0;
    hasMore = true;
    var transactionsFull = await accountService.getAccountTransactions(address, _pageSize, offset);

    List<AccountTransactions> transactions = [];
    transactions.addAll(transactionsFull.transactions);

    loadedTransactions = transactions;
    nextOffset = offset + loadedTransactions.length;
    lastTotal = transactionsFull.total;
    return loadedTransactions;
  }

}
