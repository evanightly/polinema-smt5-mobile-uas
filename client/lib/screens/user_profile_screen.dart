import 'package:client/models/user.dart';
import 'package:client/providers/user_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [_EditProfile()],
      ),
      body: const Flex(
        direction: Axis.vertical,
        children: [
          _ProfileAvatar(),
          SizedBox(height: 24),
          SizedBox(height: 15),
          _ProfileName(),
          SizedBox(height: 6),
          _ProfileEmail(),
        ],
      ),
    );
  }
}

class _EditProfile extends ConsumerWidget {
  const _EditProfile();

  void openEditDialog(BuildContext context, User loggedUser) {
    var emailController = TextEditingController(text: loggedUser.email);
    var nameController = TextEditingController(text: loggedUser.name);
    var passwordController = TextEditingController();

    void update() {}

    showDialog(
      context: context,
      builder: (ctx) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Profile'),
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
                          foregroundImage: loggedUser.imageProviderWidget,
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
                    controller: emailController,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(hintText: 'Email'),
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
    final loggedUser = ref.watch(userAuthProvider);

    return IconButton(
      onPressed: () => openEditDialog(context, loggedUser!),
      icon: const Icon(Icons.edit),
    );
  }
}

class _ProfileAvatar extends ConsumerWidget {
  const _ProfileAvatar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loggedUser = ref.watch(userAuthProvider);
    return SizedBox(
        width: double.infinity,
        height: 150,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: loggedUser!.imageProviderWidget,
              fit: BoxFit.cover,
            ),
          ),
        ));
  }
}

class _ProfileName extends ConsumerWidget {
  const _ProfileName();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(userAuthProvider)!.name;
    return Text(name, style: Theme.of(context).textTheme.headlineMedium);
  }
}

class _ProfileEmail extends ConsumerWidget {
  const _ProfileEmail();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(userAuthProvider)!.email;
    return Text(email, style: Theme.of(context).textTheme.bodyMedium);
  }
}
