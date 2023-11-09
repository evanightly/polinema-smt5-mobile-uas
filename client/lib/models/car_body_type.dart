class CarBodyType {
  final String id;
  final String name;

  CarBodyType({required this.id, required this.name});

  factory CarBodyType.fromJson(Map<String, dynamic> json) {
    return CarBodyType(
      id: json['id'].toString(),
      name: json['name'].toString(),
    );
  }
}
