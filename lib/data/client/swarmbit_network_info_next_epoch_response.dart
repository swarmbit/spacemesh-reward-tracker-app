import 'package:json_annotation/json_annotation.dart';

part 'swarmbit_network_info_next_epoch_response.g.dart';

@JsonSerializable()
class SwarmbitNetworkInfoNextEpochResponse {
  SwarmbitNetworkInfoNextEpochResponse(
      this.epoch, this.effectiveUnitsCommited, this.totalActiveSmeshers);

  final num epoch;
  final num effectiveUnitsCommited;
  final num totalActiveSmeshers;

  factory SwarmbitNetworkInfoNextEpochResponse.fromJson(
          Map<String, dynamic> json) =>
      _$SwarmbitNetworkInfoNextEpochResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SwarmbitNetworkInfoNextEpochResponseToJson(this);
}
