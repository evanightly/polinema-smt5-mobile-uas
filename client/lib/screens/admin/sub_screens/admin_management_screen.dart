import 'package:client/models/admin.dart';
import 'package:client/providers/admin_auth.dart';
import 'package:client/providers/admins.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminManagementScreen extends ConsumerWidget {
  const AdminManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final admins = ref.watch(adminsProvider);
    final auth = ref.watch(adminAuthProvider);
    return admins.when(data: (data) {
      return Padding(
        padding: const EdgeInsets.all(4),
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (ctx, index) {
            final item = data[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: item.imageProviderWidget,
              ),
              title: Text(
                item.name,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              subtitle: Text(
                item.is_super_admin ? 'Super Admin' : 'Admin',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: item.is_super_admin
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.secondary,
                    ),
              ),
              trailing: auth!.is_super_admin
                  ? _AdminActions(item)
                  : const SizedBox.shrink(),
            );
          },
        ),
      );
    }, error: (error, stack) {
      return Center(child: Text('Something went wrong $error $stack'));
    }, loading: () {
      return const Center(child: CircularProgressIndicator());
    });
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
                          foregroundImage: admin.imageProviderWidget,
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
    if (!admin.is_super_admin) {
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
