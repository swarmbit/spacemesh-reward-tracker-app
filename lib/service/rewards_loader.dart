import 'package:flutter/cupertino.dart';

import '../storage/account_storage.dart';
import './account_service.dart';
import './config/remote_config.dart';

class RewardsLoader {
  RewardsLoader({
    required this.address,
  });

  String address;
  final _pageSize = 20;

  AccountService accountService = AccountService();
  RemoteConfig remoteConfig = RemoteConfig();
  AccountStorage accountStorage = AccountStorage();
  AccountRewardsView accountRewards = AccountRewardsView(
      totalNumberOfRewards: 0, rewards: [], numberOfNewRewards: 0);

  List<AccountRewardView> loadedRewards = [];
  num nextOffset = 0;
  num lastTotal = 0;
  bool hasMore = true;

  Future<AccountRewardsView> loadNextPage() async {
    if (hasMore) {
      var rewardsFull = await accountService.getAccountRewards(
          address, _pageSize, nextOffset);
      if (lastTotal < rewardsFull.total) {
        // if new rewards were added need to adjust offset and get elements again
        nextOffset = nextOffset + (rewardsFull.total - lastTotal);
        lastTotal = rewardsFull.total;
        rewardsFull = await accountService.getAccountRewards(
            address, _pageSize, nextOffset);
      }

      nextOffset = nextOffset + rewardsFull.rewards.length;
      debugPrint("Loaded next page: $nextOffset, $_pageSize");
      var rewardsList = rewardsFull.rewards.map(mapAccountRewardView).toList();
      loadedRewards.addAll(rewardsList);
      if (rewardsList.length < _pageSize) {
        hasMore = false;
      }
    }
    return AccountRewardsView(
        numberOfNewRewards: -1,
        totalNumberOfRewards: -1,
        rewards: loadedRewards);
  }

  Future<AccountRewardsView> loadRewards() async {
    var offset = 0;
    hasMore = true;
    var rewardsFull =
        await accountService.getAccountRewards(address, _pageSize, offset);

    List<AccountRewardView> rewards = [];
    rewards.addAll(rewardsFull.rewards.map(mapAccountRewardView));

    var numberOfSavedRewards = await accountStorage.getNumberRewards(address);
    var numberOfRewards = rewardsFull.total;

    debugPrint("Number rewards $numberOfRewards");
    debugPrint("Number of saved rewards $numberOfSavedRewards");

    var newRewards = -1;
    if (numberOfSavedRewards != null) {
      newRewards = (numberOfRewards - numberOfSavedRewards).toInt();
    }
    await accountStorage.addNumberRewards(address, numberOfRewards.toInt());

    loadedRewards = rewards;
    nextOffset = offset + loadedRewards.length;
    lastTotal = numberOfRewards;
    return AccountRewardsView(
        numberOfNewRewards: newRewards,
        totalNumberOfRewards: numberOfRewards,
        rewards: loadedRewards);
  }

  AccountRewardView mapAccountRewardView(e) => AccountRewardView(
        time: e.time,
        smesherId: e.smesherId,
        layer: e.layer,
        isNew: false,
        reward: e.rewards,
        rewardDisplay: AccountService.formatAmount(e.rewards),
      );
}

class AccountRewardsView {
  AccountRewardsView(
      {required this.totalNumberOfRewards,
      required this.numberOfNewRewards,
      required this.rewards});

  num totalNumberOfRewards;
  int numberOfNewRewards;
  List<AccountRewardView> rewards;
}

class AccountRewardView {
  AccountRewardView({
    required this.reward,
    required this.rewardDisplay,
    required this.time,
    required this.smesherId,
    required this.layer,
    required this.isNew,
    this.nodeName,
  });

  num reward;
  String rewardDisplay;
  num time;
  String smesherId;
  num layer;
  bool isNew;
  String? nodeName;
}
