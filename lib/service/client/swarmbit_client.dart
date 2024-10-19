import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:spacemesh_reward_tracker/data/client/swarmbit_account_atx.dart';
import 'package:spacemesh_reward_tracker/data/client/swarmbit_account_group_response.dart';
import 'package:spacemesh_reward_tracker/data/client/swarmbit_account_rewards_details_response.dart';
import 'package:spacemesh_reward_tracker/data/client/swarmbit_account_transactions_response.dart';
import 'package:spacemesh_reward_tracker/data/client/swarmbit_epoch.dart';
import 'package:spacemesh_reward_tracker/data/client/swarmbit_network_info_response.dart';
import 'package:spacemesh_reward_tracker/data/client/swarmbit_poet.dart';

import '../../data/client/swarmbit_account_response.dart';
import '../../data/client/swarmbit_account_rewards_epoch_details_response.dart';
import '../../data/client/swarmbit_account_rewards_response.dart';
import '../config/remote_config.dart';

class SwarmbitClient {
  static final SwarmbitClient _singleton = SwarmbitClient._internal();

  SwarmbitClient._internal();

  factory SwarmbitClient() {
    return _singleton;
  }

  final RemoteConfig remoteConfig = RemoteConfig();
  String apiKey = "";
  String protocol = "https://";

  Future<SwarmbitAccountResponse?> getAccount(String address) async {
    final response = await http.get(
      Uri.parse('${protocol + remoteConfig.swarmbitUrl()}/account/$address'),
      headers: {'x-api-key': apiKey},
    ).timeout(const Duration(seconds: 20), onTimeout: () {
      throw TimeoutException('The connection has timed out!');
    });
    if (response.statusCode == 200) {
      return SwarmbitAccountResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Error while fetching account.');
    }
  }

  Future<SwarmbitEpoch> getEpoch(num epoch) async {
    final response = await http.get(
      Uri.parse('${protocol + remoteConfig.swarmbitUrl()}/epochs/$epoch'),
      headers: {'x-api-key': apiKey},
    ).timeout(const Duration(seconds: 20), onTimeout: () {
      throw TimeoutException('The connection has timed out!');
    });
    if (response.statusCode == 200) {
      return SwarmbitEpoch.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error while fetching epoch.');
    }
  }

  Future<List<SwarmbitPoet>> getPoets() async {
    final response = await http.get(
      Uri.parse('${protocol + remoteConfig.swarmbitUrl()}/poets'),
      headers: {'x-api-key': apiKey},
    ).timeout(const Duration(seconds: 20), onTimeout: () {
      throw TimeoutException('The connection has timed out!');
    });
    if (response.statusCode == 200) {
      List<dynamic> dataList = await jsonDecode(response.body);
      return dataList.map((e) => SwarmbitPoet.fromJson(e)).toList();
    } else {
      throw Exception('Error while fetching epoch.');
    }
  }

  Future<SwarmbitAccountRewardsFullResponse> getAccountRewards(
      String address, num limit, num offset, num? firstLayer) async {
    var request =
        '${protocol + remoteConfig.swarmbitUrl()}/account/$address/rewards?limit=$limit&offset=$offset&sort=desc';
    if (firstLayer != null) {
      request = request + "&lastLayer=" + firstLayer.toString();
    }

    final response = await http.get(
      Uri.parse(request),
      headers: {'x-api-key': apiKey},
    ).timeout(const Duration(seconds: 20), onTimeout: () {
      throw TimeoutException('The connection has timed out!');
    });
    if (response.statusCode == 200) {
      List<dynamic> dataList = await jsonDecode(response.body);
      return SwarmbitAccountRewardsFullResponse(
          total: num.parse(response.headers['total'] ?? "0"),
          body: dataList
              .map((e) => SwarmbitAccountRewardsResponse.fromJson(e))
              .toList());
    } else {
      throw Exception('Fetch account.');
    }
  }

  Future<SwarmbitAccountAtxFullResponse> getAccountEpochAtx(
      String address, num limit, num offset, num epoch) async {
    var request =
        '${protocol + remoteConfig.swarmbitUrl()}/account/$address/atx/$epoch?limit=$limit&offset=$offset&sort=desc';

    final response = await http.get(
      Uri.parse(request),
      headers: {'x-api-key': apiKey},
    ).timeout(const Duration(seconds: 20), onTimeout: () {
      throw TimeoutException('The connection has timed out!');
    });
    if (response.statusCode == 200) {
      List<dynamic> dataList = await jsonDecode(response.body);
      return SwarmbitAccountAtxFullResponse(
          total: num.parse(response.headers['total'] ?? "0"),
          body: dataList.map((e) => SwarmbitAccountAtx.fromJson(e)).toList());
    } else {
      throw Exception('Fetch account atx.');
    }
  }

