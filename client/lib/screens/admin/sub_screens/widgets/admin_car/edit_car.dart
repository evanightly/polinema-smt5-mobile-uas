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
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

void editCar(BuildContext context, Car car) {
  showDialog(
    context: context,
    builder: (ctx) {
      return UpdateCar(car: car);
    },
  );
}

class UpdateCar extends ConsumerStatefulWidget {
  const UpdateCar({required this.car, super.key});
  final Car car;

  @override
  ConsumerState<UpdateCar> createState() => _UpdateCarState();
}

class _UpdateCarState extends ConsumerState<UpdateCar> {
  final _formKey = GlobalKey<FormState>();
  Widget _selectedImage = const SizedBox.shrink();
  late String _name = widget.car.name;
  late CarBrand _brand = widget.car.brand;
  late CarBodyType _bodyType = widget.car.bodyType;
  late String _year = widget.car.year;
  late double _mileage = widget.car.mileage;
  late CarFuel _fuel = widget.car.fuel;
  late num _price = widget.car.price;
  File? _file;
  late String? _description = widget.car.description;
  late CarCondition _condition = widget.car.condition;
  late CarTransmission _transmission = widget.car.transmission;

  @override
  void initState() {
    super.initState();
    if (widget.car.imageUrl != null) {
      _selectedImage = Image(
        image: widget.car.imageProviderWidget,
        height: 240,
        fit: BoxFit.cover,
      );
    }
  }

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

    void edit() {
      final isValid = _formKey.currentState!.validate();
      if (!isValid) {
        return;
      }

      _formKey.currentState!.save();

      final newCar = Car(
        id: widget.car.id,
        name: _name,
        brand: _brand,
        bodyType: _bodyType,
        year: _year,
        mileage: _mileage,
        fuel: _fuel,
        price: _price,
        uploadImage: _file,
        description: _description,
        condition: _condition,
        transmission: _transmission,
        stock: widget.car.stock,
      );

      ref.read(carsProvider.notifier).put(newCar);

      Navigator.pop(context);

      ElegantNotification.success(
        title: const Text("Update"),
        description: Text("${newCar.name} has been updated!"),
        background: Theme.of(context).colorScheme.background,
      ).show(context);
    }

    return StatefulBuilder(
      builder: (context, StateSetter setState) {
        return Scaffold(
          appBar: AppBar(title: Text('Update $_name')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _name,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: 'Name',
                      label: Text('Name'),
                    ),
                    validator: (value) {
                      return value!.isEmpty ? 'Please enter a name' : null;
                    },
                    onChanged: (newValue) {
                      setState(() => _name = newValue);
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownSearch<CarBrand>(
                    selectedItem: _brand,
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
                        backgroundColor: Theme.of(context).colorScheme.surface,
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
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
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
                      if (carBrands.value != null &&
                          carBrands.value!.isNotEmpty)
                        for (final brand in carBrands.value!) brand
                    ],
                    validator: (value) {
                      return value == null ? 'Please select a brand' : null;
                    },
                    onChanged: (selectedBrand) {
                      setState(() => _brand = selectedBrand!);
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownSearch<CarBodyType>(
                    selectedItem: _bodyType,
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
                        backgroundColor: Theme.of(context).colorScheme.surface,
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
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      itemBuilder:
                          (context, CarBodyType? bodyType, bool? isSelected) {
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
                      if (carBodyTypes.value != null &&
                          carBodyTypes.value!.isNotEmpty)
                        for (final bodyType in carBodyTypes.value!) bodyType
                    ],
                    validator: (value) {
                      return value == null ? 'Please select a body type' : null;
                    },
                    onChanged: (selectedBodyType) {
                      setState(() => _bodyType = selectedBodyType!);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _year,
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
                    initialValue: _mileage.toString(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Mileage',
                      label: Text('Mileage'),
                    ),
                    validator: (value) {
                      return value!.isEmpty ? 'Please enter a mileage' : null;
                    },
                    onChanged: (newValue) {
                      setState(() => _mileage = double.tryParse(newValue)!);
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownSearch<CarFuel>(
                    selectedItem: _fuel,
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
                        backgroundColor: Theme.of(context).colorScheme.surface,
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
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      itemBuilder: (context, CarFuel? fuel, bool? isSelected) {
                        return ListTile(
                          tileColor: Theme.of(context).colorScheme.surface,
                          selected: isSelected!,
                          title: Text(fuel!.name),
                          subtitle: Text(fuel.name),
                          leading: const Icon(Icons.branding_watermark),
                        );
                      },
                    ),
                    items: [
                      if (carFuels.value != null && carFuels.value!.isNotEmpty)
                        for (final fuel in carFuels.value!) fuel
                    ],
                    validator: (value) {
                      return value == null ? 'Please select a fuel' : null;
                    },
                    onChanged: (selectedFuel) {
                      setState(() => _fuel = selectedFuel!);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _price.toString(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Price',
                      label: Text('Price'),
                    ),
                    validator: (value) {
                      return value!.isEmpty ? 'Please enter a price' : null;
                    },
                    onChanged: (newValue) {
                      setState(() => _price = num.parse(newValue));
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: widget.car.stock.toString(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Stock',
                      label: Text('Stock'),
                    ),
                    validator: (value) {
                      return value!.isEmpty ? 'Please enter a stock' : null;
                    },
                    onChanged: (newValue) {
                      setState(() => widget.car.stock = int.parse(newValue));
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _description,
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
                    value: _condition,
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
                      return value == null ? 'Please select a condition' : null;
                    },
                    onChanged: (newValue) {
                      setState(() => _condition = newValue!);
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<CarTransmission>(
                    value: _transmission,
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
                    onPressed: edit,
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
