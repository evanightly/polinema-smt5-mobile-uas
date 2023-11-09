import 'dart:io';

import 'package:client/models/car.dart';
import 'package:client/models/car_body_type.dart';
import 'package:client/models/car_brand.dart';
import 'package:client/models/car_fuel.dart';
import 'package:client/providers/admin_dashboard_actions.dart';
import 'package:client/providers/car_body_types.dart';
import 'package:client/providers/car_brands.dart';
import 'package:client/providers/car_fuels.dart';
import 'package:client/providers/cars.dart';
import 'package:client/providers/diohttp.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

const double _circularRadius = 6;

class AdminInventoryScreen extends ConsumerWidget {
  const AdminInventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final NumberFormat numberFormat = NumberFormat.decimalPattern();
    final cars = ref.watch(carsProvider);

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final dashboardActions =
            ref.read(adminDashboardActionsProvider.notifier);

        final isLoadingCarData = cars.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

        dashboardActions.setActions(
          isLoadingCarData
              ? [
                  const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ]
              : [const _AddInventory()],
        );
      },
    );

    void showDetails(Car car) {
      showDialog(
        context: context,
        builder: (ctx) {
          return Scaffold(
            appBar: AppBar(
              title: Text(car.name),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 150,
                    child: CircleAvatar(
                      backgroundImage: car.imagePath!.isNotEmpty
                          ? AssetImage(car.imagePath!)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(children: [const Text('Name : '), Text(car.name)]),
                  const SizedBox(height: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Description : '),
                      car.description != null
                          ? Text(car.description!)
                          : const SizedBox.shrink()
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text('Price: ${numberFormat.format(car.price)}'),
                  const SizedBox(height: 14),
                  Text('Brand: ${car.brandName}'),
                  const SizedBox(height: 14),
                  Text('Body Type: ${car.bodyTypeName}'),
                  const SizedBox(height: 14),
                  Text('Production Year: ${car.year}'),
                  const SizedBox(height: 14),
                  Text(
                    'Kilometer: ${numberFormat.format(car.km_min)} - ${numberFormat.format(car.km_max)}km',
                  ),
                  const SizedBox(height: 14),
                  Text('Fuel: ${car.fuelName}'),
                  const SizedBox(height: 14),
                  Text('Condition: ${car.condition.name}'),
                  const SizedBox(height: 14),
                  Text('Transmission: ${car.transmission.name}'),
                  const SizedBox(height: 14),
                  Text('Status: ${car.status.name}'),
                ],
              ),
            ),
          );
        },
      );
    }

    void edit(Car car) {
      // Controller must be disposed!
      TextEditingController titleController = TextEditingController();
      TextEditingController descriptionController = TextEditingController();
      TextEditingController priceController = TextEditingController();
      TextEditingController qtyController = TextEditingController();
      // TextEditingController soldAtController = TextEditingController();

      void showDatePicker() {}
      void selectImage() {}
      void update() {}

      titleController.text = car.name;
      descriptionController.text = car.description ?? '';
      priceController.text = car.price.toString();
      // qtyController.text = item.qty.toString();
      // soldAtController.text = item.soldAt ?? '0';

      showDialog(
        context: context,
        builder: (ctx) {
          return Scaffold(
            appBar: AppBar(title: Text('Update ${car.name}')),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                child: ListView(
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(hintText: 'Title'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: descriptionController,
                      keyboardType: TextInputType.text,
                      decoration:
                          const InputDecoration(hintText: 'Description'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: 'Price'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: qtyController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: 'Qty'),
                    ),
                    const SizedBox(height: 16),
                    Flex(
                      direction: Axis.horizontal,
                      children: [
                        const Text('Image'),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: selectImage,
                          child: const Text('Select Image'),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Flex(
                      direction: Axis.horizontal,
                      children: [
                        const Text('Sold At'),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: showDatePicker,
                          child: const Text('Pick a Date'),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: update,
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

    Future<bool> delete(BuildContext context) async {
      return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          void destroy() => Navigator.pop(context, true);

          void cancel() => Navigator.pop(context, false);

          return AlertDialog(
            title: const Text('Delete Data'),
            content: const Text('Are You Sure?'),
            actions: [
              TextButton(onPressed: destroy, child: const Text('Yes')),
              TextButton(onPressed: cancel, child: const Text('Cancel')),
            ],
          );
        },
      );
    }

    return cars.when(data: (data) {
      return ListView.builder(
        itemCount: data.length,
        itemBuilder: (ctx, index) {
          final car = data[index];

          return Dismissible(
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                edit(car);
                return false;
              } else {
                final isConfirmed = await delete(context);
                if (isConfirmed) {
                  final isDeleted =
                      await ref.read(carsProvider.notifier).delete(car.id!);
                  if (isDeleted) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${car.name} deleted'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to delete ${car.name}'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                }
                return false;
              }
            },
            background: Container(
              padding: const EdgeInsets.only(left: 20),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.red.withOpacity(.2),
                    Colors.red,
                  ],
                ),
              ),
              child: const Icon(Icons.delete),
            ),
            secondaryBackground: Container(
              padding: const EdgeInsets.only(right: 20),
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue,
                    Colors.blue.withOpacity(.2),
                  ],
                ),
              ),
              child: const Icon(Icons.edit),
            ),
            key: Key(car.name),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () => showDetails(car),
                child: Card(
                  margin: const EdgeInsets.all(0),
                  surfaceTintColor: Theme.of(context)
                      .colorScheme
                      .inverseSurface
                      .withOpacity(.08),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(_circularRadius),
                      right: Radius.circular(_circularRadius),
                    ),
                  ),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      _ItemImage(car.imagePath!),
                      const SizedBox(
                        width: 16,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(car.name),
                          const SizedBox(height: 4),
                          Text('\$ ${numberFormat.format(car.price)}'),
                        ],
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 80,
                        width: 40,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .inverseSurface
                                .withOpacity(.05),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(_circularRadius),
                              bottomRight: Radius.circular(_circularRadius),
                            ),
                          ),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "12",
                            style: Theme.of(context).textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }, error: (_, error) {
      return Center(child: Text(error.toString()));
    }, loading: () {
      return const Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Please Wait...'),
          ],
        ),
      );
    });
  }
}

class _AddInventory extends ConsumerStatefulWidget {
  const _AddInventory();

  @override
  ConsumerState<_AddInventory> createState() => _AddInventoryState();
}

class _AddInventoryState extends ConsumerState<_AddInventory> {
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
                            print(newValue);
                            print(num.tryParse(newValue));
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

class _ItemImage extends StatelessWidget {
  const _ItemImage(this.imageUrl);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    Widget image = const SizedBox.shrink();

    if (imageUrl.isNotEmpty) {
      image = ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(_circularRadius),
          bottomLeft: Radius.circular(_circularRadius),
        ),
        child: Image.network(
          imageUrl.startsWith('http')
              ? imageUrl
              : 'http://$ipv4/polinema-smt5-mobile-uas/server/public/storage/images/cars/$imageUrl',
          fit: BoxFit.cover,
          width: 120,
          height: 80,
        ),
      );
    }

    return image;
  }
}
