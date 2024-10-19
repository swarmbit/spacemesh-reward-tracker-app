// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swarmbit_account_transactions_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SwarmbitAccountTransactionsResponse
    _$SwarmbitAccountTransactionsResponseFromJson(Map<String, dynamic> json) =>
        SwarmbitAccountTransactionsResponse(
          json['id'] as String,
          json['status'] as num,
          json['principalAccount'] as String,
          json['receiverAccount'] as String,
          json['vaultAccount'] as String,
          json['fee'] as num,
          json['amount'] as num,
          json['layer'] as num,
          json['method'] as String,
          json['timestamp'] as num,
        );

Map<String, dynamic> _$SwarmbitAccountTransactionsResponseToJson(
        SwarmbitAccountTransactionsResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'principalAccount': instance.principalAccount,
      'receiverAccount': instance.receiverAccount,
      'vaultAccount': instance.vaultAccount,
      'fee': instance.fee,
      'amount': instance.amount,
      'layer': instance.layer,
      'method': instance.method,
      'timestamp': instance.timestamp,
    };
