// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_rewards_full.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountRewardsFull _$AccountRewardsFullFromJson(Map<String, dynamic> json) =>
    AccountRewardsFull(
      json['total'] as num,
      (json['rewards'] as List<dynamic>)
          .map((e) => AccountRewards.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AccountRewardsFullToJson(AccountRewardsFull instance) =>
    <String, dynamic>{
      'total': instance.total,
      'rewards': instance.rewards,
    };
