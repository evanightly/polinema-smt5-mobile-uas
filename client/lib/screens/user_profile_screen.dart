import 'package:client/controllers/auth_controller.dart';
import 'package:client/models/admin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});
  static AuthController authController = Get.find();
  static Admin loggedUser = authController.loggedUser; // Need Observeable?
  void openEditDialog(BuildContext context) {
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
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => openEditDialog(context),
              icon: const Icon(Icons.edit))
        ],
      ),
      body: Flex(
        direction: Axis.vertical,
        children: [
          SizedBox(
            width: double.infinity,
            height: 150,
            child: CircleAvatar(foregroundImage: AssetImage(loggedUser.image!)),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [
                    .2,
                    .87
                  ],
                  colors: [
                    if (loggedUser.isSuperAdmin) ...[
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withOpacity(.5)
                    ] else ...[
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.secondary.withOpacity(.5)
                    ]
                  ]),
              color: loggedUser.isSuperAdmin
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              loggedUser.isSuperAdmin ? 'Super Admin' : 'Admin',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: loggedUser.isSuperAdmin
                        ? Theme.of(context).colorScheme.onError
                        : Theme.of(context).colorScheme.onSecondary,
                  ),
            ),
          ),
          const SizedBox(height: 15),
          Text(loggedUser.name,
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 6),
          Text(loggedUser.email, style: Theme.of(context).textTheme.bodyMedium)
        ],
      ),
    );
  }
}
