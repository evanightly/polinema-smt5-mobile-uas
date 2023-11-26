import 'dart:io';
import 'package:flutter/material.dart';

class User {
  final String? id;
  final String name;
  final String email;
  final String password;
  final String? phone;
  final String? address;
  final String? imageUrl;
  final File? uploadImage;
  final String? token;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    this.imageUrl,
    this.uploadImage,
    this.token,
    this.address,
  });

  ImageProvider get imageProviderWidget {
    if (imageUrl == 'null') {
      return const AssetImage('assets/images/person2.jpg');
    }
    return NetworkImage(imageUrl!);
  }

  factory User.fromAuthJson(Map<String, dynamic> json) {
    final id = json['user']['id'].toString();
    final name = json['user']['name'].toString();
    final email = json['user']['email'].toString();
    final password = json['user']['password'].toString();
    final phone = json['user']['phone'].toString();
    final imageUrl = json['user']['imageUrl'].toString();
    final token = json['token'].toString();
    final address = json['user']['address'].toString();

    final admin = User(
      id: id,
      name: name,
      email: email,
      password: password,
      phone: phone,
      imageUrl: imageUrl,
      token: token,
      address: address,
    );

    return admin;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    final id = json['id'].toString();
    final name = json['name'].toString();
    final email = json['email'].toString();
    final password = json['password'].toString();
    final phone = json['phone'].toString();
    final imageUrl = json['imageUrl'].toString();
    final address = json['address'].toString();

    final admin = User(
      id: id,
      name: name,
      email: email,
      password: password,
      phone: phone,
      imageUrl: imageUrl,
      address: address,
    );

    return admin;
  }
}
