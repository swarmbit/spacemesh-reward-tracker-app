// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swarmbit_poet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SwarmbitPoet _$SwarmbitPoetFromJson(Map<String, dynamic> json) => SwarmbitPoet(
      json['name'] as String,
      SwarmbitPoetInfo.fromJson(json['info'] as Map<String, dynamic>),
      SwarmbitPoetSettings.fromJson(json['settings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SwarmbitPoetToJson(SwarmbitPoet instance) =>
    <String, dynamic>{
      'name': instance.name,
      'info': instance.info,
      'settings': instance.settings,
    };
