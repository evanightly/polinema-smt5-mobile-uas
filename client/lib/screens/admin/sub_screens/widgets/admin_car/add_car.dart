// import required packages
import 'dart:io';

import 'package:client/models/car.dart';
import 'package:client/models/car_body_type.dart';
import 'package:client/models/car_brand.dart';
import 'package:client/models/car_fuel.dart';
import 'package:client/providers/car_body_types.dart';
import 'package:client/providers/car_brands.dart';
import 'package:client/providers/car_fuels.dart';
import 'package:client/providers/cars.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AddCar extends ConsumerStatefulWidget {
  const AddCar({super.key});

  @override
  ConsumerState<AddCar> createState() => _AddCarState();
}

class _AddCarState extends ConsumerState<AddCar> {
  final _formKey = GlobalKey<FormState>();
  Widget _selectedImage = const SizedBox.shrink();
  late String _name;
  late CarBrand _brand;
  late CarBodyType _bodyType;
  late String _year;
  late num _kmMin;
  late num _kmMax;
  late CarFuel _fuel;
  late num _price;
  late File? _file;
  late String? _description;
  late CarCondition _condition;
  late CarTransmission _transmission;
  late CarStatus _status;

  // @override
  // void initState() {
  //   super.initState();
  //   getLostData();
  // }

  // Future<void> getLostData() async {
  //   final ImagePicker picker = ImagePicker();
  //   final LostDataResponse response = await picker.retrieveLostData();
  //   if (response.isEmpty) {
  //     return;
  //   }
  //   final List<XFile>? files = response.files;
  //   if (files != null) {
  //     setState(() {
  //       _file = File(files[0].path);
  //     });

