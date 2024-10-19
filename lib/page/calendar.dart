import 'package:flutter/material.dart';

import '../component/epoch_info.dart';
import '../data/epoch.dart';
import '../service/network_service.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  NetworkService networkService = NetworkService();

  late Epoch currentEpoch;

  @override
  void initState() {
    super.initState();
    currentEpoch = networkService.getEpoch();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            EpochInfo(currentEpoch: currentEpoch),
          ],
        ),
      ),
    );
  }
}
