import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/settings_provider.dart';

class TileCard extends StatelessWidget {
  const TileCard({
    required this.value,
    required this.label,
  });

  final String? value;
  final String label;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var brightness =
        Provider.of<SettingsProvider>(context).getSelectedBrightness(
      MediaQuery.of(context).platformBrightness,
    );

    Color fillColor;
    switch (brightness) {
      case Brightness.light:
        fillColor = theme.cardColor.withOpacity(0.9);
        break;
      case Brightness.dark:
        fillColor = Colors.teal.withOpacity(0.15);
        break;
    }
    return Card(
      elevation: 0.3,
      color: fillColor,
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
        title: Text(
          value!,
          style: theme.textTheme.titleLarge,
        ),
        subtitle: Text(label),
        dense: true,
      ),
    );
  }
}
