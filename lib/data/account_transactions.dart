import 'package:json_annotation/json_annotation.dart';

part 'account_transactions.g.dart';

@JsonSerializable()
class AccountTransactions {
  AccountTransactions(
      this.id,
      this.status,
      this.received,
      this.principalAccount,
      this.receiverAccount,
      this.vaultAccount,
      this.fee,
      this.amount,
      this.layer,
      this.method,
      this.timestamp);

  final String id;
  final String status;
  final bool received;
  final String principalAccount;
  final String receiverAccount;
  final String vaultAccount;
  final String fee;
  final String? amount;
  final num layer;
  final String method;
  final num timestamp;

  factory AccountTransactions.fromJson(Map<String, dynamic> json) =>
      _$AccountTransactionsFromJson(json);

  Map<String, dynamic> toJson() => _$AccountTransactionsToJson(this);
}
