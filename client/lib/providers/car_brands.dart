import 'package:client/models/car_brand.dart';
import 'package:client/providers/diohttp.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'car_brands.g.dart';

@Riverpod(keepAlive: true)
class CarBrands extends _$CarBrands {
  @override
  Future<List<CarBrand>> build() async {
    return await get();
  }

  Future<List<CarBrand>> get() async {
    final dio = ref.read(dioHttpProvider.notifier);
    final response = await dio.http.get('/car-brands');
    final data = response.data as List<dynamic>;
    final carBrands = data.map(
      (carBrand) {
        return CarBrand.fromJson(carBrand);
      },
    ).toList();
    return carBrands;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => get());
  }

  Future<void> create(CarBrand carBrand) async {
    final dio = ref.read(dioHttpProvider.notifier);
    await dio.http.post('/car-brands', data: carBrand.toJson());
    refresh();
  }

  Future<void> put(CarBrand carBrand) async {
    final dio = ref.read(dioHttpProvider.notifier);
    await dio.http.post('/car-brands/${carBrand.id}?_method=PUT', data: carBrand.toJson());
    refresh();
  }

  Future<void> delete(CarBrand carBrand) async {
    final dio = ref.read(dioHttpProvider.notifier);
    await dio.http.delete('/car-brands/${carBrand.id}');
    refresh();
  }
}
