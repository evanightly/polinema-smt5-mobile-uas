import 'package:client/providers/diohttp.dart';

class Admin {
  final String? id;
  final String name;
  final String email;
  final String password;
  final bool isSuperAdmin;
  final String? image;
  final String? token;

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

  const Admin({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.isSuperAdmin,
    this.image,
    this.token,
  });

  factory Admin.fromAuthJson(Map<String, dynamic> json) {
    final id = json['user']['id'].toString();
    final name = json['user']['name'].toString();
    final email = json['user']['email'].toString();
    final password = json['user']['password'].toString();
    final isSuperAdmin = json['user']['isSuperAdmin'] == 1 ? true : false;
    final image = json['user']['image'].toString();
    final token = json['token'].toString();

    final admin = Admin(
      id: id,
      name: name,
      email: email,
      password: password,
      isSuperAdmin: isSuperAdmin,
      image: image,
      token: token,
    );

    return admin;
  }

  // fromJson
  factory Admin.fromJson(Map<String, dynamic> json) {
    final id = json['id'].toString();
    final name = json['name'].toString();
    final email = json['email'].toString();
    final password = json['password'].toString();
    final isSuperAdmin = json['isSuperAdmin'] == 1 ? true : false;
    final image = json['image'].toString();

    final admin = Admin(
      id: id,
      name: name,
      email: email,
      password: password,
      isSuperAdmin: isSuperAdmin,
      image: image,
    );

    return admin;
  }
}
