import 'package:client/controllers/auth_controller.dart';
import 'package:client/models/admin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          _ProfileBadge(),
          SizedBox(height: 15),
          _ProfileName(),
          SizedBox(height: 6),
          _ProfileEmail(),
        ],
      ),
    );
  }
}

class _EditProfile extends GetView<AuthController> {
  const _EditProfile();

  void openEditDialog(BuildContext context, Admin loggedUser) {
    var emailController = TextEditingController(text: loggedUser.email);
    var nameController = TextEditingController(text: loggedUser.name);
    var passwordController = TextEditingController();

    void update() {}

    Get.dialog(
      Scaffold(
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
                        foregroundImage: AssetImage(loggedUser.image!),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loggedUser = controller.loggedUser;

    return IconButton(
      onPressed: () => openEditDialog(context, loggedUser),
      icon: const Icon(Icons.edit),
    );
  }
}

class _ProfileAvatar extends GetView<AuthController> {
  const _ProfileAvatar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 150,
      child: CircleAvatar(
        foregroundImage: AssetImage(controller.loggedUser.image!),
      ),
    );
  }
}

class _ProfileBadge extends GetView<AuthController> {
  const _ProfileBadge();

  @override
  Widget build(BuildContext context) {
    final isSuperAdmin = controller.loggedUser.isSuperAdmin;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [.2, .87],
          colors: [
            if (isSuperAdmin) ...[
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withOpacity(.5)
            ] else ...[
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.secondary.withOpacity(.5)
            ]
          ],
        ),
        color: isSuperAdmin
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        isSuperAdmin ? 'Super Admin' : 'Admin',
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: isSuperAdmin
                  ? Theme.of(context).colorScheme.onError
                  : Theme.of(context).colorScheme.onSecondary,
            ),
      ),
    );
  }
}

class _ProfileName extends GetView<AuthController> {
  const _ProfileName();

  @override
  Widget build(BuildContext context) {
    final name = controller.loggedUser.name;

    return Text(name, style: Theme.of(context).textTheme.headlineMedium);
  }
}

class _ProfileEmail extends GetView<AuthController> {
  const _ProfileEmail();

  @override
  Widget build(BuildContext context) {
    final email = controller.loggedUser.email;
    return Text(email, style: Theme.of(context).textTheme.bodyMedium);
  }
}
