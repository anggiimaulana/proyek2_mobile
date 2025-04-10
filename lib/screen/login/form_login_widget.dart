import 'package:flutter/material.dart';
import 'package:proyek2/utils/colors.dart';

class FormLoginWidget extends StatefulWidget {
  const FormLoginWidget({super.key});

  @override
  State<FormLoginWidget> createState() => _FormLoginWidgetState();
}

class _FormLoginWidgetState extends State<FormLoginWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          buildTextField(
            label: "Nomor Telepon",
            icon: Icons.call,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 20),
          TextFormField(
            obscureText: _obscurePassword,
            decoration: buildInputDecoration(
              label: "Password",
              icon: Icons.lock,
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
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: fbackgroundColor4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // TODO: Tambahkan fungsi login di sini
                }
              },
              child: const Text(
                "Masuk",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// TextField dengan floating label
  Widget buildTextField({
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) =>
      TextFormField(
        keyboardType: keyboardType,
        decoration: buildInputDecoration(label: label, icon: icon),
      );

  /// Input decoration (floating label style)
  InputDecoration buildInputDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) =>
      InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black87),
        prefixIcon: Icon(icon, color: Colors.black54),
        suffixIcon: suffixIcon,
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
      );
}
