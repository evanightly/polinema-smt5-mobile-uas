import 'package:client/models/car.dart';
import 'package:client/providers/admin_dashboard_actions.dart';
import 'package:client/providers/cars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        dashboardActions.setActions([const _AddInventory()]);
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
                      backgroundImage:
                          car.image.isNotEmpty ? AssetImage(car.image) : null,
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
                  Text('Brand: ${car.brand}'),
                  const SizedBox(height: 14),
                  Text('Body Type: ${car.body_type}'),
                  const SizedBox(height: 14),
                  Text('Production Year: ${car.year}'),
                  const SizedBox(height: 14),
                  Text(
                    'Kilometer: ${numberFormat.format(car.km_min)} - ${numberFormat.format(car.km_max)}km',
                  ),
                  const SizedBox(height: 14),
                  Text('Fuel: ${car.fuel}'),
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
      TextEditingController imageController = TextEditingController();
      // TextEditingController soldAtController = TextEditingController();

      void showDatePicker() {}
      void selectImage() {}
      void update() {}

      titleController.text = car.name;
      descriptionController.text = car.description ?? '';
      priceController.text = car.price.toString();
      // qtyController.text = item.qty.toString();
      imageController.text = car.image;
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
                      _ItemImage(car.image),
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

class _AddInventory extends StatelessWidget {
  const _AddInventory();

  static TextEditingController titleController = TextEditingController();
  static TextEditingController descriptionController = TextEditingController();
  static TextEditingController priceController = TextEditingController();
  static TextEditingController qtyController = TextEditingController();
  // static TextEditingController imageController = TextEditingController();
  // static TextEditingController soldAtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void showDatePicker() {}
    void selectImage() {}
    void add() {}
    void showAddDialog() {
      showDialog(
        context: context,
        builder: (ctx) {
          return Scaffold(
            appBar: AppBar(title: const Text('Add New Item')),
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
          imageUrl,
          fit: BoxFit.cover,
          width: 120,
          height: 80,
        ),
      );
    }

    return image;
  }
}
