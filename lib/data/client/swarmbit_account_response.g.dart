// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swarmbit_account_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SwarmbitAccountResponse _$SwarmbitAccountResponseFromJson(
        Map<String, dynamic> json) =>
    SwarmbitAccountResponse(
      json['address'] as String,
      json['balance'] as num,
      json['usdValue'] as num,
      json['counter'] as num,
      json['numberOfTransactions'] as num,
      json['numberOfRewards'] as num,
      json['totalRewards'] as num,
    );

Map<String, dynamic> _$SwarmbitAccountResponseToJson(
        SwarmbitAccountResponse instance) =>
    <String, dynamic>{
      'address': instance.address,
      'balance': instance.balance,
      'usdValue': instance.usdValue,
      'counter': instance.counter,
      'numberOfTransactions': instance.numberOfTransactions,
      'numberOfRewards': instance.numberOfRewards,
      'totalRewards': instance.totalRewards,
    };
