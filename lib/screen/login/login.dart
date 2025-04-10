import 'package:flutter/material.dart';
import 'package:proyek2/screen/login/form_login_widget.dart';
import 'package:proyek2/style/colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: fbackgroundColor2,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(50),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(50),
            ),
            child: Image.asset(
              "assets/images/bulak-lor.jpg",
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: size.height * 0.025),
            Center(
              child: Column(
                children: [
                  Text(
                    "DESA DIGITAL",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: fbackgroundColor3,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    "Selamat Datang di Desa Bulak Lor",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: fbackgroundColor3,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    "Kab. Indramayu",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: fbackgroundColor3,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const FormLoginWidget(),
          ],
        ),
      ),
    );
  }
}
