import 'package:json_annotation/json_annotation.dart';

part 'swarmbit_account_response.g.dart';

@JsonSerializable()
class SwarmbitAccountResponse {
  SwarmbitAccountResponse(
      this.address,
      this.balance,
      this.usdValue,
      this.counter,
      this.numberOfTransactions,
      this.numberOfRewards,
      this.totalRewards
  );

  final String address;
  final num balance;
  final num usdValue;
  final num counter;
  final num numberOfTransactions;
  final num numberOfRewards;
  final num totalRewards;


  factory SwarmbitAccountResponse.fromJson(Map<String, dynamic> json) =>
      _$SwarmbitAccountResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SwarmbitAccountResponseToJson(this);
}
