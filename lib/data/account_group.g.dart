// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountGroup _$AccountGroupFromJson(Map<String, dynamic> json) => AccountGroup(
      balance: json['balance'] as String,
      usdValue: json['usdValue'] as String?,
    );

Map<String, dynamic> _$AccountGroupToJson(AccountGroup instance) =>
    <String, dynamic>{
      'balance': instance.balance,
      'usdValue': instance.usdValue,
    };
