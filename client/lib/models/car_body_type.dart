import 'package:client/models/car.dart';

class CarBodyType {
  final int? id;
  final String name;
  final List<Car>? cars;

  CarBodyType({this.id, required this.name, this.cars});

  factory CarBodyType.fromJson(Map<String, dynamic> json) {
    final List<Car> parsedCars = json['cars'] != null
        ? (json['cars'] as List<dynamic>).map(
            (car) {
              return Car.fromJson(car);
            },
          ).toList()
        : [];

    return CarBodyType(
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
