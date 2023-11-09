import 'package:client/models/car_fuel.dart';
import 'package:client/providers/diohttp.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'car_fuels.g.dart';

@Riverpod(keepAlive: true)
class CarFuels extends _$CarFuels {
  @override
  Future<List<CarFuel>> build() async {
    return await get();
  }

  Future<List<CarFuel>> get() async {
    final dio = ref.read(dioHttpProvider);
    final response = await dio.get('/car-fuels');
    final data = response.data as List<dynamic>;
    final carFuels = data.map(
      (carFuel) {
        return CarFuel.fromJson(carFuel);
      },
    ).toList();

    return carFuels;
  }
}
