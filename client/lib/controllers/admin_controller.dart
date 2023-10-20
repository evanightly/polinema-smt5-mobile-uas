import 'package:client/models/admin.dart';
import 'package:get/get.dart';

class AdminController extends GetxController {
  final RxList<Admin> _admins = <Admin>[].obs;

  RxList<Admin> get admins => _admins;
  set admins(RxList<Admin> admins) => _admins.addAll(admins);
}
