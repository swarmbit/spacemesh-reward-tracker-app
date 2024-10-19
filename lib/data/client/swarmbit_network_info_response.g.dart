// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swarmbit_network_info_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SwarmbitNetworkInfoResponse _$SwarmbitNetworkInfoResponseFromJson(
        Map<String, dynamic> json) =>
    SwarmbitNetworkInfoResponse(
      json['effectiveUnitsCommited'] as num,
      json['circulatingSupply'] as num,
      (json['price'] as num).toDouble(),
      json['marketCap'] as num,
      json['totalAccounts'] as num,
      json['totalActiveSmeshers'] as num,
      json['vested'] as num,
      json['totalVaulted'] as num,
      json['nextEpoch'] == null
          ? null
          : SwarmbitNetworkInfoNextEpochResponse.fromJson(
              json['nextEpoch'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SwarmbitNetworkInfoResponseToJson(
        SwarmbitNetworkInfoResponse instance) =>
    <String, dynamic>{
      'effectiveUnitsCommited': instance.effectiveUnitsCommited,
      'circulatingSupply': instance.circulatingSupply,
      'price': instance.price,
      'marketCap': instance.marketCap,
      'totalAccounts': instance.totalAccounts,
      'totalActiveSmeshers': instance.totalActiveSmeshers,
      'vested': instance.vested,
      'totalVaulted': instance.totalVaulted,
      'nextEpoch': instance.nextEpoch,
    };
