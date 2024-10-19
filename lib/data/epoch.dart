import 'package:json_annotation/json_annotation.dart';

import 'cycle_gap.dart';

part 'epoch.g.dart';

@JsonSerializable(explicitToJson: true)
class Epoch {
  final num epoch;
  final DateTime startTime;
  final DateTime endTime;

  Epoch(
    this.epoch,
    this.startTime,
    this.endTime,
  );

  factory Epoch.fromJson(Map<String, dynamic> json) => _$EpochFromJson(json);

  Map<String, dynamic> toJson() => _$EpochToJson(this);
}
