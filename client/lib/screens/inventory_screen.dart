import 'package:client/controllers/dashboard_screen_controller.dart';
import 'package:client/controllers/item_controller.dart';
import 'package:client/models/item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const double _circularRadius = 6;

class InventoryScreen extends GetView<ItemController> {
  const InventoryScreen({super.key});

  void _showDetails(Item item) {
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
                child: CircleAvatar(
                  backgroundImage:
                      item.image!.isNotEmpty ? AssetImage(item.image!) : null,
                ),
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
              Row(children: [
                const Text('Price: '),
                Text(item.price.toString())
              ]),
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

  void edit(Item item) {
    // Controller must be disposed!
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController qtyController = TextEditingController();
    TextEditingController imageController = TextEditingController();
    TextEditingController soldAtController = TextEditingController();

    void showDatePicker() {}
    void selectImage() {}
    void update() {}

    titleController.text = item.title;
    descriptionController.text = item.description ?? '';
    priceController.text = item.price.toString();
    qtyController.text = item.qty.toString();
    imageController.text = item.image ?? '';
    soldAtController.text = item.soldAt ?? '0';

    Get.dialog(
      Scaffold(
        appBar: AppBar(title: Text('Update ${item.title}')),
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
      ),
    );
  }

  Future<bool> delete(BuildContext context) async {
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        void destroy() {
          // Delete data from DB scripts here
          return Get.back(result: true);
        }

        void cancel() => Get.back(result: false);

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

  @override
  Widget build(BuildContext context) {
    final DashboardScreenController dashboardScreenController = Get.find();

    dashboardScreenController.scaffoldActions = [const _AddInventory()];

    Widget content = const Center(child: Text('No Items Yet'));
    if (controller.items.isNotEmpty) {
      content = Obx(
        () => ListView.builder(
            itemCount: controller.items.length,
            itemBuilder: (ctx, index) {
              final item = controller.items[index];
              return Dismissible(
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    edit(item);
                    return false;
                  } else {
                    return await delete(context);
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
                key: Key(item.title),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () => _showDetails(item),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
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
                ),
              );
            }),
      );
    }

    return content;
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
