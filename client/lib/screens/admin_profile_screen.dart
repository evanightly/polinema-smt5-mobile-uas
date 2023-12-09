import 'dart:io';

import 'package:client/models/admin.dart';
import 'package:client/providers/admin_auth.dart';
import 'package:client/providers/admins.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

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

class _EditProfile extends ConsumerStatefulWidget {
  const _EditProfile();

  @override
  ConsumerState<_EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<_EditProfile> {
  void openEditDialog(
      BuildContext context, Admin loggedAdmin, StateSetter setState) {
    late String name;
    late String email;
    late String password;
    File? file;
    late Widget selectedImage;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        name = loggedAdmin.name;
        email = loggedAdmin.email;
        password = loggedAdmin.password;

        if (loggedAdmin.imageUrl != null) {
          selectedImage = Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              image: DecorationImage(
                image: loggedAdmin.imageProviderWidget,
                fit: BoxFit.cover,
              ),
            ),
            width: 240,
            height: 240,
          );
        }

        void update() async {
          final isValid = formKey.currentState!.validate();
          if (!isValid) {
            return;
          }

          final newAdmin = Admin(
            id: loggedAdmin.id,
            name: name,
            email: email,
            password: password,
            uploadImage: file,
            isSuperAdmin: loggedAdmin.isSuperAdmin,
          );

          ref.read(adminsProvider.notifier).put(newAdmin);
          await ref.read(adminAuthProvider.notifier).refresh();

          if (mounted) {
            Navigator.pop(context);

            ElegantNotification.success(
              title: const Text("Updated"),
              description: const Text("Personal information has been updated"),
              background: Theme.of(context).colorScheme.background,
            ).show(context);
          }
        }

        String? nameValidator(String? value) {
          if (value!.trim().isEmpty) {
            return 'Name cannot be empty';
          }
          return null;
        }

        String? emailValidator(String? value) {
          if (value!.trim().isEmpty) {
            return 'Email cannot be empty';
          }
          return null;
        }

        String? passwordValidator(String? value) {
          if (value!.trim().isEmpty) {
            return 'Password cannot be empty';
          }
          return null;
        }

        // This field is optional

        // String? addressValidator(String? value) {
        //   if (value!.trim().isEmpty) {
        //     return 'Address cannot be empty';
        //   }
        //   return null;
        // }

        void setName(String value) => setState(() => name = value);
        void setEmail(String value) => setState(() => email = value);
        void setPassword(String value) => setState(() => password = value);

        void selectImage() async {
          final isConfirmed = await showDialog<bool>(
            context: context,
            builder: (ctx) {
              void useCamera() => Navigator.pop(context, true);
              void useGallery() => Navigator.pop(context, false);
              void cancel() => Navigator.pop(context);

              return AlertDialog(
                title: const Text('Select Image'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.camera_alt),
                      title: const Text('Camera'),
                      onTap: useCamera,
                    ),
                    ListTile(
                      leading: const Icon(Icons.photo),
                      title: const Text('Gallery'),
                      onTap: useGallery,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: cancel,
                    child: const Text('Cancel'),
                  ),
                ],
              );
            },
          );

          if (isConfirmed != null) {
            final imagePicker = ImagePicker();
            final pickedImage = await imagePicker.pickImage(
              source: isConfirmed ? ImageSource.camera : ImageSource.gallery,
            );

            if (pickedImage == null) {
              setState(
                () {
                  file = null;
                  selectedImage = const SizedBox.shrink();
                },
              );
              return;
            }

            setState(
              () {
                file = File(pickedImage.path);

                selectedImage = Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    image: DecorationImage(
                      image: FileImage(file!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: 240,
                  height: 240,
                );
              },
            );
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Edit Admin: ${loggedAdmin.name}'),
            actions: [
              IconButton(onPressed: update, icon: const Icon(Icons.check))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 12),
            child: Form(
              key: formKey,
              child: Flex(
                direction: Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(height: 60, width: 60, child: selectedImage),
                      const SizedBox(width: 24),
                      ElevatedButton(
                        onPressed: selectImage,
                        child: const Text('Change Image'),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    initialValue: name,
                    autocorrect: false,
                    decoration: const InputDecoration(hintText: 'Name'),
                    validator: nameValidator,
                    onChanged: setName,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    initialValue: email,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(hintText: 'Email'),
                    validator: emailValidator,
                    onChanged: setEmail,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    initialValue: password,
                    autocorrect: false,
                    obscureText: true,
                    enableSuggestions: false,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(hintText: 'Password'),
                    validator: passwordValidator,
                    onChanged: setPassword,
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
    final loggedAdmin = ref.watch(adminAuthProvider);

    return IconButton(
      onPressed: () => openEditDialog(context, loggedAdmin!, setState),
      icon: const Icon(Icons.edit),
    );
  }
}

class _ProfileAvatar extends ConsumerWidget {
  const _ProfileAvatar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loggedAdmin = ref.watch(adminAuthProvider);
    return SizedBox(
      width: double.infinity,
      height: 150,
      child: CircleAvatar(
        foregroundImage: loggedAdmin?.imageProviderWidget,
      ),
    );
  }
}

class _ProfileBadge extends ConsumerWidget {
  const _ProfileBadge();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSuperAdmin = ref.watch(adminAuthProvider)!.isSuperAdmin;

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

class _ProfileName extends ConsumerWidget {
  const _ProfileName();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(adminAuthProvider)!.name;
    return Text(name, style: Theme.of(context).textTheme.headlineMedium);
  }
}

class _ProfileEmail extends ConsumerWidget {
  const _ProfileEmail();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(adminAuthProvider)!.email;
    return Text(email, style: Theme.of(context).textTheme.bodyMedium);
  }
}
