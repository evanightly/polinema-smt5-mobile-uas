import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:client/models/car.dart';
import 'package:client/providers/cars.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> deleteCar(BuildContext context, WidgetRef ref, Car car) async {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.warning,
    animType: AnimType.rightSlide,
    title: 'Are you sure?',
    desc:
        'You are about to delete car ${car.name}\n\nWarning: this operation will delete all data related to this car',
    btnCancelOnPress: () {},
    btnOkOnPress: () async {
      try {
        final isDeleted = await ref.read(carsProvider.notifier).delete(car.id!);
        ref.read(carsProvider.notifier).refresh();

        if (isDeleted) {
          if (context.mounted) {
            ElegantNotification.success(
              title: const Text("Success"),
              description: Text("${car.name} deleted!"),
              background: Theme.of(context).colorScheme.background,
            ).show(context);
          }
        }
      } catch (e) {
        if (context.mounted) {
          ElegantNotification.error(
            title: const Text("Failed"),
            description: Text("Failed to delete ${car.name}"),
            background: Theme.of(context).colorScheme.background,
          ).show(context);
        }
      }
    },
  ).show();
}
