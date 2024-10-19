import 'dart:async';

import 'package:flutter/material.dart';

import '../data/account_rewards.dart';
import '../data/account_rewards_epoch_details.dart';
import '../service/account_epoch_layers_service.dart';
import '../service/account_service.dart';
import '../service/history_rewards_loader.dart';
import '../service/network_service.dart';

class AccountEpochDetailsProvider extends ChangeNotifier {
  AccountService accountService = AccountService();
  NetworkService networkService = NetworkService();

  late String address;

  late String? label;

  AccountRewardsEpochDetails? rewardsDetails;
  bool isRefreshing = false;

  AccountEpochLayersService accountEpochLayersService =
      AccountEpochLayersService();

  List<HistoryAccountReward> historyPage = [];

  late List<AccountRewards> history;

  late List<AccountRewards> upcoming;

  List<AccountRewards>? expectedLayers;

  late num selectedEpoch;

  late HistoryRewardsLoader? historyRewardsLoader;

  bool hasInitialized = false;

  bool failedLoading = false;

  AccountEpochDetailsProvider(this.address, this.label) {
    selectedEpoch = networkService.getEpoch().epoch;
    setExpectedLayers(accountEpochLayersService.getAccountExpectedLayers(
            address, selectedEpoch))
        .then((value) => debugPrint("Load rewards history"));
  }

  void initialize(context) {
    if (!hasInitialized) {
      hasInitialized = true;
      refreshRewardDetails(context);
    }
  }

  Future<bool> setSelectedEpoch(num selectedEpoch, context) async {
    this.selectedEpoch = selectedEpoch;
    await refreshRewardDetailsAsync(context);
    notifyListeners();
    return true;
  }

  void setRefreshing(bool refreshing) {
    isRefreshing = refreshing;
    notifyListeners();
  }

  void refreshRewardDetails(context) {
    refreshRewardDetailsAsync(context)
        .then((value) => debugPrint("Refreshed details"));
  }

  Future<bool> refreshRewardDetailsAsync(context) async {
    if (!isRefreshing) {
      isRefreshing = true;
      rewardsDetails = null;
      notifyListeners();

      try {
        var value = await accountService.getAccountRewardsEpochDetails(
            address, selectedEpoch);
        rewardsDetails = value;
        failedLoading = false;
        await setExpectedLayers(accountEpochLayersService
            .getAccountExpectedLayers(address, selectedEpoch));
        isRefreshing = false;
        notifyListeners();
      } catch (e) {
        failedLoading = true;
        isRefreshing = false;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Failed to fetch epoch reward details!')));
        notifyListeners();
      }
    }
    return true;
  }

  Future<bool> removeExpectedLayers() async {
    history = [];
    upcoming = [];
    historyPage = [];
    expectedLayers = null;
    historyRewardsLoader = null;
    notifyListeners();
    return true;
  }

  Future<bool> setExpectedLayers(List<AccountRewards>? expectedLayers) async {
    if (expectedLayers != null) {
      var layer = networkService.getCurrentLayer();
      history = [];
      upcoming = [];
      expectedLayers.forEach((element) {
        if (element.layer <= layer) {
          history.add(element);
        } else {
          upcoming.add(element);
        }
      });

      upcoming = upcoming.reversed.toList();

      historyRewardsLoader = HistoryRewardsLoader(
          address: address, expectedHistoryRewards: history);
      var page = await historyRewardsLoader!.loadHistoryRewards();

      historyPage = page;
      this.expectedLayers = expectedLayers;

      notifyListeners();
    } else {
      this.expectedLayers = null;
    }
    return true;
  }

  Future<bool> loadNextRewardHistoryPage() async {
    if (historyRewardsLoader != null) {
      isRefreshing = true;
      notifyListeners();
      var value = await historyRewardsLoader!.loadNextPage();
      historyPage.addAll(value);
      isRefreshing = false;
      notifyListeners();
    }
    return true;
  }
}
