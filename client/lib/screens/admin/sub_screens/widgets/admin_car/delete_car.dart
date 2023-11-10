import 'package:flutter/material.dart';

Future<bool> deleteCar(BuildContext context) async {
  return await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      void destroy() => Navigator.pop(context, true);

      void cancel() => Navigator.pop(context, false);

      return AlertDialog(
        title: const Text('Delete Data'),
        content: const Text('Are You Sure?'),
        actions: [
          TextButton(onPressed: destroy, child: const Text('Yes')),
          TextButton(onPressed: cancel, child: const Text('Cancel')),
        ],
      );
    },
  );
}
