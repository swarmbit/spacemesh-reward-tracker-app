import 'package:json_annotation/json_annotation.dart';

import 'swarmbit_poet_info.dart';
import 'swarmbit_poet_settings.dart';

part 'swarmbit_poet.g.dart';

@JsonSerializable()
class SwarmbitPoet {
  SwarmbitPoet(
    this.name,
    this.info,
    this.settings,
  );

  final String name;
  final SwarmbitPoetInfo info;
  final SwarmbitPoetSettings settings;

  factory SwarmbitPoet.fromJson(Map<String, dynamic> json) =>
      _$SwarmbitPoetFromJson(json);

  Map<String, dynamic> toJson() => _$SwarmbitPoetToJson(this);
}
