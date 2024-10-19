import 'package:json_annotation/json_annotation.dart';

import 'swarmbit_network_info_next_epoch_response.dart';

part 'swarmbit_network_info_response.g.dart';

@JsonSerializable()
class SwarmbitNetworkInfoResponse {
  SwarmbitNetworkInfoResponse(
    this.effectiveUnitsCommited,
    this.circulatingSupply,
    this.price,
    this.marketCap,
    this.totalAccounts,
    this.totalActiveSmeshers,
    this.vested,
    this.totalVaulted,
    this.nextEpoch,
  );

  final num effectiveUnitsCommited;
  final num circulatingSupply;
  final double price;
  final num marketCap;
  final num totalAccounts;
  final num totalActiveSmeshers;
  final num vested;
  final num totalVaulted;
  final SwarmbitNetworkInfoNextEpochResponse? nextEpoch;

  factory SwarmbitNetworkInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$SwarmbitNetworkInfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SwarmbitNetworkInfoResponseToJson(this);
}
