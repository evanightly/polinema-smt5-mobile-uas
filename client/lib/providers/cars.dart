import 'dart:developer';

import 'package:client/models/car.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cars.g.dart';

@Riverpod(keepAlive: true)
class Cars extends _$Cars {
  @override
  List<Car> build() {
    return [
      Car(
        title: 'Mustang GT',
        price: 120.000,
        image: 'assets/images/car1_MustangGT.jpg',
        qty: 12,
      ),
      Car(
        title: 'Porsche',
        price: 180.000,
        image: 'assets/images/car2_Porsche.jpg',
        qty: 7,
      ),
      Car(
        title: 'Lamborghini',
        price: 240.000,
        image: 'assets/images/car3_Lamborghini.jpg',
        qty: 2,
      ),
      Car(
        title: 'BMW M4',
        price: 100.000,
        image: 'assets/images/car4_M4.jpg',
        qty: 31,
      ),
      Car(
        title: 'F-Type Jaguar',
        price: 190.000,
        image: 'assets/images/car5_FTypeJaguar.jpg',
        qty: 5,
      ),
    ];
  }

  void addItem(Car item) {
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
