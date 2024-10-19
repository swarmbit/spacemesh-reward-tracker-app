import 'package:json_annotation/json_annotation.dart';

part 'account_epoch_atx.g.dart';

@JsonSerializable()
class AccountEpochAtx {
  AccountEpochAtx(this.atxId, this.nodeId, this.postDataSize, this.time);

  final String atxId;
  final String nodeId;
  final String postDataSize;
  final num time;

  factory AccountEpochAtx.fromJson(Map<String, dynamic> json) =>
      _$AccountEpochAtxFromJson(json);

  Map<String, dynamic> toJson() => _$AccountEpochAtxToJson(this);
}
