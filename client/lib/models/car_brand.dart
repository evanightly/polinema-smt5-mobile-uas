import 'package:client/models/car.dart';

class CarBrand {
  final String? id;
  final String name;
  final List<Car> cars;

  CarBrand({this.id, required this.name, this.cars = const []});

  factory CarBrand.fromJson(Map<String, dynamic> json) {
    return CarBrand(
      id: json['id'].toString(),
      name: json['name'].toString(),
      cars: json['cars'] != null
          ? (json['cars'] as List<dynamic>).map(
              (car) {
                return Car.fromJson(car);
              },
            ).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
