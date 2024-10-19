import 'package:json_annotation/json_annotation.dart';

import 'swarmbit_eligibility.dart';

part 'swarmbit_account_rewards_details_response.g.dart';

@JsonSerializable()
class SwarmbitAccountRewardsDetailsResponse {
  SwarmbitAccountRewardsDetailsResponse(this.totalSum, this.currentEpoch,
      this.currentEpochRewardsSum, this.currentEpochRewardsCount, this.eligibility);

  final num totalSum;
  final num currentEpoch;
  final num currentEpochRewardsSum;
  final num currentEpochRewardsCount;
  final SwarmbitEligibility eligibility;

  factory SwarmbitAccountRewardsDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$SwarmbitAccountRewardsDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SwarmbitAccountRewardsDetailsResponseToJson(this);
}
