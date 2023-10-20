import 'package:client/models/item.dart';
import 'package:get/get.dart';

class ItemController extends GetxController {
  final RxList<Item> _items = <Item>[].obs;

  RxList<Item> get items => _items;
  set items(RxList<Item> items) => _items.addAll(items);
}
