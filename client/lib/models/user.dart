// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:flutter/material.dart';

class User {
  final String? id;
  final String name;
  final String email;
  final String password;
  final String? address;
  final String? image;
  final String? imageUrl;
  final File? uploadImage;
  final String? token;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.image,
    this.imageUrl,
    this.uploadImage,
    this.token,
    this.address,
  });

  ImageProvider get imageProviderWidget {
    if (image == null) {
      return const AssetImage('assets/images/person2.jpg');
    }
    return NetworkImage(imageUrl!);
  }

  factory User.fromAuthJson(Map<String, dynamic> json) {
    final id = json['user']['id'];
    final name = json['user']['name'];
    final email = json['user']['email'];
    final password = json['user']['password'];
    final image = json['user']['image'];
    final imageUrl = json['user']['image_url'];
    final token = json['token'];
    final address = json['user']['address'];

    final user = User(
      id: id,
      name: name,
      email: email,
      password: password,
      image: image,
      imageUrl: imageUrl,
      token: token,
      address: address,
    );

    return user;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    final email = json['email'];
    final password = json['password'];
    final image = json['image'];
    final imageUrl = json['image_url'];
    final address = json['address'];

    final user = User(
      id: id,
      name: name,
      email: email,
      password: password,
      image: image,
      imageUrl: imageUrl,
      address: address,
    );

    return user;
  }
}
