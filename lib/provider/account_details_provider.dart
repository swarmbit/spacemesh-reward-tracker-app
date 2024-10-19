import 'package:flutter/material.dart';
import 'package:spacemesh_reward_tracker/data/account_transactions.dart';
import 'package:spacemesh_reward_tracker/service/network_service.dart';
import 'package:spacemesh_reward_tracker/service/transactions_loader.dart';

import '../data/account.dart';
import '../service/account_service.dart';
import '../service/rewards_loader.dart';
import '../storage/account_storage.dart';

class AccountDetailsProvider extends ChangeNotifier {
  AccountStorage accountStorage = AccountStorage();
  AccountService accountService = AccountService();
  NetworkService networkService = NetworkService();

  bool isRefreshing = false;
  late Account account;
  late bool isSaved;
  late RewardsLoader rewardsLoader;
  late TransactionsLoader transactionsLoader;

  List<AccountTransactions>? accountTransactions;
  List<AccountRewardView>? accountRewards;
  num numberOfRewards = 0;
  int numberNewRewards = 0;

  AccountDetailsProvider(this.isSaved, Account? account, String address) {
    if (account != null) {
      this.account = account;
    } else if (isSaved) {
      this.account = accountStorage.getAccount(address)!;
    } else {
      this.account = Account(address, 0, "", "", 0, 0, numberOfRewards, 0, "");
    }
    rewardsLoader = RewardsLoader(address: this.account.address);
    transactionsLoader = TransactionsLoader(address: this.account.address);
    loadData();
  }

  void loadData() {
    _refreshData().then((value) => debugPrint("Load rewards"));
  }

  void refreshData(context) {
    _refreshData().onError((error, stackTrace) {
      isRefreshing = false;
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to fetch account data!'),
        ),
      );
    });
  }

  void loadNextRewardsPage(context) {
    if (!isRefreshing) {
      isRefreshing = true;
      notifyListeners();

      rewardsLoader.loadNextPage().then((rewards) {
        isRefreshing = false;
        accountRewards = rewards.rewards;
        notifyListeners();
      }).onError((error, stackTrace) {
        isRefreshing = false;
        notifyListeners();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to fetch account data!'),
          ),
        );
      });
    }
  }

  void loadNextTransactionsPage(context) {
    if (!isRefreshing) {
      isRefreshing = true;
      notifyListeners();

      transactionsLoader.loadNextPage().then((transactions) {
        isRefreshing = false;
        accountTransactions = transactions;
        notifyListeners();
      }).onError((error, stackTrace) {
        isRefreshing = false;
        notifyListeners();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to fetch account data!'),
          ),
        );
      });
    }
  }

  Future<void> _refreshData() async {
    if (!isRefreshing) {
      isRefreshing = true;
      notifyListeners();

      var accountCall = accountService.getAccount(account.address);

      var epoch = networkService.getEpoch();
      var epochDetailsCall = accountService.getAccountRewardsEpochDetails(
          account.address, epoch.epoch);

      var rewardsCall = rewardsLoader.loadRewards();
      var transactionsCall = transactionsLoader.loadTransactions();

      var accountResponse = await accountCall;
      var rewards = await rewardsCall;
      var transactions = await transactionsCall;
      accountRewards = rewards.rewards;
      accountTransactions = transactions;
      numberOfRewards = rewards.totalNumberOfRewards;
      numberNewRewards = rewards.numberOfNewRewards;
      notifyListeners();
      if (accountResponse != null) {
        account.label != null
            ? accountResponse.setLabel(account.label!)
            : accountResponse.setDefaultLabel();

        if (isSaved) {
          accountStorage.updateAccount(accountResponse);
        }
        account = accountResponse;
        notifyListeners();
      }

      isRefreshing = false;
    }
  }
}
