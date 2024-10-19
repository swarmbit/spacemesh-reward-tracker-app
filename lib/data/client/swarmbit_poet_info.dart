import 'package:json_annotation/json_annotation.dart';

part 'swarmbit_poet_info.g.dart';

@JsonSerializable()
class SwarmbitPoetInfo {
  SwarmbitPoetInfo(this.description, this.discordLink);

  final String description;
  @JsonKey(name: 'discord-link')
  final String discordLink;

  factory SwarmbitPoetInfo.fromJson(Map<String, dynamic> json) =>
      _$SwarmbitPoetInfoFromJson(json);

  Map<String, dynamic> toJson() => _$SwarmbitPoetInfoToJson(this);
}