  Future<List<String>> filterActiveNodes(
      String address, num epoch, List<String> nodes) async {
    var request =
        '${protocol + remoteConfig.swarmbitUrl()}/account/$address/atx/$epoch/filter-active-nodes';
    Map<String, List<String>> body = new Map();
    body["nodes"] = nodes;
    var bodyString = jsonEncode(body);
    final response = await http
        .post(
      Uri.parse(request),
      headers: {'x-api-key': apiKey},
      body: bodyString,
    )
        .timeout(const Duration(seconds: 20), onTimeout: () {
      throw TimeoutException('The connection has timed out!');
    });
    if (response.statusCode == 200) {
      debugPrint(response.body);
      Map<String, dynamic> responseObj = jsonDecode(response.body);
      var nodes = responseObj["nodes"];
      if (nodes != null && nodes is List<dynamic>) {
        List<String> nodesReturn = [];
        nodes.forEach((element) {
          if (element is String) {
            nodesReturn.add(element);
          }
        });
        return nodesReturn;
      }
    }
    throw Exception('Failed to fetch active nodes.');
  }

  Future<SwarmbitAccountGroupResponse> getAccountGroup(
      List<String> accounts) async {
    var request = '${protocol + remoteConfig.swarmbitUrl()}/account/group';
    Map<String, List<String>> body = new Map();
    body["accounts"] = accounts;
    var bodyString = jsonEncode(body);
    final response = await http
        .post(
      Uri.parse(request),
      headers: {'x-api-key': apiKey},
      body: bodyString,
    )
        .timeout(const Duration(seconds: 20), onTimeout: () {
      throw TimeoutException('The connection has timed out!');
    });
    if (response.statusCode == 200) {
      return SwarmbitAccountGroupResponse.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to fetch active nodes.');
  }

  Future<SwarmbitAccountTransactionsFullResponse> getAccountTransactions(
      String address, num limit, num offset) async {
    final response = await http.get(
      Uri.parse(
          '${protocol + remoteConfig.swarmbitUrl()}/account/$address/transactions?limit=$limit&offset=$offset&sort=desc'),
      headers: {'x-api-key': apiKey},
    ).timeout(const Duration(seconds: 20), onTimeout: () {
      throw TimeoutException('The connection has timed out!');
    });
    if (response.statusCode == 200) {
      List<dynamic> dataList = await jsonDecode(response.body);
      return SwarmbitAccountTransactionsFullResponse(
          total: num.parse(response.headers['total'] ?? "0"),
          body: dataList
              .map((e) => SwarmbitAccountTransactionsResponse.fromJson(e))
              .toList());
    } else {
      throw Exception('Fetch account.');
    }
  }

  Future<SwarmbitNetworkInfoResponse?> getNetworkInfo() async {
    final response = await http.get(
      Uri.parse('${protocol + remoteConfig.swarmbitUrl()}/network/info'),
      headers: {'x-api-key': apiKey},
    ).timeout(const Duration(seconds: 20), onTimeout: () {
      throw TimeoutException('The connection has timed out!');
    });
    if (response.statusCode == 200) {
      return SwarmbitNetworkInfoResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Error while fetching account.');
    }
  }

  Future<SwarmbitAccountRewardsDetailsResponse?> getAccountRewardsDetails(
      String address) async {
    final response = await http.get(
      Uri.parse(
          '${protocol + remoteConfig.swarmbitUrl()}/account/$address/rewards/details'),
      headers: {'x-api-key': apiKey},
    ).timeout(const Duration(seconds: 20), onTimeout: () {
      throw TimeoutException('The connection has timed out!');
    });
    if (response.statusCode == 200) {
      return SwarmbitAccountRewardsDetailsResponse.fromJson(
          jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Error while fetching account rewards details.');
    }
  }

  Future<SwarmbitAccountRewardsEpochDetailsResponse?>
      getAccountRewardsEpochDetails(String address, String epoch) async {
    final response = await http.get(
      Uri.parse(
          '${protocol + remoteConfig.swarmbitUrl()}/account/$address/rewards/details/$epoch'),
      headers: {'x-api-key': apiKey},
    ).timeout(const Duration(seconds: 20), onTimeout: () {
      throw TimeoutException('The connection has timed out!');
    });
    if (response.statusCode == 200) {
      return SwarmbitAccountRewardsEpochDetailsResponse.fromJson(
          jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Error while fetching account epoch rewards details.');
    }
  }
}

class SwarmbitAccountRewardsFullResponse {
  SwarmbitAccountRewardsFullResponse({required this.body, required this.total});

  num total;
  List<SwarmbitAccountRewardsResponse> body;
}

class SwarmbitAccountAtxFullResponse {
  SwarmbitAccountAtxFullResponse({required this.body, required this.total});

  num total;
  List<SwarmbitAccountAtx> body;
}

class SwarmbitAccountTransactionsFullResponse {
  SwarmbitAccountTransactionsFullResponse(
      {required this.body, required this.total});

  num total;
  List<SwarmbitAccountTransactionsResponse> body;
}
