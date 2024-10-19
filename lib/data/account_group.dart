import 'package:json_annotation/json_annotation.dart';

part 'account_group.g.dart';

@JsonSerializable()
class AccountGroup {
  AccountGroup({required this.balance, required this.usdValue});

  final String balance;
  final String? usdValue;

  factory AccountGroup.fromJson(Map<String, dynamic> json) =>
      _$AccountGroupFromJson(json);

  Map<String, dynamic> toJson() => _$AccountGroupToJson(this);
}
