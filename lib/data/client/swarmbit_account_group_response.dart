import 'package:json_annotation/json_annotation.dart';

part 'swarmbit_account_group_response.g.dart';

@JsonSerializable()
class SwarmbitAccountGroupResponse {
  SwarmbitAccountGroupResponse(this.totalRewards, this.balance, this.usdValue);

  final num totalRewards;
  final num balance;
  final num usdValue;

  factory SwarmbitAccountGroupResponse.fromJson(Map<String, dynamic> json) =>
      _$SwarmbitAccountGroupResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SwarmbitAccountGroupResponseToJson(this);
}
