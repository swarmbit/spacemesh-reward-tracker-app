import 'package:json_annotation/json_annotation.dart';

part 'swarmbit_poet_settings.g.dart';

@JsonSerializable()
class SwarmbitPoetSettings {
  SwarmbitPoetSettings(this.phaseShift, this.cycleGap);

  @JsonKey(name: 'phase-shift')
  final num phaseShift;
  @JsonKey(name: 'cycle-gap')
  final num cycleGap;

  factory SwarmbitPoetSettings.fromJson(Map<String, dynamic> json) =>
      _$SwarmbitPoetSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$SwarmbitPoetSettingsToJson(this);
}
