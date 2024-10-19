// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      json['address'] as String,
      json['balance'] as num,
      json['balanceDisplay'] as String,
      json['dollarValue'] as String?,
      json['counter'] as num,
      json['numberOfTransactions'] as num?,
      json['numberOfRewards'] as num?,
      json['totalRewards'] as num?,
      json['totalRewardsDisplay'] as String?,
      json['label'] as String?,
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'address': instance.address,
      'balance': instance.balance,
      'balanceDisplay': instance.balanceDisplay,
      'dollarValue': instance.dollarValue,
      'counter': instance.counter,
      'label': instance.label,
      'numberOfTransactions': instance.numberOfTransactions,
      'numberOfRewards': instance.numberOfRewards,
      'totalRewards': instance.totalRewards,
      'totalRewardsDisplay': instance.totalRewardsDisplay,
    };
