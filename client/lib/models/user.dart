import 'dart:io';

class User {
  final String? id;
  final String name;
  final String email;
  final String password;
  final String? image;
  final File? uploadImage;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.image,
    this.uploadImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      name: json['name'].toString(),
      email: json['email'].toString(),
      password: json['password'].toString(),
      image: json['image'].toString(),
    );
  }
}
