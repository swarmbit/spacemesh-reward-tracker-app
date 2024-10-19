import 'package:json_annotation/json_annotation.dart';

import 'swarmbit_eligibility.dart';

part 'swarmbit_account_rewards_epoch_details_response.g.dart';

@JsonSerializable()
class SwarmbitAccountRewardsEpochDetailsResponse {
  SwarmbitAccountRewardsEpochDetailsResponse(this.epoch,
      this.rewardsSum, this.rewardsCount, this.eligibility);

  final num epoch;
  final num rewardsSum;
  final num rewardsCount;
  final SwarmbitEligibility eligibility;

  factory SwarmbitAccountRewardsEpochDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$SwarmbitAccountRewardsEpochDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SwarmbitAccountRewardsEpochDetailsResponseToJson(this);
}
