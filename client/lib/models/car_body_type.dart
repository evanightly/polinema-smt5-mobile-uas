import 'package:client/models/car.dart';

class CarBodyType {
  final String? id;
  final String name;
  final List<Car> cars;

  CarBodyType({this.id, required this.name, this.cars = const []});

  factory CarBodyType.fromJson(Map<String, dynamic> json) {
    return CarBodyType(
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
