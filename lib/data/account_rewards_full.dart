import 'package:json_annotation/json_annotation.dart';

import 'account_rewards.dart';

part 'account_rewards_full.g.dart';

@JsonSerializable()
class AccountRewardsFull {
  AccountRewardsFull(this.total, this.rewards);

  final num total;
  final List<AccountRewards> rewards;

  factory AccountRewardsFull.fromJson(Map<String, dynamic> json) =>
      _$AccountRewardsFullFromJson(json);

  Map<String, dynamic> toJson() => _$AccountRewardsFullToJson(this);
}
