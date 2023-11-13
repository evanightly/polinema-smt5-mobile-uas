import 'dart:io';

import 'package:client/models/user.dart';
import 'package:client/providers/users.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

void openEditUserDialog(BuildContext context, User user) {
  showDialog(
    context: context,
    builder: (ctx) {
      return UpdateUser(user: user);
    },
  );
}

class UpdateUser extends ConsumerStatefulWidget {
  const UpdateUser({required this.user, super.key});

  final User user;
  @override
  ConsumerState<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends ConsumerState<UpdateUser> {
  late String _name;
  late String _email;
  late String _password;
  late String _imagePath;
  File? _file;
  late Widget _selectedImage;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _name = widget.user.name;
    _email = widget.user.email;
    _password = widget.user.password;
    _imagePath = widget.user.imageUrl;
    if (widget.user.image != null) {
      _selectedImage = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          image: DecorationImage(
            image: widget.user.imageProviderWidget,
            fit: BoxFit.cover,
          ),
        ),
        width: 240,
        height: 240,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    void update() {
      final isValid = _formKey.currentState!.validate();
      if (!isValid) {
        return;
      }

      final newUser = User(
        id: widget.user.id,
        name: _name,
        email: _email,
        password: _password,
        image: _imagePath,
        uploadImage: _file,
      );

      ref.read(usersProvider.notifier).put(newUser);

      Navigator.pop(context);

      ElegantNotification.success(
        title: const Text("Updated"),
        description: Text("$_name has been updated"),
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User: ${widget.user.name}'),
        actions: [IconButton(onPressed: update, icon: const Icon(Icons.check))],
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
                  SizedBox(height: 60, width: 60, child: _selectedImage),
                  const SizedBox(width: 24),
                  ElevatedButton(
                    onPressed: selectImage,
                    child: const Text('Change Image'),
                  )
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _name,
                autocorrect: false,
                decoration: const InputDecoration(hintText: 'Name'),
                validator: nameValidator,
                onChanged: setName,
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _email,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(hintText: 'Email'),
                validator: emailValidator,
                onChanged: setEmail,
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _password,
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
  }
}
