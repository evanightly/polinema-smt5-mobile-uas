// ignore_for_file: constant_identifier_names, non_constant_identifier_names

enum Transmission { Automatic, Manual }

enum Status { Available, Sold }

enum Condition { New, Used }

class Car {
  String? id;
  String name;
  String brand;
  String body_type;
  String year;
  num km_min;
  num km_max;
  String fuel;
  num price;
  String image;
  String? description;
  Condition condition;
  Transmission transmission;
  Status status;

  // constructor using named parameter
  Car({
    this.id,
    required this.name,
    required this.brand,
    required this.body_type,
    required this.year,
    required this.km_min,
    required this.km_max,
    required this.fuel,
    required this.price,
    required this.image,
    this.description,
    required this.condition,
    required this.transmission,
    required this.status,
  });

  // convert json to object
  factory Car.fromJson(Map<String, dynamic> json) {
    final id = json['id'].toString();
    final name = json['name'].toString();
    final brand = json['brand']['name'].toString();
    final body_type = json['body_type']['name'].toString();
    final year = json['year'].toString();
    final km_min = num.parse(json['km_min'].toString());
    final km_max = num.parse(json['km_max'].toString());
    final fuel = json['fuel']['name'].toString();
    final price = num.parse(json['price'].toString());
    final image = json['image'].toString();
    final description = json['description'].toString();
    final transmission =
        Transmission.values.byName(json['transmission'].toString());
    final status = Status.values.byName(json['status']);
    final condition = Condition.values.byName(json['condition']);

    return Car(
      id: id,
      name: name,
      brand: brand,
      body_type: body_type,
      year: year,
      km_min: km_min,
      km_max: km_max,
      fuel: fuel,
      price: price,
      image: image,
      description: description,
      condition: condition,
      transmission: transmission,
      status: status,
    );
  }
}
