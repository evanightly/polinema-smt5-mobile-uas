import 'package:flutter/material.dart';

class Admin {
  final String? id;
  final String name;
  final String email;
  final String password;
  final bool isSuperAdmin;
  final String? imageUrl;
  final String? uploadImage;
  final String? token;

  const Admin({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.isSuperAdmin,
    this.imageUrl,
    this.uploadImage,
    this.token,
  });

  ImageProvider get imageProviderWidget {
    if (imageUrl == 'null') {
      return const AssetImage('assets/images/person1.jpg');
    }
    return NetworkImage(imageUrl!);
  }

  factory Admin.fromAuthJson(Map<String, dynamic> json) {
    final id = json['admin']['id'].toString();
    final name = json['admin']['name'].toString();
    final email = json['admin']['email'].toString();
    final password = json['admin']['password'].toString();
    final isSuperAdmin = json['admin']['isSuperAdmin'] == 1 ? true : false;
    final imageUrl = json['admin']['imageUrl'].toString();
    final token = json['token'].toString();

    final admin = Admin(
      id: id,
      name: name,
      email: email,
      password: password,
      isSuperAdmin: isSuperAdmin,
      imageUrl: imageUrl,
      token: token,
    );

    return admin;
  }

  factory Admin.fromJson(Map<String, dynamic> json) {
    final id = json['id'].toString();
    final name = json['name'].toString();
    final email = json['email'].toString();
    final password = json['password'].toString();
    final isSuperAdmin = json['isSuperAdmin'] == 1 ? true : false;
    final imageUrl = json['imageUrl'].toString();

    final admin = Admin(
      id: id,
      name: name,
      email: email,
      password: password,
      isSuperAdmin: isSuperAdmin,
      imageUrl: imageUrl,
    );

    return admin;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'isSuperAdmin': isSuperAdmin,
      'imageUrl': imageUrl,
    };
  }
}
