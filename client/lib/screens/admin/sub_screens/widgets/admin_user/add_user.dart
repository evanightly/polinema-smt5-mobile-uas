import 'dart:io';

import 'package:client/models/user.dart';
import 'package:client/providers/users.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AddUser extends ConsumerStatefulWidget {
  const AddUser({super.key});

  @override
  ConsumerState<AddUser> createState() => _AddUserState();
}

class _AddUserState extends ConsumerState<AddUser> {
  late String _name;
  late String _email;
  late String _password;
  File? _file;
  Widget? _selectedImage;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    void showAddUserDialog() {
      void add() {
        final isValid = _formKey.currentState!.validate();
        if (!isValid && _file == null) {
          return;
        }

        final newUser = User(
          name: _name,
          email: _email,
          password: _password,
          uploadImage: _file,
        );

        ref.read(usersProvider.notifier).add(newUser);

        Navigator.pop(context);

        ElegantNotification.success(
          title: const Text("Registered"),
          description: Text("$_name has been registered"),
          background: Theme.of(context).colorScheme.background,
        ).show(context);
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

      void setName(String value) => setState(() => _name = value);
      void setEmail(String value) => setState(() => _email = value);
      void setPassword(String value) => setState(() => _password = value);

      void selectImage(StateSetter setState) async {
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
                _file = null;
                _selectedImage = const SizedBox.shrink();
              },
            );
            return;
          }

          setState(
            () {
              _file = File(pickedImage.path);
              _selectedImage = Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  image: DecorationImage(
                    image: FileImage(_file!),
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

      showDialog(
        context: context,
        builder: (ctx) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Add User'),
                  actions: [
                    IconButton(onPressed: add, icon: const Icon(Icons.check))
                  ],
                ),
                body: Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 12),
                  child: Form(
                    key: _formKey,
                    child: Flex(
                      direction: Axis.vertical,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (_selectedImage != null)
                              SizedBox(
                                height: 60,
                                width: 60,
                                child: _selectedImage,
                              ),
                            const SizedBox(width: 24),
                            ElevatedButton(
                              onPressed: () => selectImage(setState),
                              child: const Text('Change Image'),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          autocorrect: false,
                          decoration: const InputDecoration(hintText: 'Name'),
                          validator: nameValidator,
                          onChanged: setName,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(hintText: 'Email'),
                          validator: emailValidator,
                          onChanged: setEmail,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          autocorrect: false,
                          obscureText: true,
                          enableSuggestions: false,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration:
                              const InputDecoration(hintText: 'Password'),
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

    return IconButton(
        onPressed: showAddUserDialog, icon: const Icon(Icons.add));
  }
}
