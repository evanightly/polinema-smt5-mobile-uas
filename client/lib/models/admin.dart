class Admin {
  final String? id;
  final String name;
  final String email;
  final String password;
  final bool isSuperAdmin;
  final String? image;

  Admin(
    this.id,
    this.name,
    this.email,
    this.password,
    this.isSuperAdmin,
    this.image,
  );

  Admin.create(this.name, this.email, this.password)
      : id = null,
        isSuperAdmin = false,
        image = null;

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      json['_id'],
      json['name'],
      json['email'],
      json['password'],
      json['isSuperAdmin'],
      json['image'],
    );
  }
}
