import 'package:json_annotation/json_annotation.dart';
import './account_transactions.dart';

part 'account_transactions_full.g.dart';

@JsonSerializable()
class AccountTransactionsFull {
  AccountTransactionsFull(this.total, this.transactions);

  final num total;
  final List<AccountTransactions> transactions;

  factory AccountTransactionsFull.fromJson(Map<String, dynamic> json) =>
      _$AccountTransactionsFullFromJson(json);

  Map<String, dynamic> toJson() => _$AccountTransactionsFullToJson(this);
}
