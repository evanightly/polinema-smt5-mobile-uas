import 'package:client/components/loading_indicator.dart';
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
    final carBodyTypes =
        data.map((carBodyType) => CarBodyType.fromJson(carBodyType)).toList();
    return carBodyTypes;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => get());
  }

  Future<void> create(CarBodyType carBodyType) async {
    final dio = ref.read(dioHttpProvider.notifier);
    try {
      LoadingIndicator.show();
      await dio.http.post('/car-body-types', data: carBodyType.toJson());
      refresh();
      LoadingIndicator.dismiss();
    } catch (_) {
      // LoadingIndicator.showError('Failed to add car body type');
    }
  }

  Future<void> put(CarBodyType carBodyType) async {
    final dio = ref.read(dioHttpProvider.notifier);
    try {
      LoadingIndicator.show();
      await dio.http.post('/car-body-types/${carBodyType.id}?_method=PUT',
          data: carBodyType.toJson());
      refresh();
      LoadingIndicator.dismiss();
    } catch (_) {
      // LoadingIndicator.showError('Failed to update car body type');
    }
  }

  Future<void> delete(CarBodyType carBodyType) async {
    final dio = ref.read(dioHttpProvider.notifier);
    try {
      LoadingIndicator.show();
      await dio.http.delete('/car-body-types/${carBodyType.id}');
      refresh();
      LoadingIndicator.dismiss();
    } catch (_) {
      // LoadingIndicator.showError('Failed to delete car body type');
    }
  }
}
