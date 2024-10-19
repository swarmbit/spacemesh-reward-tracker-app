import 'package:json_annotation/json_annotation.dart';

part 'swarmbit_epoch.g.dart';

@JsonSerializable()
class SwarmbitEpoch {
  SwarmbitEpoch(this.effectiveUnitsCommited, this.epochSubsidy,
      this.totalWeight, this.totalRewards, this.totalActiveSmeshers);

  final num effectiveUnitsCommited;
  final num epochSubsidy;
  final num totalWeight;
  final num totalRewards;
  final num totalActiveSmeshers;

  factory SwarmbitEpoch.fromJson(Map<String, dynamic> json) =>
      _$SwarmbitEpochFromJson(json);

  Map<String, dynamic> toJson() => _$SwarmbitEpochToJson(this);
}
