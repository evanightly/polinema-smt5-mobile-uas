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
    final response = await dio.http.get('/car-body-types');
    final data = response.data as List<dynamic>;
    final carBodyTypes = data.map(
      (carBodyType) {
        return CarBodyType.fromJson(carBodyType);
      },
    ).toList();
    return carBodyTypes;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => get());
  }

  Future<void> create(CarBodyType carBodyType) async {
    final dio = ref.read(dioHttpProvider.notifier);
    await dio.http.post('/car-body-types', data: carBodyType.toJson());
    refresh();
  }

  Future<void> put(CarBodyType carBodyType) async {
    final dio = ref.read(dioHttpProvider.notifier);
    await dio.http
        .post('/car-body-types/${carBodyType.id}?_method=PUT', data: carBodyType.toJson());
    refresh();
  }

  Future<void> delete(CarBodyType carBodyType) async {
    final dio = ref.read(dioHttpProvider.notifier);
    await dio.http.delete('/car-body-types/${carBodyType.id}');
    refresh();
  }
}
