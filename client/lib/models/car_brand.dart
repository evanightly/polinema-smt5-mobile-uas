class CarBrand {
  final String id;
  final String name;

  CarBrand({required this.id, required this.name});

  factory CarBrand.fromJson(Map<String, dynamic> json) {
    return CarBrand(
      id: json['id'].toString(),
      name: json['name'].toString(),
    );
  }
}
