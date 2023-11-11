import 'package:client/models/car.dart';

class CarFuel {
  final String? id;
  final String name;
  final List<Car> cars;

  CarFuel({this.id, required this.name, this.cars = const []});

  factory CarFuel.fromJson(Map<String, dynamic> json) {
    return CarFuel(
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
