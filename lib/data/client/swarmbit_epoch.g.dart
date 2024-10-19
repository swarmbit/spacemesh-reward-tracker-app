// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swarmbit_epoch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SwarmbitEpoch _$SwarmbitEpochFromJson(Map<String, dynamic> json) =>
    SwarmbitEpoch(
      json['effectiveUnitsCommited'] as num,
      json['epochSubsidy'] as num,
      json['totalWeight'] as num,
      json['totalRewards'] as num,
      json['totalActiveSmeshers'] as num,
    );

Map<String, dynamic> _$SwarmbitEpochToJson(SwarmbitEpoch instance) =>
    <String, dynamic>{
      'effectiveUnitsCommited': instance.effectiveUnitsCommited,
      'epochSubsidy': instance.epochSubsidy,
      'totalWeight': instance.totalWeight,
      'totalRewards': instance.totalRewards,
      'totalActiveSmeshers': instance.totalActiveSmeshers,
    };
