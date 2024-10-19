import 'package:json_annotation/json_annotation.dart';

import 'account_rewards_eligibility.dart';

part 'account_rewards_epoch_details.g.dart';

@JsonSerializable()
class AccountRewardsEpochDetails {
  AccountRewardsEpochDetails(this.epoch, this.rewardsSum, this.rewardsCount, this.eligibility);

  final num epoch;
  final String rewardsSum;
  final num rewardsCount;
  final AccountRewardsEligibility eligibility;

  factory AccountRewardsEpochDetails.fromJson(Map<String, dynamic> json) =>
      _$AccountRewardsEpochDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$AccountRewardsEpochDetailsToJson(this);
}
