import 'package:flutter/material.dart';
import 'package:proyek2/data/models/berita/berita_models.dart';
import 'package:proyek2/screen/home/currated_items.dart';

class BeritaHome extends StatefulWidget {
  const BeritaHome({super.key});

  @override
  State<BeritaHome> createState() => _BeritaHomeState();
}

class _BeritaHomeState extends State<BeritaHome> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          beritaHome.length,
          (index) {
            final berita = beritaHome[index];
            return Padding(
              padding: index == 0
                  ? const EdgeInsets.symmetric(horizontal: 15)
                  : const EdgeInsets.only(right: 15),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: CurratedItems(
                        beritaItems: berita,
                        size: size,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
