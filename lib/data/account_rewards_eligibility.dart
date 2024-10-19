import 'package:json_annotation/json_annotation.dart';

part 'account_rewards_eligibility.g.dart';

@JsonSerializable()
class AccountRewardsEligibility {
  AccountRewardsEligibility(this.count, this.postDataSize, this.predictedRewards);

  final num count;
  final String postDataSize;
  final String predictedRewards;

  factory AccountRewardsEligibility.fromJson(Map<String, dynamic> json) =>
      _$AccountRewardsEligibilityFromJson(json);

  Map<String, dynamic> toJson() => _$AccountRewardsEligibilityToJson(this);
}
