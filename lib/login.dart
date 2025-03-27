import 'package:flutter/material.dart';
import 'package:proyek2/utils/colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: fbackgroundColor2,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200), // Sesuaikan tinggi gambar
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 5, spreadRadius: 2)
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
            child: Image.asset(
              "assets/images/bulak-lor.jpg",
              width: double.infinity,
              height: 250, // Sesuaikan tinggi
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Column(children: [
                SizedBox(height: size.height * 0.025),
                Text(
                  "DESA DIGITAL",
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: fbackgroundColor3,
                      fontStyle: FontStyle.italic),
                ),
                Text(
                  "Selamat Datang di Desa Bulak Lor",
                  style: TextStyle(
                      fontSize: 18,
                      color: fbackgroundColor3,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
                Text(
                  "Kab. Indramayu",
                  style: TextStyle(
                      fontSize: 18,
                      color: fbackgroundColor3,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                )
              ]),
            ),
            const FormLoginScreen(), // Ini akan bisa discroll jika keyboard muncul
          ],
        ),
      ),
    );
  }
}

class FormLoginScreen extends StatefulWidget {
  const FormLoginScreen({super.key});

  @override
  State<FormLoginScreen> createState() => _FormLoginScreenState();
}

class _FormLoginScreenState extends State<FormLoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true; // Untuk mengontrol visibilitas password

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          const Text(
            "Nomor Telepon",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: "Masukan No. Telepon",
              hintStyle: TextStyle(color: Colors.grey.shade400),
              prefixIcon: const Icon(Icons.call, color: Colors.black54),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Password",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              hintText: "Password",
              hintStyle: TextStyle(color: Colors.grey.shade400),
              prefixIcon: const Icon(Icons.lock, color: Colors.black54),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.black54,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Warna tombol sesuai gambar
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {
                // Handle login action
              },
              child: const Text(
                "Masuk",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
