import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/settings_provider.dart';

class ColouredTransactionStatusBox extends StatelessWidget {
  const ColouredTransactionStatusBox({
    Key? key,
    required this.text,
    required this.received,
    required this.status,
    required this.method,
  }) : super(key: key);

  final String text;
  final bool received;
  final String status;
  final String method;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var isFailed = status.toLowerCase() == "failed";
    var isSpawn = method.toLowerCase() == "spawn";

    var brightness =
        Provider.of<SettingsProvider>(context).getSelectedBrightness(
      MediaQuery.of(context).platformBrightness,
    );
    var isLightTheme = brightness == Brightness.light;
    var textColor;
    var backgroundColor;
    if (!isLightTheme) {
      var textColorSuccess = Colors.black;
      var backgroundSuccess = Color.fromRGBO(200, 200, 200, 10);

      var textColorFailed = Colors.black;
      var backgroundFailed = Color.fromRGBO(100, 100, 100, 10);

      textColor = textColorSuccess;
      backgroundColor = backgroundSuccess;
      if (isFailed) {
        textColor = textColorFailed;
        backgroundColor = backgroundFailed;
      }
    } else {
      var textColorSuccess = theme.primaryColor;
      var backgroundSuccess = Color.fromRGBO(210, 210, 210, 10);

      var textColorFailed = Color.fromRGBO(100, 100, 100, 10);
      var backgroundFailed = Color.fromRGBO(240, 240, 240, 10);

      textColor = textColorSuccess;
      backgroundColor = backgroundSuccess;
      if (isFailed) {
        textColor = textColorFailed;
        backgroundColor = backgroundFailed;
      }
    }

    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor, // Text color.
          fontSize: 12.0,
        ),
      ),
    );
  }
}
