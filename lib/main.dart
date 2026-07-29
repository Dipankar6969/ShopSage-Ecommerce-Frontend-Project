import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/auth_controller.dart';
import 'views/account_view.dart';
// import 'views/login_view.dart';   // ← uncomment later when you create LoginView

void main() {
  Get.put(AuthController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ecommerce App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F172A)),
        useMaterial3: true,
      ),
      // Temporary: still open Profile for testing
      home: const AccountView(),

      // Later you will change to this:
      // initialRoute: '/login',
      // getPages: [
      //   GetPage(name: '/login', page: () => const LoginView()),
      //   GetPage(name: '/profile', page: () => const AccountView()),
      // ],
    );
  }
}
