import 'package:flutter/material.dart';
import 'package:proyek2/screen/main_screen.dart';
import 'package:proyek2/static/navigation_soute.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: NavigationRoute.mainRoute.name,
      routes: {
        NavigationRoute.mainRoute.name: (context) => const MainScreen(),
        ...appRoutes,
      },
    );
  }
}
