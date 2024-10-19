// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swarmbit_account_rewards_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SwarmbitAccountRewardsDetailsResponse
    _$SwarmbitAccountRewardsDetailsResponseFromJson(
            Map<String, dynamic> json) =>
        SwarmbitAccountRewardsDetailsResponse(
          json['totalSum'] as num,
          json['currentEpoch'] as num,
          json['currentEpochRewardsSum'] as num,
          json['currentEpochRewardsCount'] as num,
          SwarmbitEligibility.fromJson(
              json['eligibility'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$SwarmbitAccountRewardsDetailsResponseToJson(
        SwarmbitAccountRewardsDetailsResponse instance) =>
    <String, dynamic>{
      'totalSum': instance.totalSum,
      'currentEpoch': instance.currentEpoch,
      'currentEpochRewardsSum': instance.currentEpochRewardsSum,
      'currentEpochRewardsCount': instance.currentEpochRewardsCount,
      'eligibility': instance.eligibility,
    };
