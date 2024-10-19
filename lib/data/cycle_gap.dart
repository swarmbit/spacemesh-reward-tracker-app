import 'package:json_annotation/json_annotation.dart';

part 'cycle_gap.g.dart';

@JsonSerializable(explicitToJson: true)
class CycleGap {
  final DateTime startTime;
  final DateTime endTime;

  CycleGap(
    this.startTime,
    this.endTime,
  );

  factory CycleGap.fromJson(Map<String, dynamic> json) =>
      _$CycleGapFromJson(json);

  Map<String, dynamic> toJson() => _$CycleGapToJson(this);
}
