// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swarmbit_account_rewards_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SwarmbitAccountRewardsResponse _$SwarmbitAccountRewardsResponseFromJson(
        Map<String, dynamic> json) =>
    SwarmbitAccountRewardsResponse(
      json['layer'] as num,
      json['rewards'] as num,
      json['smesherId'] as String,
      json['timestamp'] as num,
    );

Map<String, dynamic> _$SwarmbitAccountRewardsResponseToJson(
        SwarmbitAccountRewardsResponse instance) =>
    <String, dynamic>{
      'layer': instance.layer,
      'rewards': instance.rewards,
      'smesherId': instance.smesherId,
      'timestamp': instance.timestamp,
    };
