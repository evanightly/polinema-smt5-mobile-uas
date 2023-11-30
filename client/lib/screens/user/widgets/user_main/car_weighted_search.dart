// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:client/providers/cars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CarWeightedSearch extends ConsumerWidget {
  const CarWeightedSearch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();
    var priceWeight = 0.0;
    var yearWeight = 0.0;
    var mileageWeight = 0.0;

    void submit() {
      final isValid = _formKey.currentState!.validate();
      if (!isValid) {
        return;
      }

      _formKey.currentState!.save();

      ref
          .read(carsProvider.notifier)
          .search(priceWeight, yearWeight, mileageWeight);
    }

    String? priceWeightValidator(String? value) {
      if (value!.trim().isEmpty) {
        return 'Price weight cannot be empty';
      }
      return null;
    }

    String? yearWeightValidator(String? value) {
      if (value!.trim().isEmpty) {
        return 'Year weight cannot be empty';
      }
      return null;
    }

    String? mileageWeightValidator(String? value) {
      if (value!.trim().isEmpty) {
        return 'Mileage weight cannot be empty';
      }
      return null;
    }

    void setPriceWeight(String? value) {
      priceWeight = double.tryParse(value!) ?? 0;
    }

    void setYearWeight(String? value) {
      yearWeight = double.tryParse(value!) ?? 0;
    }

    void setMileageWeight(String? value) {
      mileageWeight = double.tryParse(value!) ?? 0;
    }

    void openFilterScreen() {
      Navigator.push(
        context,
        PageRouteBuilder(
          opaque: false,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            final tween = Tween(begin: begin, end: end).chain(CurveTween(
              curve: curve,
            ));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          pageBuilder: (context, _, __) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Filter'),
              ),
              body: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      Text(
                        'Please enter weight priority of each field',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Price'),
                        validator: priceWeightValidator,
                        onSaved: setPriceWeight,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Year'),
                        validator: yearWeightValidator,
                        onSaved: setYearWeight,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Mileage'),
                        validator: mileageWeightValidator,
                        onSaved: setMileageWeight,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: submit,
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    return IconButton(
      onPressed: openFilterScreen,
      icon: const Icon(Icons.filter_alt_outlined),
    );
  }
}
