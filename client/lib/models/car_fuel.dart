class CarFuel {
  final String id;
  final String name;

  CarFuel({required this.id, required this.name});

  factory CarFuel.fromJson(Map<String, dynamic> json) {
    return CarFuel(
      id: json['id'].toString(),
      name: json['name'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
