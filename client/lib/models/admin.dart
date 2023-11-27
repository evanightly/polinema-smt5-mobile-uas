// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class Admin {
  final String? id;
  final String name;
  final String email;
  final String password;
  final bool is_super_admin;
  final String? image_url;
  final String? upload_image;
  final String? token;

  const Admin({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.is_super_admin,
    this.image_url,
    this.upload_image,
    this.token,
  });

  ImageProvider get imageProviderWidget {
    if (image_url == 'null') {
      return const AssetImage('assets/images/person1.jpg');
    }
    return NetworkImage(image_url!);
  }

  factory Admin.fromAuthJson(Map<String, dynamic> json) {
    final id = json['admin']['id'].toString();
    final name = json['admin']['name'].toString();
    final email = json['admin']['email'].toString();
    final password = json['admin']['password'].toString();
    final is_super_admin = json['admin']['is_super_admin'] == 1 ? true : false;
    final image_url = json['admin']['image_url'].toString();
    final token = json['token'].toString();

    final admin = Admin(
      id: id,
      name: name,
      email: email,
      password: password,
      is_super_admin: is_super_admin,
      image_url: image_url,
      token: token,
    );

    return admin;
  }

  factory Admin.fromJson(Map<String, dynamic> json) {
    final id = json['id'].toString();
    final name = json['name'].toString();
    final email = json['email'].toString();
    final password = json['password'].toString();
    final is_super_admin = json['is_super_admin'] == 1 ? true : false;
    final image_url = json['image_url'].toString();

    final admin = Admin(
      id: id,
      name: name,
      email: email,
      password: password,
      is_super_admin: is_super_admin,
      image_url: image_url,
    );

    return admin;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'is_super_admin': is_super_admin,
      'image_url': image_url,
    };
  }
}
