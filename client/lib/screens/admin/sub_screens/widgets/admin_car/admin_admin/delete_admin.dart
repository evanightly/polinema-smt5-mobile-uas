import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:client/models/admin.dart';
import 'package:client/providers/admins.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteAdmin extends ConsumerWidget {
  const DeleteAdmin({required this.admin, super.key});
  final Admin admin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void delete() {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Are you sure?',
        desc:
            'You are about to delete ${admin.name}\n\nWarning: this operation will delete all data related to this admin',
        btnCancelOnPress: () {},
        btnOkOnPress: () async {
          try {
            ref.read(adminsProvider.notifier).delete(admin);
            if (context.mounted) {
              ElegantNotification.success(
                title: const Text("delete"),
                description: Text("${admin.name} has been deleted"),
                background: Theme.of(context).colorScheme.background,
              ).show(context);
            }
          } catch (e) {
            if (context.mounted) {
              ElegantNotification.error(
                title: const Text("Failed"),
                description: Text("Failed to delete ${admin.name}"),
                background: Theme.of(context).colorScheme.background,
              ).show(context);
            }
          }
        },
      ).show();
    }

    return IconButton(
      onPressed: delete,
      icon: const Icon(Icons.delete),
      color: Colors.red.shade400,
    );
  }
}
