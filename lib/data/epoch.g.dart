// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epoch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Epoch _$EpochFromJson(Map<String, dynamic> json) => Epoch(
      json['epoch'] as num,
      DateTime.parse(json['startTime'] as String),
      DateTime.parse(json['endTime'] as String),
    );

Map<String, dynamic> _$EpochToJson(Epoch instance) => <String, dynamic>{
      'epoch': instance.epoch,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
    };
