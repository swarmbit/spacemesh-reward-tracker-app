import 'package:json_annotation/json_annotation.dart';

part 'swarmbit_account_rewards_response.g.dart';

@JsonSerializable()
class SwarmbitAccountRewardsResponse {
  SwarmbitAccountRewardsResponse(this.layer, this.rewards,
      this.smesherId, this.timestamp);

  final num layer;
  final num rewards;
  final String smesherId;
  final num timestamp;

  factory SwarmbitAccountRewardsResponse.fromJson(Map<String, dynamic> json) =>
      _$SwarmbitAccountRewardsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SwarmbitAccountRewardsResponseToJson(this);
}
