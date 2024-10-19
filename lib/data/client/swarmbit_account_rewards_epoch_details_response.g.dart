// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swarmbit_account_rewards_epoch_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SwarmbitAccountRewardsEpochDetailsResponse
    _$SwarmbitAccountRewardsEpochDetailsResponseFromJson(
            Map<String, dynamic> json) =>
        SwarmbitAccountRewardsEpochDetailsResponse(
          json['epoch'] as num,
          json['rewardsSum'] as num,
          json['rewardsCount'] as num,
          SwarmbitEligibility.fromJson(
              json['eligibility'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$SwarmbitAccountRewardsEpochDetailsResponseToJson(
        SwarmbitAccountRewardsEpochDetailsResponse instance) =>
    <String, dynamic>{
      'epoch': instance.epoch,
      'rewardsSum': instance.rewardsSum,
      'rewardsCount': instance.rewardsCount,
      'eligibility': instance.eligibility,
    };
