import 'package:flutter/material.dart';

class MyBanner extends StatelessWidget {
  const MyBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190, // FIXED height
      width: 320, // FIXED width
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: const DecorationImage(
          image: AssetImage("assets/images/bulak-lor.jpg"),
          fit: BoxFit.cover, // Tetap biar gambarnya penuh
        ),
      ),
    );
  }
}
