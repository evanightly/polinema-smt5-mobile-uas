import 'dart:developer';

import 'package:client/models/item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'items.g.dart';

@Riverpod(keepAlive: true)
class Items extends _$Items {
  @override
  List<Item> build() {
    return [
      Item(
        title: 'Mustang GT',
        price: 120.000,
        image: 'assets/images/car1_MustangGT.jpg',
        qty: 12,
      ),
      Item(
        title: 'Porsche',
        price: 180.000,
        image: 'assets/images/car2_Porsche.jpg',
        qty: 7,
      ),
      Item(
        title: 'Lamborghini',
        price: 240.000,
        image: 'assets/images/car3_Lamborghini.jpg',
        qty: 2,
      ),
      Item(
        title: 'BMW M4',
        price: 100.000,
        image: 'assets/images/car4_M4.jpg',
        qty: 31,
      ),
      Item(
        title: 'F-Type Jaguar',
        price: 190.000,
        image: 'assets/images/car5_FTypeJaguar.jpg',
        qty: 5,
      ),
    ];
  }

  void addItem(Item item) {
    log('Item Added');
    state = [...state, item];
  }

  void removeItem(String title) {
    log('Item Removed');
    state = [
      for (final item in state)
        if (item.title != title) item,
    ];
  }
}
