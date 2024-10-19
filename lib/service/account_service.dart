import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:spacemesh_reward_tracker/data/account_epoch_atx.dart';

import '../../data/account_rewards_eligibility.dart';
import '../../data/account_rewards_epoch_details.dart';
import '../../data/account_rewards_full.dart';
import '../../data/account_transactions.dart';
import '../../data/account_transactions_full.dart';
import '../data/account.dart';
import '../data/account_group.dart';
import '../data/account_rewards.dart';
import './client/swarmbit_client.dart';
import './config/remote_config.dart';

class AccountService {
  static final AccountService _singleton = AccountService._internal();

  final RemoteConfig remoteConfig = RemoteConfig();

  AccountService._internal();

  factory AccountService() {
    return _singleton;
  }

  SwarmbitClient swarmbitAccountClient = SwarmbitClient();

  Future<Account?> getAccount(String address) async {
    return _getAccountSwarmbit(address);
  }

  Future<AccountGroup> getAccountGroup(List<String> addresses) async {
    var response = await swarmbitAccountClient.getAccountGroup(addresses);
    return AccountGroup(
        balance: formatAmount(response.balance),
        usdValue: response.usdValue >= 0
            ? formatDollarAmount(response.usdValue)
            : null);
  }

  Future<num?> getAccountRewardsTotal(String address) async {
    var details = await swarmbitAccountClient.getAccountRewardsDetails(address);
    if (details != null) {
      return details.totalSum;
    } else {
      return null;
    }
  }

  Future<AccountRewardsFull> getAccountRewards(
      String address, limit, offset) async {
    return _getAccountRewardsSwarmbit(address, limit, offset, null);
  }

  Future<List<AccountEpochAtx>> getAccountEpochAtx(
      String address, num epoch, limit, offset) async {
    var accountEpochAtxs = await swarmbitAccountClient.getAccountEpochAtx(
        address, limit, offset, epoch);
    return accountEpochAtxs.body.map((atx) {
      String postDataSizeString = postDataString(atx.effectiveNumUnits);
      return AccountEpochAtx(
          atx.atxId, atx.nodeId, postDataSizeString, atx.received);
    }).toList();
  }

  Future<AccountRewardsFull> getAccountRewardsFromLayer(
      String address, limit, offset, num firstLayer) async {
    return _getAccountRewardsSwarmbit(address, limit, offset, firstLayer);
  }

  Future<List<String>> filterActiveNodes(
      String address, num epoch, List<String> nodes) async {
    return swarmbitAccountClient.filterActiveNodes(address, epoch, nodes);
  }

  Future<AccountTransactionsFull> getAccountTransactions(
      String address, limit, offset) async {
    var transactionsResponse = await swarmbitAccountClient
        .getAccountTransactions(address, limit, offset);
    debugPrint("Get account transactions from swarmbit api");

    var transactions = transactionsResponse.body.map((e) {
      var status = "Successful";
      if (e.status != 0) {
        status = "Failed";
      }
      String? amount;
      if (e.amount > 0) {
        amount = formatAmount(e.amount);
      }

      return AccountTransactions(
          e.id,
          status,
          address == e.receiverAccount,
          e.principalAccount,
          e.receiverAccount,
          e.vaultAccount,
          formatAmount(e.fee),
          amount,
          e.layer,
          e.method,
          e.timestamp * 1000);
    }).toList();
    return AccountTransactionsFull(transactionsResponse.total, transactions);
  }

  Future<AccountRewardsEpochDetails?> getAccountRewardsEpochDetails(
      address, epoch) async {
    var details = await swarmbitAccountClient.getAccountRewardsEpochDetails(
        address, epoch.toString());
    if (details != null) {
      String postDataSizeString =
          postDataString(details.eligibility.effectiveNumUnits);
      return AccountRewardsEpochDetails(
          epoch,
          formatAmount(details.rewardsSum),
          details.rewardsCount,
          AccountRewardsEligibility(
              details.eligibility.count,
              postDataSizeString,
              formatAmount(details.eligibility.predictedRewards)));
    }
    return null;
  }

  String postDataString(num effectiveNumUnits) {
    var postDataSize = effectiveNumUnits * 64 / 1024;
    var postDataSizeString = "${(postDataSize).toStringAsFixed(3)} TiB";
    return postDataSizeString;
  }

  Future<Account?> _getAccountSwarmbit(String address) async {
    var response = await swarmbitAccountClient.getAccount(address);
    debugPrint("Get account from swarmbit api");
    if (response != null) {
      String? dollarValueStr = null;
      if (response.usdValue != -1) {
        dollarValueStr = formatDollarAmount(response.usdValue);
      }
      return Account(
        response.address,
        response.balance,
        formatAmount(response.balance),
        dollarValueStr,
        response.counter,
        response.numberOfTransactions,
        response.numberOfRewards,
        response.totalRewards,
        formatAmount(response.totalRewards),
      );
    }
    return null;
  }

  Future<AccountRewardsFull> _getAccountRewardsSwarmbit(
      String address, num limit, num offset, num? firstLayer) async {
    var rewardsResponse = await swarmbitAccountClient.getAccountRewards(
        address, limit, offset, firstLayer);
    debugPrint("Get account rewards from swarmbit api");

    var rewards = rewardsResponse.body
        .map((e) => AccountRewards(
            e.layer, e.rewards, e.smesherId, e.timestamp * 1000, null))
        .toList();
    return AccountRewardsFull(rewardsResponse.total, rewards);
  }

  static String formatAmount(num amount) {
    double amountDiv = amount / amountDecimals;
    if (amount == 0) {
      return '0 SMH';
    }
    if (amountDiv < 1) {
      return "$amount Smidge";
    }
    return "${NumberFormat.currency(locale: 'en_US', symbol: '').format(amountDiv)} SMH";
  }

  static String formatDollarAmount(num amount) {
    double amountDiv = amount / amountDecimals;
    return NumberFormat.currency(locale: 'en_US', symbol: '\$')
        .format(amountDiv);
  }

  static num amountDecimals = 1000000000;
}
