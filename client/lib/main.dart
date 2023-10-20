import 'package:client/components/dashboard_appbar.dart';
import 'package:client/components/dashboard_appbar_user.dart';
import 'package:client/components/dashboard_drawer_menu.dart';
import 'package:client/config/custom_theme.dart';
import 'package:client/controllers/admin_controller.dart';
import 'package:client/controllers/auth_controller.dart';
import 'package:client/controllers/dashboard_screen_controller.dart';
import 'package:client/controllers/item_controller.dart';
import 'package:client/models/admin.dart';
import 'package:client/models/item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();

  final authController = Get.put(AuthController());
  final itemController = Get.put(ItemController());
  final adminController = Get.put(AdminController());

  authController.loggedUser = Admin(
    '1',
    'Ruby Nicholas',
    'a@gmail.com',
    'nicholasN',
    true,
    'assets/images/dog.jpg',
  );

  itemController.items = RxList(
    [
      Item(
        title: 'Mustang GT',
        price: 120.000,
        image: 'assets/images/car1_MustangGT.jpg',
        qty: 12,
      ),
      Item(
        title: 'Porsche',
        price: 180.000,
        image: 'assets/images/car2_Porsche.jpg',
        qty: 7,
      ),
      Item(
        title: 'Lamborghini',
        price: 240.000,
        image: 'assets/images/car3_Lamborghini.jpg',
        qty: 2,
      ),
      Item(
        title: 'BMW M4',
        price: 100.000,
        image: 'assets/images/car4_M4.jpg',
        qty: 31,
      ),
      Item(
        title: 'F-Type Jaguar',
        price: 190.000,
        image: 'assets/images/car5_FTypeJaguar.jpg',
        qty: 5,
      ),
    ],
  );

  adminController.admins = RxList(
    [
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
        'Mike Adams',
        'mike@gmail.com',
        'mikeasms',
        true,
        'assets/images/person1.jpg',
      ),
      Admin(
        '3',
        'Edward',
        'edward@gmail.com',
        'edwardo',
        false,
        'assets/images/person2.jpg',
      ),
      Admin(
        '4',
        'Jason',
        'jason@gmail.com',
        'jasondc',
        false,
        'assets/images/person3.jpg',
      ),
    ],
  );
  
  runApp(App());
}

class App extends StatelessWidget {
  App({super.key});

  final authController = Get.put(AuthController());

  final selectedPageIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        brightness: Brightness.dark,
      ),
      home: Scaffold(
          appBar: DashboardAppBar(
            appBar: AppBar(),
            actions: const [DashboardAppBarUser()],
          ),
          drawer: const DashboardDrawerMenu(),
          body: MainContent()),
    );
  }
}

class MainContent extends StatelessWidget {
  MainContent({super.key});
  final dashboardScreenController = Get.put(DashboardScreenController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      int pageIndex = dashboardScreenController.selectedPageIndex;
      return drawerItems[pageIndex].component ??
          const Center(child: Text('No Component\'s Yet'));
    });
  }
}
