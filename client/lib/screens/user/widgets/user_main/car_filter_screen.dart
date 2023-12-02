// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:client/models/car.dart';
import 'package:client/models/car_body_type.dart';
import 'package:client/models/car_brand.dart';
import 'package:client/models/car_filter.dart';
import 'package:client/providers/car_body_types.dart';
import 'package:client/providers/car_brands.dart';
import 'package:client/providers/cars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropdown_search/dropdown_search.dart';

class CarFilterScreen extends ConsumerStatefulWidget {
  const CarFilterScreen({super.key});

  @override
  ConsumerState<CarFilterScreen> createState() => _CarFilterScreenState();
}

class _CarFilterScreenState extends ConsumerState<CarFilterScreen>
    with AutomaticKeepAliveClientMixin<CarFilterScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final _formKey = GlobalKey<FormState>();
    final carBrands = ref.watch(carBrandsProvider);
    final carBodyTypes = ref.watch(carBodyTypesProvider);

    String? minPrice;
    String? maxPrice;
    String? minKm;
    String? maxKm;
    String? minYear;
    String? maxYear;
    CarBrand? selectedBrand;
    CarBodyType? selectedBodyType;
    CarTransmission? selectedTransmission;
    CarCondition? selectedCondition;

    void submit() {
      final isValid = _formKey.currentState!.validate();
      if (!isValid) {
        return;
      }

      _formKey.currentState!.save();

      ref.read(carsProvider.notifier).filter(
            CarFilter(
              minPrice: minPrice,
              maxPrice: maxPrice,
              minKm: minKm,
              maxKm: maxKm,
              minYear: minYear,
              maxYear: maxYear,
              brand: selectedBrand,
              bodyType: selectedBodyType,
              transmission: selectedTransmission,
              condition: selectedCondition,
            ),
          );

      Navigator.pop(context);
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
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration:
                                  const InputDecoration(labelText: 'Min Price'),
                              onSaved: (value) {
                                setState(() {
                                  minPrice = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration:
                                  const InputDecoration(labelText: 'Max Price'),
                              onChanged: (value) {
                                setState(() {
                                  maxPrice = value;
                                });
                              },
                              onSaved: (value) {
                                setState(() {
                                  maxPrice = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: minKm,
                              keyboardType: TextInputType.number,
                              decoration:
                                  const InputDecoration(labelText: 'Min km'),
                              onChanged: (value) {
                                setState(() {
                                  minKm = value;
                                });
                              },
                              onSaved: (value) {
                                setState(() {
                                  minKm = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              initialValue: maxKm,
                              keyboardType: TextInputType.number,
                              decoration:
                                  const InputDecoration(labelText: 'Max km'),
                              onChanged: (value) {
                                setState(() {
                                  maxKm = value;
                                });
                              },
                              onSaved: (value) {
                                setState(() {
                                  maxKm = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: minYear,
                              keyboardType: TextInputType.number,
                              decoration:
                                  const InputDecoration(labelText: 'Min Year'),
                              onChanged: (value) {
                                setState(() {
                                  minYear = value;
                                });
                              },
                              onSaved: (value) {
                                setState(() {
                                  minYear = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              initialValue: maxYear,
                              keyboardType: TextInputType.number,
                              decoration:
                                  const InputDecoration(labelText: 'Max Year'),
                              onChanged: (value) {
                                setState(() {
                                  maxYear = value;
                                });
                              },
                              onSaved: (value) {
                                setState(() {
                                  maxYear = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      DropdownSearch<CarBrand>(
                        selectedItem: selectedBrand,
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            hintText: 'Brand',
                            label: Text('Brand'),
                          ),
                        ),
                        itemAsString: (item) => item.name,
                        filterFn: (item, filter) {
                          var brandName = item.name.toLowerCase();
                          var filterValue = filter.toLowerCase();
                          return brandName.contains(filterValue);
                        },
                        compareFn: (a, b) => a == b,
                        popupProps: PopupProps.modalBottomSheet(
                          modalBottomSheetProps: ModalBottomSheetProps(
                            backgroundColor:
                                Theme.of(context).colorScheme.surface,
                          ),
                          searchFieldProps: const TextFieldProps(
                            decoration: InputDecoration(
                              hintText: 'Search Brand',
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                          showSelectedItems: true,
                          showSearchBox: true,
                          title: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              'Select Brand',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          itemBuilder:
                              (context, CarBrand? brand, bool? isSelected) {
                            return ListTile(
                              tileColor: Theme.of(context).colorScheme.surface,
                              selected: isSelected!,
                              title: Text(brand!.name),
                              subtitle: Text(brand.name),
                              leading: const Icon(Icons.branding_watermark),
                            );
                          },
                        ),
                        items: [
                          for (final brand in carBrands.asData!.value) brand
                        ],
                        onChanged: (brand) {
                          setState(() {
                            selectedBrand = brand;
                          });
                        },
                        onSaved: (brand) {
                          setState(() {
                            selectedBrand = brand;
                          });
                        },
                      ),
                      // car body type dropdown
                      const SizedBox(height: 16),
                      DropdownSearch<CarBodyType>(
                        selectedItem: selectedBodyType,
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            hintText: 'Body Type',
                            label: Text('Body Type'),
                          ),
                        ),
                        itemAsString: (item) => item.name,
                        filterFn: (item, filter) {
                          var bodyType = item.name.toLowerCase();
                          var filterValue = filter.toLowerCase();
                          return bodyType.contains(filterValue);
                        },
                        compareFn: (a, b) => a == b,
                        popupProps: PopupProps.modalBottomSheet(
                          modalBottomSheetProps: ModalBottomSheetProps(
                            backgroundColor:
                                Theme.of(context).colorScheme.surface,
                          ),
                          searchFieldProps: const TextFieldProps(
                            decoration: InputDecoration(
                              hintText: 'Search Body Type',
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                          showSelectedItems: true,
                          showSearchBox: true,
                          title: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              'Select Body Type',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          itemBuilder: (context, CarBodyType? bodyType,
                              bool? isSelected) {
                            return ListTile(
                              tileColor: Theme.of(context).colorScheme.surface,
                              selected: isSelected!,
                              title: Text(bodyType!.name),
                              subtitle: Text(bodyType.name),
                              leading: const Icon(Icons.branding_watermark),
                            );
                          },
                        ),
                        items: [
                          for (final bodyType in carBodyTypes.asData!.value)
                            bodyType
                        ],
                        onChanged: (bodyType) {
                          setState(() {
                            selectedBodyType = bodyType;
                          });
                        },
                        onSaved: (bodyType) {
                          setState(() {
                            selectedBodyType = bodyType;
                          });
                        },
                      ),
                      // transmission dropdown
                      const SizedBox(height: 16),
                      DropdownButtonFormField<CarTransmission>(
                        value: selectedTransmission,
                        decoration: const InputDecoration(
                          hintText: 'Transmission',
                          label: Text('Transmission'),
                        ),
                        items: [
                          for (final condition in CarTransmission.values)
                            DropdownMenuItem(
                              value: condition,
                              child: Text(condition.name),
                            )
                        ],
                        onChanged: (newValue) {
                          setState(() {
                            selectedTransmission = newValue;
                          });
                        },
                        onSaved: (newValue) {
                          setState(() {
                            selectedTransmission = newValue;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<CarCondition>(
                        value: selectedCondition,
                        decoration: const InputDecoration(
                          hintText: 'Condition',
                          label: Text('Condition'),
                        ),
                        items: [
                          for (final condition in CarCondition.values)
                            DropdownMenuItem(
                              value: condition,
                              child: Text(condition.name),
                            )
                        ],
                        onChanged: (newValue) {
                          setState(() {
                            selectedCondition = newValue;
                          });
                        },
                        onSaved: (newValue) {
                          setState(() {
                            selectedCondition = newValue;
                          });
                        },
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