  //     if (mounted) {
  //       Navigator.pop(context);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final carBrands = ref.watch(carBrandsProvider);
    final carFuels = ref.watch(carFuelsProvider);
    final carBodyTypes = ref.watch(carBodyTypesProvider);

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
            _selectedImage = Image.file(
              _file!,
              height: 240,
              fit: BoxFit.cover,
            );
          },
        );
      }
    }

    void add() {
      final isValid = _formKey.currentState!.validate();
      if (!isValid) {
        return;
      }

      _formKey.currentState!.save();

      final newCar = Car(
        name: _name,
        brand: _brand,
        body_type: _bodyType,
        year: _year,
        km_min: _kmMin,
        km_max: _kmMax,
        fuel: _fuel,
        price: _price,
        uploadImage: _file,
        description: _description,
        condition: _condition,
        transmission: _transmission,
        status: _status,
      );

      ref.read(carsProvider.notifier).add(newCar);

      Navigator.pop(context);
    }

    void showAddDialog() {
      showDialog(
        context: context,
        builder: (ctx) {
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return Scaffold(
                appBar: AppBar(title: const Text('Add New Item')),
                body: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        const SizedBox(height: 16),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            hintText: 'Name',
                            label: Text('Name'),
                          ),
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Please enter a name'
                                : null;
                          },
                          onChanged: (newValue) {
                            setState(() => _name = newValue);
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownSearch<CarBrand>(
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
                                tileColor:
                                    Theme.of(context).colorScheme.surface,
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
                          validator: (value) {
                            return value == null
                                ? 'Please select a brand'
                                : null;
                          },
                          onChanged: (selectedBrand) {
                            setState(() => _brand = selectedBrand!);
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownSearch<CarBodyType>(
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              hintText: 'Body Type',
                              label: Text('Body Type'),
                            ),
                          ),
                          itemAsString: (bodyType) => bodyType.name,
                          filterFn: (bodyType, filter) {
                            var bodyTypeName = bodyType.name.toLowerCase();
                            var filterValue = filter.toLowerCase();
                            return bodyTypeName.contains(filterValue);
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
                                tileColor:
                                    Theme.of(context).colorScheme.surface,
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
                          validator: (value) {
                            return value == null
                                ? 'Please select a body type'
                                : null;
                          },
                          onChanged: (selectedBodyType) {
                            setState(() => _bodyType = selectedBodyType!);
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Year',
                            label: Text('Year'),
                          ),
                          validator: (value) {
                            if (value!.length != 4) {
                              return 'Please enter a valid year';
                            }
                            return value.isEmpty ? 'Please enter a year' : null;
                          },
                          onChanged: (newValue) {
                            setState(() => _year = newValue);
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Min Kilometer',
                            label: Text('Min Kilometer'),
                          ),
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Please enter a min kilometer'
                                : null;
                          },
                          onChanged: (newValue) {
                            setState(() => _kmMin = num.tryParse(newValue)!);
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Max Kilometer',
                            label: Text('Max Kilometer'),
                          ),
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Please enter a max kilometer'
                                : null;
                          },
                          onChanged: (newValue) {
                            setState(() => _kmMax = num.tryParse(newValue)!);
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownSearch<CarFuel>(
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              hintText: 'Fuel',
                              label: Text('Fuel'),
                            ),
                          ),
                          itemAsString: (fuel) => fuel.name,
                          filterFn: (fuel, filter) {
                            var fuelName = fuel.name.toLowerCase();
                            var filterValue = filter.toLowerCase();
                            return fuelName.contains(filterValue);
                          },
                          compareFn: (a, b) => a == b,
                          popupProps: PopupProps.modalBottomSheet(
                            modalBottomSheetProps: ModalBottomSheetProps(
                              backgroundColor:
                                  Theme.of(context).colorScheme.surface,
                            ),
                            searchFieldProps: const TextFieldProps(
                              decoration: InputDecoration(
                                hintText: 'Search Fuel',
                                prefixIcon: Icon(Icons.search),
                              ),
                            ),
                            showSelectedItems: true,
                            showSearchBox: true,
                            title: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                'Select Fuel',
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
                                (context, CarFuel? fuel, bool? isSelected) {
                              return ListTile(
                                tileColor:
                                    Theme.of(context).colorScheme.surface,
                                selected: isSelected!,
                                title: Text(fuel!.name),
                                subtitle: Text(fuel.name),
                                leading: const Icon(Icons.branding_watermark),
                              );
                            },
                          ),
                          items: [
                            for (final fuel in carFuels.asData!.value) fuel
                          ],
                          validator: (value) {
                            return value == null
                                ? 'Please select a fuel'
                                : null;
                          },
                          onChanged: (selectedFuel) {
                            setState(() => _fuel = selectedFuel!);
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Price',
                            label: Text('Price'),
                          ),
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Please enter a price'
                                : null;
                          },
                          onChanged: (newValue) {
                            setState(() => _price = num.parse(newValue));
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          maxLines: 4,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            hintText: 'Description',
                            label: Text('Description'),
                          ),
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Please enter a description'
                                : null;
                          },
                          onChanged: (newValue) {
                            setState(() => _description = newValue);
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<CarCondition>(
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
                          validator: (value) {
                            return value == null
                                ? 'Please select a condition'
                                : null;
                          },
                          onChanged: (newValue) {
                            setState(() => _condition = newValue!);
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<CarTransmission>(
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
                          validator: (value) {
                            return value == null
                                ? 'Please select a transmission'
                                : null;
                          },
                          onChanged: (newValue) {
                            setState(() => _transmission = newValue!);
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<CarStatus>(
                          decoration: const InputDecoration(
                            hintText: 'Status',
                            label: Text('Status'),
                          ),
                          items: [
                            for (final condition in CarStatus.values)
                              DropdownMenuItem(
                                value: condition,
                                child: Text(condition.name),
                              )
                          ],
                          validator: (value) {
                            return value == null
                                ? 'Please select a status'
                                : null;
                          },
                          onChanged: (newValue) {
                            setState(() => _status = newValue!);
                          },
                        ),
                        const SizedBox(height: 16),
                        Flex(
                          direction: Axis.horizontal,
                          children: [
                            const Text('Image'),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () => selectImage(setState),
                              child: const Text('Select Image'),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        _selectedImage,
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: add,
                          child: const Text('Submit'),
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

    return IconButton(onPressed: showAddDialog, icon: const Icon(Icons.add));
  }
}
