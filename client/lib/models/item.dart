class Item {
  String? id;
  String title;
  String? description;
  num price;
  int qty;
  String? image;

  Item({
    this.id,
    required this.title,
    this.description,
    required this.price,
    required this.qty,
    this.image,
  });
}
