import 'package:json_annotation/json_annotation.dart';

part 'swarmbit_account_transactions_response.g.dart';

@JsonSerializable()
class SwarmbitAccountTransactionsResponse {
  SwarmbitAccountTransactionsResponse(
      this.id,
      this.status,
      this.principalAccount,
      this.receiverAccount,
      this.vaultAccount,
      this.fee,
      this.amount,
      this.layer,
      this.method,
      this.timestamp);

  final String id;
  final num status;
  final String principalAccount;
  final String receiverAccount;
  final String vaultAccount;
  final num fee;
  final num amount;
  final num layer;
  final String method;
  final num timestamp;
  // 0 success, 1 failed

  factory SwarmbitAccountTransactionsResponse.fromJson(
          Map<String, dynamic> json) =>
      _$SwarmbitAccountTransactionsResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SwarmbitAccountTransactionsResponseToJson(this);
}
