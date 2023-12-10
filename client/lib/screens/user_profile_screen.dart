import 'dart:io';

import 'package:client/models/user.dart';
import 'package:client/providers/user_auth.dart';
import 'package:client/providers/users.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({this.disableBackButton = false, super.key});

  final bool disableBackButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loggedUser = ref.watch(userAuthProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !disableBackButton,
        actions: const [_EditProfile()],
      ),
      body: SizedBox(
        width: double.infinity,
        child: Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _ProfileAvatar(loggedUser.value),
            const SizedBox(height: 24),
            const SizedBox(height: 15),
            _ProfileName(loggedUser.value),
            const SizedBox(height: 6),
            _ProfileEmail(loggedUser.value),
            const SizedBox(height: 6),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              height: 1,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(.2),
            ),
            const SizedBox(height: 6),
            _ProfileAddress(loggedUser.value)
          ],
        ),
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
  void openEditDialog(BuildContext context, User loggedUser) {
    late String name;
    late String email;
    late String password;
    late String address;
    File? file;
    late Widget selectedImage;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        name = loggedUser.name;
        email = loggedUser.email;
        password = '';
        address = loggedUser.address ?? '';

        if (loggedUser.imageUrl != null) {
          selectedImage = Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              image: DecorationImage(
                image: loggedUser.imageProviderWidget,
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

          final newUser = User(
            id: loggedUser.id,
            name: name,
            email: email,
            address: address,
            password: password,
            uploadImage: file,
          );

          await ref.read(usersProvider.notifier).put(newUser);
          await ref.read(userAuthProvider.notifier).refresh();

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
          // if (value!.trim().isEmpty) {
          //   return 'Password cannot be empty';
          // }
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
        void setAddress(String value) => setState(() => address = value);

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

        return StatefulBuilder(
          builder: (ctx, setState) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Edit User: ${loggedUser.name}'),
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
                        initialValue: address,
                        autocorrect: false,
                        decoration: const InputDecoration(hintText: 'Address'),
                        onChanged: setAddress,
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loggedUser = ref.watch(userAuthProvider).valueOrNull;

    return IconButton(
      onPressed: () => openEditDialog(context, loggedUser!),
      icon: const Icon(Icons.edit),
    );
  }
}

class _ProfileAvatar extends ConsumerWidget {
  const _ProfileAvatar(this.loggedUser);
  final User? loggedUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget content = const SizedBox.shrink();

    if (loggedUser!.imageUrl != null) {
      content = CircleAvatar(
        radius: 60,
        backgroundImage: loggedUser!.imageProviderWidget,
      );
    }

    return content;
  }
}

class _ProfileName extends ConsumerWidget {
  const _ProfileName(this.loggedUser);
  final User? loggedUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget content = const SizedBox.shrink();

    if (loggedUser != null) {
      final name = loggedUser!.name;
      content = Text(name, style: Theme.of(context).textTheme.headlineMedium);
    }

    return content;
  }
}

class _ProfileEmail extends ConsumerWidget {
  const _ProfileEmail(this.loggedUser);
  final User? loggedUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget content = const SizedBox.shrink();

    if (loggedUser != null) {
      final email = loggedUser!.email;
      content = Text(email, style: Theme.of(context).textTheme.bodyMedium);
    }

    return content;
  }
}

class _ProfileAddress extends ConsumerWidget {
  const _ProfileAddress(this.loggedUser);
  final User? loggedUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget content = const SizedBox.shrink();

    if (loggedUser != null && loggedUser?.address != null) {
      content = Text(
        loggedUser!.address!,
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      );
    }

    return content;
  }
}
