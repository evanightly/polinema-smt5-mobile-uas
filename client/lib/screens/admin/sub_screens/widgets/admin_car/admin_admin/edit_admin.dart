// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:client/models/admin.dart';
import 'package:client/providers/admins.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

void openEditAdminDialog(BuildContext context, Admin admin) {
  showDialog(
    context: context,
    builder: (ctx) {
      return UpdateAdmin(admin: admin);
    },
  );
}

class UpdateAdmin extends ConsumerStatefulWidget {
  const UpdateAdmin({required this.admin, super.key});

  final Admin admin;
  @override
  ConsumerState<UpdateAdmin> createState() => _UpdateAdminState();
}

class _UpdateAdminState extends ConsumerState<UpdateAdmin> {
  late String _name;
  late String _email;
  late String _password;
  late bool _is_super_admin;
  File? _file;
  late Widget _selectedImage;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _name = widget.admin.name;
    _email = widget.admin.email;
    _password = '';
    _is_super_admin = widget.admin.isSuperAdmin;

    if (widget.admin.imageUrl != null) {
      _selectedImage = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          image: DecorationImage(
            image: widget.admin.imageProviderWidget,
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
    void update() async {
      final isValid = _formKey.currentState!.validate();
      if (!isValid) {
        return;
      }

      final newAdmin = Admin(
        id: widget.admin.id,
        name: _name,
        email: _email,
        password: _password,
        uploadImage: _file,
        isSuperAdmin: _is_super_admin,
      );

      await ref.read(adminsProvider.notifier).put(newAdmin);
      await ref.read(adminsProvider.notifier).refresh();

      if (mounted) {
        Navigator.pop(context);

        ElegantNotification.success(
          title: const Text("Updated"),
          description: Text("$_name has been updated"),
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

    void setName(String value) => setState(() => _name = value);
    void setEmail(String value) => setState(() => _email = value);
    void setPassword(String value) => setState(() => _password = value);
    void setIsSuperAdmin(bool? value) =>
        setState(() => _is_super_admin = value!);

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
        title: Text('Edit Admin: ${widget.admin.name}'),
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
              const SizedBox(height: 20),
              CheckboxListTile(
                title: const Text('Is Super Admin'),
                value: _is_super_admin,
                onChanged: setIsSuperAdmin,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
