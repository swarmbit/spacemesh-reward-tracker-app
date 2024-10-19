// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swarmbit_account_atx.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SwarmbitAccountAtx _$SwarmbitAccountAtxFromJson(Map<String, dynamic> json) =>
    SwarmbitAccountAtx(
      json['nodeId'] as String,
      json['atxId'] as String,
      json['effectiveNumUnits'] as num,
      json['received'] as num,
    );

Map<String, dynamic> _$SwarmbitAccountAtxToJson(SwarmbitAccountAtx instance) =>
    <String, dynamic>{
      'nodeId': instance.nodeId,
      'atxId': instance.atxId,
      'effectiveNumUnits': instance.effectiveNumUnits,
      'received': instance.received,
    };
