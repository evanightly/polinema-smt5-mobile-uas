import 'package:client/components/loading_indicator.dart';
import 'package:client/models/car.dart';
import 'package:client/models/car_filter.dart';
import 'package:client/providers/diohttp.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cars.g.dart';

dynamic generateCarMetadata(Car car) {
  return {
    'name': car.name,
    'brand_id': car.brand.id,
    'body_type_id': car.bodyType.id,
    'year': car.year,
    'mileage': car.mileage,
    'fuel_id': car.fuel.id,
    'price': car.price,
    'description': car.description,
    'condition': car.condition.name,
    'transmission': car.transmission.name,
    'stock': car.stock,
  };
}

@Riverpod(keepAlive: true)
class Cars extends _$Cars {
  @override
  Future<List<Car>> build() async {
    return await get();
  }

  Future<List<Car>> get() async {
    final dio = ref.read(dioHttpProvider.notifier);

    try {
      final response = await dio.http.get('/cars');
      final data = response.data['data'] as List<dynamic>;
      final cars = data.map((car) => Car.fromJson(car)).toList();

      return cars;
    } catch (e) {
      return [];
    }
  }

  Future<void> getPagination(int page) async {
    final dio = ref.read(dioHttpProvider.notifier);

    try {
      final response = await dio.http.get('/cars?page=$page');
      final data = response.data['data'] as List<dynamic>;
      final cars = data.map((car) => Car.fromJson(car)).toList();

      // after getting data, push it to the state
      state = AsyncData([...state.asData!.value, ...cars]);

      // state = AsyncData(cars);
    } catch (_) {
      state = const AsyncValue.data([]);
    }
  }

  refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => get());
  }

  void add(Car car) async {
    final dio = ref.read(dioHttpProvider.notifier);

    try {
      LoadingIndicator.show();

      final formData = FormData.fromMap({
        ...generateCarMetadata(car),
        'image': await MultipartFile.fromFile(car.uploadImage!.path),
      });

      await dio.http.post('/cars', data: formData);

      refresh();

      LoadingIndicator.dismiss();
    } catch (e) {
      // LoadingIndicator.showError('Failed to add car');
    }
  }

  void put(Car car) async {
    final dio = ref.read(dioHttpProvider.notifier);

    try {
      LoadingIndicator.show();

      FormData formData = FormData.fromMap(generateCarMetadata(car));

      // if image is not null, then add it to the form data
      if (car.uploadImage != null) {
        formData = FormData.fromMap({
          ...generateCarMetadata(car),
          'image': await MultipartFile.fromFile(car.uploadImage!.path),
        });
      }

      await dio.http.post('/cars/${car.id}?_method=PUT', data: formData);

      refresh();

      LoadingIndicator.dismiss();
    } catch (_) {
      // LoadingIndicator.showError('Failed to update car');
    }
  }

  void delete(String id) async {
    try {
      LoadingIndicator.show();
      final dio = ref.read(dioHttpProvider.notifier);

      await dio.http.delete('/cars/$id');

      refresh();

      LoadingIndicator.dismiss();
    } catch (_) {
      // LoadingIndicator.showError('Failed to delete car');
    }
  }

  void filter(CarFilter carFilter) async {
    final dio = ref.read(dioHttpProvider.notifier);

    try {
      LoadingIndicator.show();
      final response =
          await dio.http.post('/cars/search', data: carFilter.toJson());

      state = const AsyncValue.loading();

      final data = response.data as List<dynamic>;
      final cars = data.map((car) => Car.fromJson(car)).toList();

      state = AsyncData(cars);

      LoadingIndicator.dismiss();
    } catch (_) {
      // LoadingIndicator.showError('Failed to search car');
    }
  }
}
