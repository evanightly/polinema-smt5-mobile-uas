import 'package:client/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final settings = ref.watch(settingsProvider);

    return Column(
      children: [
        SwitchListTile.adaptive(
          title: const Text('Dark Mode'),
          value: settings.darkMode,
          onChanged: (changeTo) => settingsNotifier.toggleDarkMode(changeTo),
        ),
      ],
    );
  }
}
