// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_rewards_eligibility.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountRewardsEligibility _$AccountRewardsEligibilityFromJson(
        Map<String, dynamic> json) =>
    AccountRewardsEligibility(
      json['count'] as num,
      json['postDataSize'] as String,
      json['predictedRewards'] as String,
    );

Map<String, dynamic> _$AccountRewardsEligibilityToJson(
        AccountRewardsEligibility instance) =>
    <String, dynamic>{
      'count': instance.count,
      'postDataSize': instance.postDataSize,
      'predictedRewards': instance.predictedRewards,
    };
