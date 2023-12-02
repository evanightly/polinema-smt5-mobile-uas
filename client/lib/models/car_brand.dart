import 'package:client/models/car.dart';

class CarBrand {
  final int? id;
  final String name;
  final List<Car>? cars;

  CarBrand({this.id, required this.name, this.cars});

  factory CarBrand.fromJson(Map<String, dynamic> json) {
    final List<Car> parsedCars = json['cars'] != null
        ? (json['cars'] as List<dynamic>).map(
            (car) {
              return Car.fromJson(car);
            },
          ).toList()
        : [];

    return CarBrand(
      id: json['id'],
      name: json['name'],
      cars: parsedCars,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
