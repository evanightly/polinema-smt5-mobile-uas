import 'package:client/models/car.dart';

class CarFuel {
  final int? id;
  final String name;
  final List<Car>? cars;

  CarFuel({this.id, required this.name, this.cars});

  factory CarFuel.fromJson(Map<String, dynamic> json) {
    final List<Car> parsedCars = json['cars'] != null
        ? (json['cars'] as List<dynamic>).map(
            (car) {
              return Car.fromJson(car);
            },
          ).toList()
        : [];

    return CarFuel(
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
