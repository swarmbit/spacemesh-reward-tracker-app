import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:spacemesh_reward_tracker/service/account_service.dart';

import '../data/account_rewards.dart';
import '../storage/account_storage.dart';
import './network_service.dart';

class AccountEpochLayersService {
  static final AccountEpochLayersService _singleton =
      AccountEpochLayersService._internal();

  NetworkService networkService = NetworkService();
  AccountStorage accountStorage = AccountStorage();
  AccountService accountService = AccountService();

  AccountEpochLayersService._internal();

  factory AccountEpochLayersService() {
    return _singleton;
  }

  List<AccountRewards>? getAccountExpectedLayers(String account, num epoch) {
    return accountStorage.getAccountEpochExpectedRewards(account, epoch);
  }

  Future<bool> removeLayers(String account, num epoch) async {
    return await accountStorage.removeExpectedLayers(account, epoch);
  }

  Future<List<AccountRewards>> saveLayers(
      String account, num epoch, String path) async {
    File file = File(path);
    String layers = await file.readAsString(encoding: utf8);

    dynamic layersJson = json.decode(layers);
    List<AccountRewards> expectedLayers = [];
    List<String> nodes = [];
    if (layersJson is Map) {
      _parseLayersObject(layersJson, expectedLayers, nodes);
    } else {
      _parseLayersArray(layersJson, expectedLayers, nodes);
    }
    var activeNodes =
        await accountService.filterActiveNodes(account, epoch, nodes);

    var epochFirstLayer = networkService.getEpochFirstLayer(epoch);
    var epochLastLayer = networkService.getEpochLastLayer(epoch);

    expectedLayers.removeWhere((element) {
      return !activeNodes.contains(element.smesherId) ||
          element.layer < epochFirstLayer ||
          element.layer > epochLastLayer;
    });

    expectedLayers.sort((a, b) {
      if (a.layer != b.layer) {
        return (b.layer - a.layer).toInt();
      }
      return a.smesherId.compareTo(b.smesherId);
    });
    await accountStorage.saveExpectedLayers(account, epoch, expectedLayers);
    return expectedLayers;
  }

  void _parseLayersArray(dynamic layersJsonDynamic,
      List<AccountRewards> expectedLayers, List<String> nodes) {
    List<dynamic> layersJson = layersJsonDynamic;
    for (var node in layersJson) {
      String nodeName = node["nodeName"];
      String nodeID = node["nodeID"].toLowerCase();
      nodes.add(nodeID);
      List<dynamic> eligibilities = node["eligibilities"];
      for (var eligibility in eligibilities) {
        var layer = eligibility["layer"];
        var count = eligibility["count"];
        if (layer is num && count is num) {
          for (var i = 0; i < count; i++) {
            expectedLayers.add(AccountRewards(layer, -1, nodeID,
                networkService.getLayerTime(layer), nodeName));
          }
        }
      }
    }
  }

  void _parseLayersObject(dynamic layersJsonDynamic,
      List<AccountRewards> expectedLayers, List<String> nodes) {
    Map<String, dynamic> layersJson = layersJsonDynamic;
    layersJson.forEach((key, value) {
      var node = key.toLowerCase();
      nodes.add(node);
      debugPrint("LayersJson: $value");
      if (value is List) {
        var first = value.firstOrNull;
        if (first != null) {
          if (first is Map<String, dynamic>) {
            for (var element in value) {
              var layer = element["layer"];
              var count = element["count"];
              if (layer is num && count is num) {
                for (var i = 0; i < count; i++) {
                  expectedLayers.add(AccountRewards(layer, -1, node,
                      networkService.getLayerTime(layer), null));
                }
              }
            }
          } else {
            for (var element in value) {
              if (element is num) {
                expectedLayers.add(AccountRewards(element, -1, node,
                    networkService.getLayerTime(element), null));
              }
            }
          }
        }
      }
    });
  }
}
