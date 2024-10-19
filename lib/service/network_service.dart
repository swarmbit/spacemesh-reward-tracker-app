import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:spacemesh_reward_tracker/data/rewards_date.dart';

import '../../data/network_info.dart';
import '../data/client/swarmbit_poet.dart';
import '../data/cycle_gap.dart';
import '../data/epoch.dart';
import '../storage/network_info_storage.dart';
import './account_service.dart';
import 'client/swarmbit_client.dart';

class NetworkService {
  static final NetworkService _singleton = NetworkService._internal();

  SwarmbitClient swarmbitClient = SwarmbitClient();
  NetworkInfoStorage storage = NetworkInfoStorage();

  num genesisEpochSeconds = 1689321600;
  num layerDuration = 300;
  num layersPerEpoch = 4032;

  NetworkService._internal() {
    debugPrint("Fetch initial network info");
    _networkInfoBackground();
  }

  factory NetworkService() {
    return _singleton;
  }

  _networkInfoBackground() {
    _fetchPoets().then((value) => debugPrint("Updated poets"));
    fetchNetworkInfo().then((value) => debugPrint("Updated network info"));
  }

  Future<bool> _fetchPoets() async {
    var poets = await swarmbitClient.getPoets();
    await storage.savePoets(poets);
    return true;
  }

  Future<bool> fetchNetworkInfo() async {
    var networkInfoResponse = await swarmbitClient.getNetworkInfo();
    if (networkInfoResponse != null) {
      var networkSpaceString =
          getNetworkSizeString(networkInfoResponse.effectiveUnitsCommited);
      var circulatingSupply = networkInfoResponse.circulatingSupply /
          AccountService.amountDecimals /
          1000000;

      var vestedSupply =
          networkInfoResponse.vested / AccountService.amountDecimals / 1000000;

      var vauledSupply = networkInfoResponse.totalVaulted /
          AccountService.amountDecimals /
          1000000;

      var totalSupply = circulatingSupply + vauledSupply - vestedSupply;

      var marketCap =
          (networkInfoResponse.marketCap / AccountService.amountDecimals) /
              1000000;

      var circulatingSupplyString =
          "${(circulatingSupply).toStringAsFixed(3)}M";

      var totalSupplyString = "${(totalSupply).toStringAsFixed(3)}M";

      var vestedSupplyString = "${(vestedSupply).toStringAsFixed(3)}M";

      var vaultedSupplyString = "${(vauledSupply).toStringAsFixed(3)}M";

      var priceString;
      var marketCapString;
      var totalMarketCapString;
      if (networkInfoResponse.price != -1) {
        priceString = "\$${networkInfoResponse.price.toStringAsFixed(4)}";
        marketCapString = "\$${(marketCap).toStringAsFixed(3)}M";
        totalMarketCapString =
            "\$${(totalSupply * networkInfoResponse.price).toStringAsFixed(3)}M";
      }

      String? nextEpochNetworkSizeString;
      String? nextEpochSmeshers;
      if (networkInfoResponse.nextEpoch != null) {
        if (networkInfoResponse.nextEpoch!.effectiveUnitsCommited > 0) {
          nextEpochNetworkSizeString = getNetworkSizeString(
              networkInfoResponse.nextEpoch!.effectiveUnitsCommited);
        }

        if (networkInfoResponse.nextEpoch!.totalActiveSmeshers > 0) {
          nextEpochSmeshers =
              networkInfoResponse.nextEpoch!.totalActiveSmeshers.toString();
        }
      }

      var networkInfo = NetworkInfo(
        networkSpaceString,
        circulatingSupplyString,
        totalSupplyString,
        priceString,
        marketCapString,
        totalMarketCapString,
        "$vestedSupplyString / $vaultedSupplyString",
        networkInfoResponse.totalAccounts.toString(),
        networkInfoResponse.totalActiveSmeshers.toString(),
        nextEpochNetworkSizeString,
        nextEpochSmeshers,
      );
      await storage.saveNetworkInfo(networkInfo);
    }
    return true;
  }

  String getNetworkSizeString(num effectiveUnitsCommited) {
    var networkSpace = effectiveUnitsCommited * 64 / 1024 / 1024;
    var networkSpaceString = "${(networkSpace).toStringAsFixed(2)} PiB";
    return networkSpaceString;
  }

  Epoch getEpoch() {
    var currentLayer = getCurrentLayer();
    debugPrint("Current Layer: $currentLayer");
    var currentEpoch = currentLayer ~/ layersPerEpoch;
    debugPrint("Current Epoch: $currentEpoch");
    return getSpecificEpoch(currentEpoch);
  }

  num getEpochFirstLayer(num epoch) {
    return epoch * layersPerEpoch;
  }

  num getEpochLastLayer(num epoch) {
    return ((epoch + 1) * layersPerEpoch) - 1;
  }

  num getCurrentLayer() {
    var now = DateTime.now();
    var secondsSinceEpoch = now.microsecondsSinceEpoch / 1000000;
    var secondsSinceGeneses = secondsSinceEpoch - genesisEpochSeconds;
    return secondsSinceGeneses ~/ layerDuration;
  }

  List<SwarmbitPoet>? getPoets() {
    return storage.getPoets();
  }

  Future<EpochData?> getEpochData(num epoch) async {
    var response = await swarmbitClient.getEpoch(epoch);
    if (response.totalActiveSmeshers != 0 ||
        response.effectiveUnitsCommited != 0) {
      debugPrint("Get epoch data: ${response.effectiveUnitsCommited}");
      var networkSize = getNetworkSizeString(response.effectiveUnitsCommited);
      return EpochData(
          networkSize: networkSize,
          activeSmeshers: response.totalActiveSmeshers.toString());
    }
    return null;
  }

  EpochData? getCurrentEpochData() {
    var networkInfo = getNetworkInfo();
    if (networkInfo != null) {
      return EpochData(
          networkSize: networkInfo.networkSize,
          activeSmeshers: networkInfo.smeshers);
    }
    return null;
  }

  RewardsDate getRewardsDate(num epoch) {
    return RewardsDate(epoch + 2, _getEpochStartTime(epoch + 2));
  }

  CycleGap getCycleGapForEpoch(num epoch, num phaseShift, num gapTime) {
    var epochStart = _getEpochStartTime(epoch);
    var cycleGapStartTime =
        epochStart.add(Duration(hours: phaseShift.toInt() - gapTime.toInt()));
    var cycleGapEndTime =
        cycleGapStartTime.add(Duration(hours: gapTime.toInt()));
    return CycleGap(cycleGapStartTime, cycleGapEndTime);
  }

  Epoch getSpecificEpoch(num epochNum) {
    var startTime = _getEpochStartTime(epochNum);
    var endTime = _getEpochStartTime(epochNum + 1);
    return Epoch(epochNum, startTime, endTime);
  }

  num getLayerTime(num layer) {
    var layerTimeSeconds = genesisEpochSeconds + (layerDuration * layer);
    return layerTimeSeconds;
  }

  DateTime _getEpochStartTime(num epoch) {
    var epochStartTimeSeconds =
        genesisEpochSeconds + (layerDuration * layersPerEpoch * epoch);
    return DateTime.fromMicrosecondsSinceEpoch(
        (epochStartTimeSeconds * 1000000).toInt());
  }

  NetworkInfo? getNetworkInfo() {
    return storage.getNetworkInfo();
  }
}

class EpochData {
  EpochData({required this.networkSize, required this.activeSmeshers});

  String networkSize;
  String activeSmeshers;
}
