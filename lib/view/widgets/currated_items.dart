import 'package:flutter/material.dart';
import 'package:proyek2/models/berita_models.dart';

class CurratedItems extends StatelessWidget {
  final Berita beritaItems;
  final Size size;
  const CurratedItems({
    super.key,
    required this.beritaItems,
    required this.size,
  });

  // Fungsi untuk membatasi panjang deskripsi dengan format lebih rapi
  String getShortDescription(String text, int maxLength) {
    return text.length > maxLength
        ? "${text.substring(0, maxLength).trim()}..."
        : text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Background putih
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(beritaItems.image),
              ),
            ),
            height: 165,
            width: size.width * 0.75,
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.black26,
                  child: Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 7),
          SizedBox(
            width: size.width * 0.75,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 5, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      beritaItems.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                  Text(
                    getShortDescription(beritaItems.description, 50),
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                      color: Colors.black,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
