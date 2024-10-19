import 'package:json_annotation/json_annotation.dart';

part 'network_info.g.dart';

@JsonSerializable()
class NetworkInfo {
  NetworkInfo(
    this.networkSize,
    this.circulatingSupply,
    this.totalSupply,
    this.price,
    this.marketCap,
    this.totalMarketCap,
    this.vested,
    this.accounts,
    this.smeshers,
    this.nextEpochNetworkSize,
    this.nextEpochSmeshers,
  );

  final String networkSize;
  final String circulatingSupply;
  final String? price;
  final String? marketCap;
  final String? totalSupply;
  final String? totalMarketCap;
  final String? vested;
  final String accounts;
  final String smeshers;
  final String? nextEpochNetworkSize;
  final String? nextEpochSmeshers;

  factory NetworkInfo.fromJson(Map<String, dynamic> json) =>
      _$NetworkInfoFromJson(json);

  Map<String, dynamic> toJson() => _$NetworkInfoToJson(this);
}
