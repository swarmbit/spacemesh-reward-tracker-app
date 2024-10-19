// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetworkInfo _$NetworkInfoFromJson(Map<String, dynamic> json) => NetworkInfo(
      json['networkSize'] as String,
      json['circulatingSupply'] as String,
      json['totalSupply'] as String?,
      json['price'] as String?,
      json['marketCap'] as String?,
      json['totalMarketCap'] as String?,
      json['vested'] as String?,
      json['accounts'] as String,
      json['smeshers'] as String,
      json['nextEpochNetworkSize'] as String?,
      json['nextEpochSmeshers'] as String?,
    );

Map<String, dynamic> _$NetworkInfoToJson(NetworkInfo instance) =>
    <String, dynamic>{
      'networkSize': instance.networkSize,
      'circulatingSupply': instance.circulatingSupply,
      'price': instance.price,
      'marketCap': instance.marketCap,
      'totalSupply': instance.totalSupply,
      'totalMarketCap': instance.totalMarketCap,
      'vested': instance.vested,
      'accounts': instance.accounts,
      'smeshers': instance.smeshers,
      'nextEpochNetworkSize': instance.nextEpochNetworkSize,
      'nextEpochSmeshers': instance.nextEpochSmeshers,
    };
