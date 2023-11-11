import 'package:client/models/car_body_type.dart';
import 'package:client/providers/diohttp.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'car_body_types.g.dart';

@Riverpod(keepAlive: true)
class CarBodyTypes extends _$CarBodyTypes {

  @override
  Future<List<CarBodyType>> build() async {
    return await get();
  }

  Future<List<CarBodyType>> get() async {
    final dio = ref.read(dioHttpProvider.notifier);
    final response = await dio.adminHttp.get('/car-body-types');
    final data = response.data as List<dynamic>;
    final carTypes = data.map(
      (carType) {
        return CarBodyType.fromJson(carType);
      },
    ).toList();

    return carTypes;
  }
}
