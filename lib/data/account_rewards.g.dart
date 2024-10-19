// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_rewards.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountRewards _$AccountRewardsFromJson(Map<String, dynamic> json) =>
    AccountRewards(
      json['layer'] as num,
      json['rewards'] as num,
      json['smesherId'] as String,
      json['time'] as num,
      json['nodeName'] as String?,
    );

Map<String, dynamic> _$AccountRewardsToJson(AccountRewards instance) =>
    <String, dynamic>{
      'layer': instance.layer,
      'rewards': instance.rewards,
      'smesherId': instance.smesherId,
      'time': instance.time,
      'nodeName': instance.nodeName,
    };
