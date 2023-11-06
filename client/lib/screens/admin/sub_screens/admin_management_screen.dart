import 'package:client/models/admin.dart';
import 'package:client/providers/admins.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminManagementScreen extends ConsumerWidget {
  const AdminManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget content = const Center(child: Text('No Items Yet'));
    final admins = ref.watch(adminsProvider);

    if (admins.isNotEmpty) {
      content = content = Padding(
        padding: const EdgeInsets.all(4),
        child: ListView.builder(
          itemCount: admins.length,
          itemBuilder: (ctx, index) {
            final item = admins[index];
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

  void openEditDialog(BuildContext context) {
    var nameController = TextEditingController(text: admin.name);
    var emailController = TextEditingController(text: admin.email);
    var passwordController = TextEditingController();

    void update() {}
    showDialog(
      context: context,
      builder: (ctx) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Admin'),
            actions: [
              IconButton(onPressed: update, icon: const Icon(Icons.check))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 12),
            child: Form(
              child: Flex(
                direction: Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 60,
                        width: 60,
                        child: CircleAvatar(
                          foregroundImage: AssetImage(admin.image!),
                        ),
                      ),
                      const SizedBox(width: 24),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Change Image'),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: nameController,
                    autocorrect: false,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(hintText: 'Name'),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: emailController,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(hintText: 'Email'),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: passwordController,
                    autocorrect: false,
                    obscureText: true,
                    enableSuggestions: false,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(hintText: 'Password'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

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
            onPressed: () => openEditDialog(context),
            icon: const Icon(Icons.edit),
            color: Colors.blue.shade400,
          )
        ],
      );
    }
    return actions;
  }
}
