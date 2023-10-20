import 'package:client/controllers/admin_controller.dart';
import 'package:client/models/admin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});
  static AdminController adminController = Get.find();

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('No Items Yet'));
    if (adminController.admins.isNotEmpty) {
      content = Obx(
        () => Padding(
          padding: const EdgeInsets.all(4),
          child: ListView.builder(
            itemCount: adminController.admins.length,
            itemBuilder: (ctx, index) {
              final item = adminController.admins[index];
              return ListTile(
                leading: _AdminAvatar(item),
                title: Text(
                  item.name,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                subtitle: Text(
                  item.isSuperAdmin ? 'Super Admin' : 'Admin',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: item.isSuperAdmin
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.secondary,
                      ),
                ),
                trailing: _AdminActions(item),
              );
            },
          ),
        ),
      );
    }

    return content;
  }
}

class _AdminAvatar extends StatelessWidget {
  const _AdminAvatar(this.admin);
  final Admin admin;

  @override
  Widget build(BuildContext context) {
    Widget image = const SizedBox.shrink();
    if (admin.image!.isNotEmpty) {
      image = CircleAvatar(
        backgroundImage: AssetImage(admin.image!),
      );
    }
    return image;
  }
}

class _AdminActions extends StatelessWidget {
  const _AdminActions(this.admin);
  final Admin admin;

  void delete() {}
  void update() {}

  @override
  Widget build(BuildContext context) {
    Widget actions = const SizedBox.shrink();
    if (!admin.isSuperAdmin) {
      actions = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: delete,
            icon: const Icon(Icons.delete),
            color: Colors.red.shade400,
          ),
          IconButton(
            onPressed: update,
            icon: const Icon(Icons.edit),
            color: Colors.blue.shade400,
          )
        ],
      );
    }
    return actions;
  }
}