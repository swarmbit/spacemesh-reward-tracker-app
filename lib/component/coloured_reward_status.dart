import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/settings_provider.dart';

class ColouredRewardStatus extends StatelessWidget {
  const ColouredRewardStatus({
    Key? key,
    required this.status,
  }) : super(key: key);

  final String status;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var brightness =
        Provider.of<SettingsProvider>(context).getSelectedBrightness(
      MediaQuery.of(context).platformBrightness,
    );

    var statusLowerCase = status.toLowerCase();
    Color textColor;
    Color backgroundColor;
    if (statusLowerCase == "received") {
      textColor = Colors.white;
      backgroundColor = const Color.fromRGBO(0, 100, 0, 50);
    } else if (statusLowerCase == "pending") {
      var isLightTheme = brightness == Brightness.light;
      if (!isLightTheme) {
        textColor = Colors.black;
        backgroundColor = const Color.fromRGBO(200, 200, 200, 10);
      } else {
        textColor = theme.primaryColor;
        backgroundColor = const Color.fromRGBO(210, 210, 210, 10);
      }
    } else {
      textColor = Colors.white;
      backgroundColor = const Color.fromRGBO(178, 34, 34, 50);
    }

    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor, // Text color.
          fontSize: 12.0,
        ),
      ),
    );
  }
}
