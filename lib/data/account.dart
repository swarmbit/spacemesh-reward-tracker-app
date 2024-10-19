import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable()
class Account {
  Account(
    this.address,
    this.balance,
    this.balanceDisplay,
    this.dollarValue,
    this.counter,
    this.numberOfTransactions,
    this.numberOfRewards,
    this.totalRewards,
    this.totalRewardsDisplay, [
      this.label,
    ]);

  final String address;
  final num balance;
  final String balanceDisplay;
  final String? dollarValue;
  final num counter;
  String? label;
  final num? numberOfTransactions;
  final num? numberOfRewards;
  final num? totalRewards;
  final String? totalRewardsDisplay;


  void setLabel(String value) => label = value;

  void setDefaultLabel() {
    label = address.substring(address.length - 10);
  }

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);
}
