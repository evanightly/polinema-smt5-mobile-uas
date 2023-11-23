import 'dart:io';

import 'package:client/models/user_transaction.dart';
import 'package:client/providers/user_auth.dart';
import 'package:client/providers/user_cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  late final _loggedUser = ref.watch(userAuthProvider);
  late String _address = _loggedUser?.address ?? '';
  PaymentMethod _paymentMethod = PaymentMethod.Cash;
  Widget _selectedImage = const Center(child: Text('Upload Payment Proof'));
  late File? _file;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    void checkout() async {
      print(_paymentMethod.name.runtimeType);
      print('checkout');
      if (!formKey.currentState!.validate()) {
        return;
      }
      print('validated');

      await ref.read(userCartProvider.notifier).checkout(
            context,
            _address,
            _paymentMethod,
            _file,
          );
    }

    void changeAddress(String value) {
      _address = value;
    }

    void changePaymentMethod(PaymentMethod? value) {
      _paymentMethod = value!;
    }

    String? validateAddress(String? value) {
      if (value!.trim().isEmpty) {
        return 'Address is required';
      }
      return null;
    }

    String? validatePaymentMethod(PaymentMethod? value) {
      if (value == null) {
        return 'Payment Method is required';
      }
      return null;
    }

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
            _selectedImage = Image.file(
              _file!,
              fit: BoxFit.cover,
            );
          },
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              const Text('Address'),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _address,
                decoration: const InputDecoration(
                  labelText: 'Address',
                ),
                onChanged: changeAddress,
                validator: validateAddress,
              ),
              const SizedBox(height: 12),
              const Text('Payment Method'),
              const SizedBox(height: 12),
              DropdownButtonFormField(
                value: _paymentMethod,
                decoration: const InputDecoration(
                  labelText: 'Payment Method',
                ),
                items: PaymentMethod.values.map((method) {
                  return DropdownMenuItem(
                    value: method,
                    child: Text(method.toString().split('.').last),
                  );
                }).toList(),
                onChanged: changePaymentMethod,
                validator: validatePaymentMethod,
              ),
              const SizedBox(height: 12),
              const Text('Payment Proof'),
              const SizedBox(height: 12),
              InkWell(
                onTap: selectImage,
                child: Container(
                    clipBehavior: Clip.hardEdge,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    child: _selectedImage),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: checkout,
                child: const Text('Checkout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
