import 'dart:io';

import 'package:client/models/transaction.dart';
import 'package:client/providers/user_auth.dart';
import 'package:client/providers/user_transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _addressKey = GlobalKey<FormFieldState>();
  late final _loggedUser = ref.watch(userAuthProvider).valueOrNull;
  late String _address = _loggedUser?.address ?? '';
  PaymentMethod _paymentMethod = PaymentMethod.Cash;
  Widget _selectedImage = const Center(child: Text('Upload Payment Proof'));
  late File? _file;

  void _changeAddress(String value) {
    setState(() {
      _address = value;
    });
  }

  void _changePaymentMethod(PaymentMethod? value) {
    setState(() {
      _paymentMethod = value!;
    });
  }

  String? _validateAddress(String? value) {
    if (value!.trim().isEmpty) {
      return 'Address is required';
    }
    return null;
  }

  String? _validatePaymentMethod(PaymentMethod? value) {
    if (value == null) {
      return 'Payment Method is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    void checkout() async {
      if (!formKey.currentState!.validate() || _file?.path.isEmpty != false) {
        return;
      }

      await ref
          .read(userTransactionsProvider.notifier)
          .post(context, _loggedUser!, _address, _paymentMethod, _file!);
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
                key: _addressKey,
                initialValue: _address,
                decoration: const InputDecoration(
                  labelText: 'Address',
                ),
                onChanged: _changeAddress,
                validator: _validateAddress,
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
                onChanged: _changePaymentMethod,
                validator: _validatePaymentMethod,
              ),
              const SizedBox(height: 12),
              const Text('Payment Instructions'),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_paymentMethod == PaymentMethod.Cash)
                    const Text(
                      'Please come to our office to discuss about payment at: Jl. Letjend S. Parman No.111a, Purwantoro, Kec. Blimbing, Kota Malang, Jawa Timur 65126',
                    ),
                  if (_paymentMethod == PaymentMethod.CreditCard)
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12),
                        Text('Please transfer to our bank account at:'),
                        SizedBox(height: 12),
                        Text('Bank: BCA'),
                        Text('Account Number: 3124122133'),
                        Text('Account Name: WheelWizards'),
                      ],
                    ),
                  if (_paymentMethod == PaymentMethod.DebitCard)
                    const Text(
                      'Please come to our office to discuss about payment at: Jl. Letjend S. Parman No.111a, Purwantoro, Kec. Blimbing, Kota Malang, Jawa Timur 65126',
                    ),
                ],
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
