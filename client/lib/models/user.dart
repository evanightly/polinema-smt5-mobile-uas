// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:flutter/material.dart';

class User {
  final String? id;
  final String name;
  final String email;
  final String password;
  final String? address;
  final String? image_url;
  final File? upload_image;
  final String? token;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.image_url,
    this.upload_image,
    this.token,
    this.address,
  });

  ImageProvider get imageProviderWidget {
    if (image_url == 'null') {
      return const AssetImage('assets/images/person2.jpg');
    }
    return NetworkImage(image_url!);
  }

  factory User.fromAuthJson(Map<String, dynamic> json) {
    final id = json['user']['id'].toString();
    final name = json['user']['name'].toString();
    final email = json['user']['email'].toString();
    final password = json['user']['password'].toString();
    final image_url = json['user']['image_url'].toString();
    final token = json['token'].toString();
    final address = json['user']['address'].toString();

    final admin = User(
      id: id,
      name: name,
      email: email,
      password: password,
      image_url: image_url,
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
    final image_url = json['image_url'].toString();
    final address = json['address'].toString();

    final admin = User(
      id: id,
      name: name,
      email: email,
      password: password,
      image_url: image_url,
      address: address,
    );

    return admin;
  }
}
