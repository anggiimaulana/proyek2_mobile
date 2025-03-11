import 'package:flutter/material.dart';


class SuratCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconPath;
  final String colorHex;

  const SuratCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconPath,
    required this.colorHex,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Color bgColor = Color(int.parse("0xFF$colorHex"));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kotak ikon (persegi panjang ke bawah)
            Container(
              width: size.width * 0.20,
              height: size.height * 0.10,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Image.asset(iconPath, width: 45, height: 45),
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              title,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: size.height * 0.005),
            Row(
              children: [
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.black54),
                ),
                const Icon(Icons.chevron_right, color: Colors.black45),
              ],
            ),
          ],
        ),
      ),
    );
  }
}