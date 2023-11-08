import 'package:client/models/car.dart';
import 'package:client/providers/diohttp.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cars.g.dart';

@Riverpod(keepAlive: true)
class Cars extends _$Cars {
  @override
  Future<List<Car>> build() async {
    return await get();
  }

  // get all cars
  Future<List<Car>> get() async {
    final dio = ref.read(dioHttpProvider);
    final response = await dio.get('/cars');
    final data = response.data as List<dynamic>;
    final cars = data.map(
      (car) {
        return Car.fromJson(car);
      },
    ).toList();

    return cars;
  }

  void refresh() async {
    state = const AsyncValue.loading();
    state = AsyncValue.data(await get());
  }

  void addItem(Car item) {
    // print('Item Added');
    // state = [...state, item];
  }

  Future<bool> delete(String id) async {
    final dio = ref.read(dioHttpProvider);
    final response = await dio.delete('/cars/$id');
    if (response.statusCode == 200) {
      state = AsyncValue.data(state.value!..removeWhere((car) => car.id == id));
      return true;
    }
    return false;
  }
} 

// Car(
//         title: 'Mustang GT',
//         price: 120.000,
//         image: 'assets/images/car1_MustangGT.jpg',
//         qty: 12,
//       ),
//       Car(
//         title: 'Porsche',
//         price: 180.000,
//         image: 'assets/images/car2_Porsche.jpg',
//         qty: 7,
//       ),
//       Car(
//         title: 'Lamborghini',
//         price: 240.000,
//         image: 'assets/images/car3_Lamborghini.jpg',
//         qty: 2,
//       ),
//       Car(
//         title: 'BMW M4',
//         price: 100.000,
//         image: 'assets/images/car4_M4.jpg',
//         qty: 31,
//       ),
//       Car(
//         title: 'F-Type Jaguar',
//         price: 190.000,
//         image: 'assets/images/car5_FTypeJaguar.jpg',
//         qty: 5,
//       ),
