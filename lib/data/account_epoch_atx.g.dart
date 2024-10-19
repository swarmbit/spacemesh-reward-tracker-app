// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_epoch_atx.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountEpochAtx _$AccountEpochAtxFromJson(Map<String, dynamic> json) =>
    AccountEpochAtx(
      json['atxId'] as String,
      json['nodeId'] as String,
      json['postDataSize'] as String,
      json['time'] as num,
    );

Map<String, dynamic> _$AccountEpochAtxToJson(AccountEpochAtx instance) =>
    <String, dynamic>{
      'atxId': instance.atxId,
      'nodeId': instance.nodeId,
      'postDataSize': instance.postDataSize,
      'time': instance.time,
    };
