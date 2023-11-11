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
}
