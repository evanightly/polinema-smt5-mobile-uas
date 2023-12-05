import 'package:client/components/loading_indicator.dart';
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
    final dio = ref.read(dioHttpProvider.notifier);
    final response = await dio.http.get('/car-fuels');
    final data = response.data as List<dynamic>;
    final carFuels = data.map((carFuel) => CarFuel.fromJson(carFuel)).toList();
    return carFuels;
  }

  refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => get());
  }

  Future<void> create(CarFuel carFuel) async {
    final dio = ref.read(dioHttpProvider.notifier);

    try {
      LoadingIndicator.show();
      await dio.http.post('/car-fuels', data: carFuel.toJson());
      refresh();
      LoadingIndicator.dismiss();
    } catch (_) {
      // LoadingIndicator.showError('Failed to add car fuel');
    }
  }

  Future<void> put(CarFuel carFuel) async {
    final dio = ref.read(dioHttpProvider.notifier);
    try {
      LoadingIndicator.show();
      await dio.http
          .post('/car-fuels/${carFuel.id}?_method=PUT', data: carFuel.toJson());
      refresh();
      LoadingIndicator.dismiss();
    } catch (_) {
      // LoadingIndicator.showError('Failed to update car fuel');
    }
  }

  Future<void> delete(CarFuel carFuel) async {
    final dio = ref.read(dioHttpProvider.notifier);

    try {
      LoadingIndicator.show();
      await dio.http.delete('/car-fuels/${carFuel.id}');
      refresh();
      LoadingIndicator.dismiss();
    } catch (_) {
      // LoadingIndicator.showError('Failed to delete car fuel');
    }
  }
}
