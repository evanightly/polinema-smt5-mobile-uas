class Car {
  String? id;
  String title;
  String? description;
  num price;
  int qty;
  String? image;
  String? soldAt;

  Car({
    this.id,
    required this.title,
    this.description,
    required this.price,
    required this.qty,
    this.image,
    this.soldAt,
  });
}
