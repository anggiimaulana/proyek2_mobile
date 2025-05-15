import 'package:flutter/material.dart';
import 'package:proyek2/style/colors.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            "DesaKita: Bulak Lor",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: fbackgroundColor4,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            "Layanan desa digital, mudah & transparan.",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15,)
        ],
      ),
    );
  }
}
