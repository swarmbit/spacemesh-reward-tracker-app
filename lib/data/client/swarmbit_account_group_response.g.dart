// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swarmbit_account_group_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SwarmbitAccountGroupResponse _$SwarmbitAccountGroupResponseFromJson(
        Map<String, dynamic> json) =>
    SwarmbitAccountGroupResponse(
      json['totalRewards'] as num,
      json['balance'] as num,
      json['usdValue'] as num,
    );

Map<String, dynamic> _$SwarmbitAccountGroupResponseToJson(
        SwarmbitAccountGroupResponse instance) =>
    <String, dynamic>{
      'totalRewards': instance.totalRewards,
      'balance': instance.balance,
      'usdValue': instance.usdValue,
    };
