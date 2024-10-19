import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/extensions/string_extensions.dart';
import '/provider/settings_provider.dart';

class ThemeModeMenu extends StatelessWidget {
  const ThemeModeMenu({super.key});

  final List<ThemeMode> _options = ThemeMode.values;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<SettingsProvider>(context);

    return Expanded(
      flex: 9,
      child: ListView.builder(
          itemCount: _options.length,
          itemBuilder: (BuildContext context, int index) {
            return RadioListTile(
              value: index,
              title: Text(_options[index].name.capitalize()),
              groupValue: themeProvider.themeMode.index,
              onChanged: (value) {
                final provider = Provider.of<SettingsProvider>(
                  context,
                  listen: false,
                );
                provider.themeMode = _options[index];
              },
              visualDensity: VisualDensity.compact,
            );
          }),
    );
  }
}
