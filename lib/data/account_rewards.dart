import 'package:json_annotation/json_annotation.dart';

part 'account_rewards.g.dart';

@JsonSerializable()
class AccountRewards {
  AccountRewards(
      this.layer, this.rewards, this.smesherId, this.time, this.nodeName);

  final num layer;
  final num rewards;
  final String smesherId;
  final num time;

  final String? nodeName;

  factory AccountRewards.fromJson(Map<String, dynamic> json) =>
      _$AccountRewardsFromJson(json);

  Map<String, dynamic> toJson() => _$AccountRewardsToJson(this);
}
