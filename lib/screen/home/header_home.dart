import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:proyek2/screen/home/banner_home.dart';
import 'package:proyek2/utils/colors.dart';

class MyHeader extends StatelessWidget {
  const MyHeader({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Background Header
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25),
            ),
            color: fbackgroundColor3,
          ),
          height: size.height * 0.25,
          width: double.infinity,
          child: Column(
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: size.height * 0.05),
                child: Row(
                  children: [
                    // Logo
                    Image.asset(
                      "assets/icons/pemda2.png",
                      height: 85,
                      width: 65,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error, color: Colors.red);
                      },
                    ),
                    const SizedBox(width: 5),

                    // Nama Desa
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Desa Bulak Lor",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Kecamatan Jatibarang",
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                        Text(
                          "45273",
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Icon dengan Notifikasi
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 8,
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(
                            Iconsax.notification,
                            size: 30,
                            color: Colors.white,
                          ),
                          Positioned(
                            right: -2,
                            top: -5,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Text(
                                "3",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Banner Menimpa Setengah Header
        Positioned(
          top: size.height * 0.17,
          left: size.width * 0.05,
          right: size.width * 0.05,
          child: const MyBanner(),
        ),
      ],
    );
  }
}
