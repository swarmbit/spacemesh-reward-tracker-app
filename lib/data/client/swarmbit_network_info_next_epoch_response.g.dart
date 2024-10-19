// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swarmbit_network_info_next_epoch_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SwarmbitNetworkInfoNextEpochResponse
    _$SwarmbitNetworkInfoNextEpochResponseFromJson(Map<String, dynamic> json) =>
        SwarmbitNetworkInfoNextEpochResponse(
          json['epoch'] as num,
          json['effectiveUnitsCommited'] as num,
          json['totalActiveSmeshers'] as num,
        );

Map<String, dynamic> _$SwarmbitNetworkInfoNextEpochResponseToJson(
        SwarmbitNetworkInfoNextEpochResponse instance) =>
    <String, dynamic>{
      'epoch': instance.epoch,
      'effectiveUnitsCommited': instance.effectiveUnitsCommited,
      'totalActiveSmeshers': instance.totalActiveSmeshers,
    };
