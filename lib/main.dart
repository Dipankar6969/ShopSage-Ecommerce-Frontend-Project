import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'constants/app_constants.dart';
import 'controller/auth_controller.dart';
import 'controller/cart_controller.dart';
import 'controller/product_controller.dart';
import 'views/home/home_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  // Initialize Controllers
  Get.put(AuthController());
  Get.put(CartController());
  Get.put(ProductController());

  runApp(const ShopSageApp());
}

class ShopSageApp extends StatelessWidget {
  const ShopSageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32)),
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),

      initialRoute: '/homepage',

      getPages: [
        GetPage(
          name: '/homepage',
          page: () => const HomeView(),
        ),
      ],
    );
  }
}