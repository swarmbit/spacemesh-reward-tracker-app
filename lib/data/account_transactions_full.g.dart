// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_transactions_full.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountTransactionsFull _$AccountTransactionsFullFromJson(
        Map<String, dynamic> json) =>
    AccountTransactionsFull(
      json['total'] as num,
      (json['transactions'] as List<dynamic>)
          .map((e) => AccountTransactions.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AccountTransactionsFullToJson(
        AccountTransactionsFull instance) =>
    <String, dynamic>{
      'total': instance.total,
      'transactions': instance.transactions,
    };
