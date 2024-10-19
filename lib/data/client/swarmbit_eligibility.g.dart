// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swarmbit_eligibility.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SwarmbitEligibility _$SwarmbitEligibilityFromJson(Map<String, dynamic> json) =>
    SwarmbitEligibility(
      json['count'] as num,
      json['effectiveNumUnits'] as num,
      json['predictedRewards'] as num,
    );

Map<String, dynamic> _$SwarmbitEligibilityToJson(
        SwarmbitEligibility instance) =>
    <String, dynamic>{
      'count': instance.count,
      'effectiveNumUnits': instance.effectiveNumUnits,
      'predictedRewards': instance.predictedRewards,
    };
