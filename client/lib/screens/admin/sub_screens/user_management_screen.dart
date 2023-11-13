import 'package:client/models/user.dart';
import 'package:client/providers/users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserManagementScreen extends ConsumerWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(usersProvider);

    return users.when(
      data: (data) {
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(4),
              child: ListTile(
                leading: _UserAvatar(data[index]),
                title: Text(
                  data[index].name,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                trailing: _UserActions(data[index]),
              ),
            );
          },
        );
      },
      error: (_, error) {
        return Center(child: Text(_.toString()));
      },
      loading: () {
        return const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Please Wait...'),
            ],
          ),
        );
      },
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar(this.user);
  final User user;

  @override
  Widget build(BuildContext context) {
    Widget image = const SizedBox.shrink();
    if (user.image!.isNotEmpty) {
      image = CircleAvatar(
        backgroundImage: user.imageProviderWidget,
      );
    }
    return image;
  }
}

class _UserActions extends ConsumerWidget {
  const _UserActions(this.user);
  final User user;

  void delete() {}

  void openEditDialog(BuildContext context) {
    var nameController = TextEditingController(text: user.name);
    var emailController = TextEditingController(text: user.email);
    var passwordController = TextEditingController();

    void update() {}
    showDialog(
      context: context,
      builder: (ctx) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit User'),
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
                          foregroundImage: user.imageProviderWidget,
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
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
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
}
