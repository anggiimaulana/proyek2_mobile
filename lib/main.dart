import 'package:flutter/material.dart';
import 'package:proyek2/routes.dart';
import 'package:proyek2/view/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AppMainScreen(),
      routes: appRoutes,
    );
  }
}
