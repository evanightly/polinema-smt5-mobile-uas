import 'package:client/models/admin.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admins.g.dart';

@Riverpod(keepAlive: true)
class Admins extends _$Admins {
  @override
  List<Admin> build() {
    return [
      Admin(
        '1',
        'Ruby Nicholas',
        'a@gmail.com',
        'nicholasN',
        true,
        'assets/images/dog.jpg',
      ),
      Admin(
        '2',
        'Edward',
        'edward@gmail.com',
        'edwardo',
        false,
        'assets/images/person1.jpg',
      ),
      Admin(
        '3',
        'Jason',
        'jason@gmail.com',
        'jasondc',
        false,
        'assets/images/person2.jpg',
      ),
      Admin(
        '4',
        'Michael',
        'michael@gmail.com',
        'msjask',
        false,
        'assets/images/person3.jpg',
      ),
    ];
  }
}
