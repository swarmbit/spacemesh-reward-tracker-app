import 'package:json_annotation/json_annotation.dart';

part 'swarmbit_eligibility.g.dart';

@JsonSerializable()
class SwarmbitEligibility {
  SwarmbitEligibility(this.count, this.effectiveNumUnits, this.predictedRewards);

  final num count;
  final num effectiveNumUnits;
  final num predictedRewards;

  factory SwarmbitEligibility.fromJson(Map<String, dynamic> json) =>
      _$SwarmbitEligibilityFromJson(json);

  Map<String, dynamic> toJson() => _$SwarmbitEligibilityToJson(this);
}
