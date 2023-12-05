// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';

class Admin {
  final String? id;
  final String name;
  final String email;
  final String password;
  final bool isSuperAdmin;
  final String? imageUrl;
  final File? uploadImage;
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
    final id = json['admin']['id'];
    final name = json['admin']['name'];
    final email = json['admin']['email'];
    final password = json['admin']['password'];
    final isSuperAdmin = json['admin']['is_super_admin'] == 1 ? true : false;
    final imageUrl = json['admin']['image_url'];
    final token = json['token'];

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
    final id = json['id'];
    final name = json['name'];
    final email = json['email'];
    final password = json['password'];
    final isSuperAdmin = json['is_super_admin'] == 1 ? true : false;
    final imageUrl = json['image_url'];

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
      'is_super_admin': isSuperAdmin,
      'image_url': imageUrl,
    };
  }
}
