// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cycle_gap.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CycleGap _$CycleGapFromJson(Map<String, dynamic> json) => CycleGap(
      DateTime.parse(json['startTime'] as String),
      DateTime.parse(json['endTime'] as String),
    );

Map<String, dynamic> _$CycleGapToJson(CycleGap instance) => <String, dynamic>{
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
    };
