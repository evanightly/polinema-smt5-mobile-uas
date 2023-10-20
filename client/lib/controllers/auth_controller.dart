import 'package:client/components/dashboard_appbar_user.dart';
import 'package:client/controllers/dashboard_screen_controller.dart';
import 'package:client/models/admin.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final dashboardScreenController = Get.put(DashboardScreenController());

  final _loggedUser = Admin('0', '', '', '', false, '').obs;
  final _isLogged = false.obs;

  Admin get loggedUser => _loggedUser.value;
  set loggedUser(Admin admin) => _loggedUser.value = admin;

  bool get isLogged => _isLogged.value;
  set isLogged(bool value) => _isLogged.value = value;

  void login() {
    _loggedUser.value = Admin(
      '1',
      'Ruby Nicholas',
      'a@gmail.com',
      'nicholasN',
      true,
      'assets/images/dog.jpg',
    );

    isLogged = true;

    dashboardScreenController.scaffoldActions.value = [
      const DashboardAppBarUser()
    ];
  }

  void logout() {
    isLogged = false;
  }
}
