// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_transactions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountTransactions _$AccountTransactionsFromJson(Map<String, dynamic> json) =>
    AccountTransactions(
      json['id'] as String,
      json['status'] as String,
      json['received'] as bool,
      json['principalAccount'] as String,
      json['receiverAccount'] as String,
      json['vaultAccount'] as String,
      json['fee'] as String,
      json['amount'] as String?,
      json['layer'] as num,
      json['method'] as String,
      json['timestamp'] as num,
    );

Map<String, dynamic> _$AccountTransactionsToJson(
        AccountTransactions instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'received': instance.received,
      'principalAccount': instance.principalAccount,
      'receiverAccount': instance.receiverAccount,
      'vaultAccount': instance.vaultAccount,
      'fee': instance.fee,
      'amount': instance.amount,
      'layer': instance.layer,
      'method': instance.method,
      'timestamp': instance.timestamp,
    };
