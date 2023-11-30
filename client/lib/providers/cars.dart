import 'package:client/components/loading_indicator.dart';
import 'package:client/models/car.dart';
import 'package:client/providers/diohttp.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cars.g.dart';

dynamic generateCarMetadata(Car car) {
  return {
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
      final data = response.data as List<dynamic>;
      final cars = data.map((car) => Car.fromJson(car)).toList();

      return cars;
    } catch (e) {
      return [];
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
        'image': await MultipartFile.fromFile(car.upload_image!.path),
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
      if (car.upload_image != null) {
        formData = FormData.fromMap({
          ...generateCarMetadata(car),
          'image': await MultipartFile.fromFile(car.upload_image!.path),
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

  void search(double priceWeight, double yearWeight, double mileageWeight) {
    final dio = ref.read(dioHttpProvider.notifier);

    try {
      LoadingIndicator.show();

      dio.http.get('/cars/search', queryParameters: {
        'price_weight': priceWeight,
        'year_weight': yearWeight,
        'km_max_weight': mileageWeight,
      }).then((response) {
        final data = response.data as List<dynamic>;
        final cars = data.map((car) => Car.fromJson(car)).toList();

        state = AsyncValue.data(cars);

        LoadingIndicator.dismiss();
      });
    } catch (_) {
      // LoadingIndicator.showError('Failed to search car');
    }
  }
}
