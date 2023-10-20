import 'package:client/controllers/dashboard_screen_controller.dart';
import 'package:client/controllers/item_controller.dart';
import 'package:client/models/item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const double _circularRadius = 6;

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});
  static ItemController itemController = Get.find();
  static DashboardScreenController dashboardScreenController = Get.find();

  void _showDetails(Item item) {
    //     String? id;
    // String title;
    // String? description;
    // num price;
    // int qty;
    // String? image;
    // String? soldAt;
    Get.dialog(
      Scaffold(
        appBar: AppBar(
          title: Text(item.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              SizedBox(
              width: double.infinity,
              height: 150,
              child: CircleAvatar(backgroundImage:
                    item.image!.isNotEmpty ? AssetImage(item.image!) : null,),
            ),
              const SizedBox(height: 14),
              Row(children: [const Text('Title : '), Text(item.title)]),
              const SizedBox(height: 14),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Description : '),
                item.description != null
                    ? Text(item.description!)
                    : const SizedBox.shrink()
              ]),
              const SizedBox(height: 14),
              Row(children: [const Text('Price: '), Text(item.price.toString())]),
              const SizedBox(height: 14),
              Row(children: [const Text('QTY: '), Text(item.qty.toString())]),
              const SizedBox(height: 14),
              Row(children: [const Text('Sold At: '), Text(item.title)]),
            ],
          ),
        ),
      ),
    );
  }

  void update() {}
  void delete() {}

  @override
  Widget build(BuildContext context) {
    dashboardScreenController.scaffoldActions.value = [const _AddInventory()];
    Widget content = const Center(child: Text('No Items Yet'));
    if (itemController.items.isNotEmpty) {
      content = Obx(
        () => ListView.builder(
            itemCount: itemController.items.length,
            itemBuilder: (ctx, index) {
              final item = itemController.items[index];
              return Dismissible(
                background: Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.red.withOpacity(.2),
                        Colors.red,
                      ],
                    ),
                  ),
                  child: IconButton(
                    onPressed: delete,
                    icon: const Icon(Icons.delete),
                  ),
                ),
                secondaryBackground: Container(
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue,
                        Colors.blue.withOpacity(.2),
                      ],
                    ),
                  ),
                  child: IconButton(
                    onPressed: update,
                    icon: const Icon(Icons.edit),
                  ),
                ),
                key: Key(item.title),
                child: InkWell(
                  onTap: () => _showDetails(item),
                  child: Card(
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
                        _ItemImage(item.image!),
                        const SizedBox(
                          width: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.title),
                            const SizedBox(height: 4),
                            Text('\$ ${item.price}'),
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
                              "${item.qty}",
                              style: Theme.of(context).textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
      );
    }

    return content;
  }
}

class _AddInventory extends StatelessWidget {
  const _AddInventory({super.key});

  static TextEditingController titleController = TextEditingController();
  static TextEditingController descriptionController = TextEditingController();
  static TextEditingController priceController = TextEditingController();
  static TextEditingController qtyController = TextEditingController();
  static TextEditingController imageController = TextEditingController();
  static TextEditingController soldAtController = TextEditingController();

  void _showDatePicker() {}
  void _selectImage() {}
  void _add() {}
  void _showDialog() {
    Get.dialog(
      Scaffold(
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
                  decoration: const InputDecoration(hintText: 'Description'),
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
                      onPressed: _selectImage,
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
                      onPressed: _showDatePicker,
                      child: const Text('Pick a Date'),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _add,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: _showDialog, icon: const Icon(Icons.add));
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
        child: Image.asset(
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
