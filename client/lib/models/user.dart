import 'dart:io';

import 'package:client/providers/diohttp.dart';

class User {
  final String? id;
  final String name;
  final String email;
  final String password;
  final String? image;
  final File? uploadImage;
  final String? token;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.image,
    this.uploadImage,
    this.token,
  });

  String get imageUrl {
    if (image == null) {
      return '';
    }

    if (image!.startsWith('http')) {
      return image!;
    } else {
      return 'http://$ipv4/polinema-smt5-mobile-uas/server/public/storage/images/admins/$image';
    }
  }

  factory User.fromAuthJson(Map<String, dynamic> json) {
    final id = json['user']['id'].toString();
    final name = json['user']['name'].toString();
    final email = json['user']['email'].toString();
    final password = json['user']['password'].toString();
    final image = json['user']['image'].toString();
    final token = json['token'].toString();

    final admin = User(
      id: id,
      name: name,
      email: email,
      password: password,
      image: image,
      token: token,
    );

    return admin;
  }

  // fromJson
  factory User.fromJson(Map<String, dynamic> json) {
    final id = json['id'].toString();
    final name = json['name'].toString();
    final email = json['email'].toString();
    final password = json['password'].toString();
    final image = json['image'].toString();

    final admin = User(
      id: id,
      name: name,
      email: email,
      password: password,
      image: image,
    );

    return admin;
  }
}
