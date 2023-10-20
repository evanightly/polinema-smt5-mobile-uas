import 'package:client/controllers/item_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const double _circularRadius = 6;

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});
  static ItemController itemController = Get.find();

  void update() {}
  void delete() {}

  @override
  Widget build(BuildContext context) {
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
              );
            }),
      );
    }

    return content;
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
