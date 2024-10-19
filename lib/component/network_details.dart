import 'package:flutter/material.dart';
import 'package:spacemesh_reward_tracker/data/epoch.dart';

import '../data/network_info.dart';
import 'tile_card.dart';

class NetworkDetails extends StatelessWidget {
  const NetworkDetails({
    Key? key,
    required this.epoch,
    required this.currentLayer,
    required this.networkInfo,
  }) : super(key: key);

  final Epoch epoch;
  final num currentLayer;
  final NetworkInfo? networkInfo;

  @override
  Widget build(BuildContext context) {
    bool hasNextEpoch = networkInfo != null &&
        (networkInfo!.nextEpochNetworkSize != null ||
            networkInfo!.nextEpochSmeshers != null);

    return ListView(
      children: networkInfo != null
          ? [
              hasNextEpoch
                  ? TileCard(
                      value: (epoch.epoch + 1).toString(),
                      label: 'Next Epoch',
                    )
                  : const SizedBox(
                      height: 0,
                    ),
              hasNextEpoch
                  ? TileCard(
                      value: networkInfo!.nextEpochNetworkSize,
                      label: 'Network space',
                    )
                  : const SizedBox(
                      height: 0,
                    ),
              hasNextEpoch
                  ? TileCard(
                      value: networkInfo!.nextEpochSmeshers,
                      label: 'Activations',
                    )
                  : const SizedBox(
                      height: 0,
                    ),
              hasNextEpoch
                  ? const Divider()
                  : const SizedBox(
                      height: 0,
                    ),
              TileCard(
                value: epoch.epoch.toString(),
                label: 'Current Epoch',
              ),
              TileCard(
                value: currentLayer.toString(),
                label: 'Current layer',
              ),
              TileCard(
                value: networkInfo!.networkSize,
                label: 'Network space',
              ),
              TileCard(
                value: networkInfo!.circulatingSupply,
                label: 'Circulating supply',
              ),
              TileCard(
                value: networkInfo!.totalSupply,
                label: 'Total supply',
              ),
              networkInfo!.price != null
                  ? TileCard(
                      value: networkInfo!.price,
                      label: 'Price',
                    )
                  : const SizedBox(),
              networkInfo!.marketCap != null
                  ? TileCard(
                      value: networkInfo!.marketCap,
                      label: 'Market cap',
                    )
                  : const SizedBox(),
              networkInfo!.totalMarketCap != null
                  ? TileCard(
                      value: networkInfo!.totalMarketCap,
                      label: 'Total Market cap',
                    )
                  : const SizedBox(),
              networkInfo!.vested != null
                  ? TileCard(
                      value: networkInfo!.vested,
                      label: 'Vesting',
                    )
                  : const SizedBox(),
              TileCard(
                value: networkInfo!.accounts,
                label: 'Accounts',
              ),
              TileCard(
                value: networkInfo!.smeshers,
                label: 'Activations',
              )
            ]
          : [],
    );
  }
}
