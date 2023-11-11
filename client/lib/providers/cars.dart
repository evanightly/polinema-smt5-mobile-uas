import 'package:client/models/car.dart';
import 'package:client/providers/diohttp.dart';
import 'package:dio/dio.dart';
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
    final dio = ref.read(dioHttpProvider.notifier);
    final response = await dio.adminHttp.get('/cars');
    final data = response.data as List<dynamic>;
    final cars = data.map(
      (car) {
        return Car.fromJson(car);
      },
    ).toList();

    return cars;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => get());
  }

  void add(Car car) async {
    try {
      final dio = ref.read(dioHttpProvider.notifier);
      final formData = FormData.fromMap({
        'name': car.name,
        'brand_id': car.brand.id,
        'body_type_id': car.body_type.id,
        'year': car.year,
        'km_min': car.km_min,
        'km_max': car.km_max,
        'fuel_id': car.fuel.id,
        'price': car.price,
        'description': car.description,
        'condition': car.condition.name,
        'transmission': car.transmission.name,
        'status': car.status.name,
        'image': await MultipartFile.fromFile(car.uploadImage!.path),
      });

      final response = await dio.adminHttp.post('/cars', data: formData);
      if (response.statusCode == 200) {
        await Future.delayed(const Duration(seconds: 3));
        refresh();
      } else {
        // state = AsyncValue.error('Failed to add cars', StackTrace.current);
        // Force reload data
        refresh();
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void put(Car car) async {
    try {
      final dio = ref.read(dioHttpProvider.notifier);
      // if car.imagePath starts with http then dont upload image
      if (car.uploadImage!.path.startsWith('http')) {
        final formData = FormData.fromMap({
          'name': car.name,
          'brand_id': car.brand.id,
          'body_type_id': car.body_type.id,
          'year': car.year,
          'km_min': car.km_min,
          'km_max': car.km_max,
          'fuel_id': car.fuel.id,
          'price': car.price,
          'description': car.description,
          'condition': car.condition.name,
          'transmission': car.transmission.name,
          'status': car.status.name,
        });

        final response = await dio.adminHttp.post(
          '/cars/${car.id}?_method=PUT',
          data: formData,
          options: Options(
            contentType: 'multipart/form-data',
            headers: {'Connection': 'Keep-Alive'},
          ),
        );
        if (response.statusCode == 200) {
          refresh();
        } else {
          state = AsyncValue.error(response, StackTrace.current);
          // Force reload data
          refresh();
        }
        return;
      }

      // if car.imagePath starts with http then upload image
      final formData = FormData.fromMap({
        'name': car.name,
        'brand_id': car.brand.id,
        'body_type_id': car.body_type.id,
        'year': car.year,
        'km_min': car.km_min,
        'km_max': car.km_max,
        'fuel_id': car.fuel.id,
        'price': car.price,
        'description': car.description,
        'condition': car.condition.name,
        'transmission': car.transmission.name,
        'status': car.status.name,
        'image': await MultipartFile.fromFile(car.uploadImage!.path),
      });

      final response = await dio.adminHttp.post(
        '/cars/${car.id}?_method=PUT',
        data: formData,
      );
      if (response.statusCode == 200) {
        refresh();
      } else {
        state = AsyncValue.error(response, StackTrace.current);
        // Force reload data
        refresh();
      }
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<bool> delete(String id) async {
    final dio = ref.read(dioHttpProvider.notifier);
    final response = await dio.adminHttp.delete('/cars/$id');
    if (response.statusCode == 200) {
      state = AsyncValue.data(state.value!..removeWhere((car) => car.id == id));
      return true;
    }
    return false;
  }
}
