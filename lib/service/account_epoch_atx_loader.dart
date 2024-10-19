import 'package:spacemesh_reward_tracker/data/account_epoch_atx.dart';

import './account_service.dart';

class AccountEpochAtxLoader {
  AccountEpochAtxLoader({
    required this.address,
    required this.epoch,
  });

  String address;
  num epoch;
  final _pageSize = 20;

  AccountService accountService = AccountService();
  List<AccountEpochAtx> accountEpochAtx = [];
  num nextOffset = 0;
  bool hasMore = true;

  Future<List<AccountEpochAtx>> loadNextPage() async {
    if (hasMore) {
      var accountEpochAtxResult = await accountService.getAccountEpochAtx(
          address, epoch, _pageSize, nextOffset);

      nextOffset = nextOffset + accountEpochAtxResult.length;
      if (accountEpochAtxResult.length < _pageSize) {
        hasMore = false;
      }
      accountEpochAtx.addAll(accountEpochAtxResult);
      return accountEpochAtx;
    }
    return [];
  }

  Future<List<AccountEpochAtx>> loadAccountEpochAtx() async {
    var offset = 0;
    hasMore = true;
    accountEpochAtx = [];

    var accountEpochAtxResult = await accountService.getAccountEpochAtx(
        address, epoch, _pageSize, offset);

    nextOffset = accountEpochAtxResult.length;

    accountEpochAtx.addAll(accountEpochAtxResult);

    return accountEpochAtx;
  }
}
