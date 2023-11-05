import 'package:client/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        SwitchListTile.adaptive(
          title: const Text('Dark Mode'),
          value: ref.watch(themeProvider),
          onChanged: (changeTo) async {
            await ref.read(themeProvider.notifier).update(changeTo);
          },
        ),
      ],
    );
  }
}
