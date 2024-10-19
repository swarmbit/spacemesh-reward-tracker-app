import 'package:flutter/cupertino.dart';

import '../data/account_rewards.dart';
import '../data/account_rewards_full.dart';
import '../storage/account_storage.dart';
import './account_service.dart';
import './config/remote_config.dart';
import './network_service.dart';

class HistoryRewardsLoader {
  HistoryRewardsLoader({
    required this.address,
    required this.expectedHistoryRewards,
  });

  String address;
  List<AccountRewards> expectedHistoryRewards;

  final _pageSizeHistory = 10;

  final _pageSize = 20;

  AccountService accountService = AccountService();

  NetworkService networkService = NetworkService();

  RemoteConfig remoteConfig = RemoteConfig();
  AccountStorage accountStorage = AccountStorage();

  List<HistoryAccountReward> loadedHistoryRewards = [];

  Map<String, List<AccountRewards>> receivedRewardsMap = new Map();

  num nextOffset = 0;

  num nextOffsetHistory = 0;

  num lastTotal = 0;

  num firstLayer = 0;

  bool hasMore = true;

  Future<List<HistoryAccountReward>> loadNextPage() async {
    debugPrint("Has more: $hasMore");
    if (hasMore) {
      var rewardsFull = await accountService.getAccountRewardsFromLayer(
          address, _pageSize, nextOffset, firstLayer);
      nextOffset = nextOffset + rewardsFull.rewards.length;

      loadReceivedRewardsMap(rewardsFull);

      var end = nextOffsetHistory + _pageSizeHistory;

      if (expectedHistoryRewards.length < end) {
        end = expectedHistoryRewards.length;
      }

      var nextPage = expectedHistoryRewards
          .getRange(nextOffsetHistory.toInt(), end.toInt())
          .toList();

      debugPrint("Next page size: ${nextPage.length}");
      nextOffsetHistory = nextOffsetHistory + nextPage.length;

      if (nextPage.length < _pageSizeHistory) {
        hasMore = false;
      }

      var currentLayer = networkService.getCurrentLayer();
      return nextPage.map((e) => mapReward(e, currentLayer)).toList();
    }

    return [];
  }

  void loadReceivedRewardsMap(AccountRewardsFull rewardsFull) {
    rewardsFull.rewards.forEach((element) {
      receivedRewardsMap.putIfAbsent(element.layer.toString(), () => []);
      receivedRewardsMap[element.layer.toString()]!.add(element);
    });
  }

  Future<List<HistoryAccountReward>> loadHistoryRewards() async {
    var pageSize = _pageSizeHistory;
    if (expectedHistoryRewards.length < _pageSizeHistory) {
      pageSize = expectedHistoryRewards.length;
    }

    var firstPage = expectedHistoryRewards.getRange(0, pageSize).toList();

    if (firstPage.firstOrNull != null) {
      firstLayer = firstPage.first.layer;
    }

    var offset = 0;
    debugPrint(
        "First page size: ${firstPage.length}, historyPageSize: $_pageSizeHistory");
    hasMore = firstPage.length == _pageSizeHistory;

    await loadReceivedRewards(offset);

    nextOffsetHistory = offset + firstPage.length;

    var currentLayer = networkService.getCurrentLayer();
    return firstPage.map((e) => mapReward(e, currentLayer)).toList();
  }

  HistoryAccountReward mapReward(AccountRewards reward, num currentLayer) {
    var receivedReward = searchAccountReward(reward);
    if (receivedReward == null && reward.layer >= currentLayer - 2) {
      return HistoryAccountReward("Pending", reward, null, reward.nodeName);
    }
    if (receivedReward == null) {
      return HistoryAccountReward("Failed", reward, null, reward.nodeName);
    }
    return HistoryAccountReward("Received", reward,
        AccountService.formatAmount(receivedReward.rewards), reward.nodeName);
  }

  AccountRewards? searchAccountReward(AccountRewards expectedReward) {
    var layersList = receivedRewardsMap[expectedReward.layer.toString()];
    if (layersList == null) {
      return null;
    }
    var index = layersList
        .indexWhere((element) => element.smesherId == expectedReward.smesherId);
    if (index == -1) {
      return null;
    }

    var reward = layersList[index];
    layersList.removeAt(index);
    return reward;
  }

  Future<bool> loadReceivedRewards(num offset) async {
    var rewardsFull = await accountService.getAccountRewardsFromLayer(
        address, _pageSize, offset, firstLayer);
    loadReceivedRewardsMap(rewardsFull);
    nextOffset = offset + _pageSize;
    return true;
  }
}

class HistoryAccountReward {
  final String status;
  final AccountRewards reward;
  final String? amount;

  final String? nodeName;
  HistoryAccountReward(
    this.status,
    this.reward,
    this.amount,
    this.nodeName,
  );
}
