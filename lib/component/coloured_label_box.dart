import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/settings_provider.dart';

class ColouredLabelBox extends StatelessWidget {
  const ColouredLabelBox({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var brightness =
        Provider.of<SettingsProvider>(context).getSelectedBrightness(
      MediaQuery.of(context).platformBrightness,
    );
    var isLightTheme = brightness == Brightness.light;

    return Container(
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: isLightTheme ? theme.focusColor : theme.primaryColorLight,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: theme.primaryColor, // Text color.
          fontSize: 12.0,
        ),
      ),
    );
  }
}
