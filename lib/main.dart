import 'package:flutter/material.dart';
import 'package:shopsage_frontend/views/admin_view.dart';
import 'package:shopsage_frontend/views/users_view.dart';
import 'package:shopsage_frontend/views/businesses_view.dart';
import 'package:shopsage_frontend/views/reports_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      initialRoute: '/admin',
      routes: {
        '/admin': (context) => const AdminView(),
        '/businesses': (context) => const BusinessesView(),
        '/users': (context) => const UsersView(),
        '/reports': (context) => const ReportsView(),
      },
    );
  }
}
