// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_rewards_epoch_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountRewardsEpochDetails _$AccountRewardsEpochDetailsFromJson(
        Map<String, dynamic> json) =>
    AccountRewardsEpochDetails(
      json['epoch'] as num,
      json['rewardsSum'] as String,
      json['rewardsCount'] as num,
      AccountRewardsEligibility.fromJson(
          json['eligibility'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AccountRewardsEpochDetailsToJson(
        AccountRewardsEpochDetails instance) =>
    <String, dynamic>{
      'epoch': instance.epoch,
      'rewardsSum': instance.rewardsSum,
      'rewardsCount': instance.rewardsCount,
      'eligibility': instance.eligibility,
    };
