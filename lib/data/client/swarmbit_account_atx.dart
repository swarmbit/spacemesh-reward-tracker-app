import 'package:json_annotation/json_annotation.dart';

part 'swarmbit_account_atx.g.dart';

@JsonSerializable()
class SwarmbitAccountAtx {
  SwarmbitAccountAtx(
      this.nodeId, this.atxId, this.effectiveNumUnits, this.received);

  final String nodeId;
  final String atxId;
  final num effectiveNumUnits;
  final num received;

  factory SwarmbitAccountAtx.fromJson(Map<String, dynamic> json) =>
      _$SwarmbitAccountAtxFromJson(json);

  Map<String, dynamic> toJson() => _$SwarmbitAccountAtxToJson(this);
}
