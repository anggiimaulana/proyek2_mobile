import 'package:flutter/material.dart';
import 'package:proyek2/data/models/berita/berita_models.dart';

class CurratedItems extends StatelessWidget {
  final Berita beritaItems;
  const CurratedItems({
    super.key,
    required this.beritaItems,
  });

  String getShortDescription(String text, int maxLength) {
    return text.length > maxLength
        ? "${text.substring(0, maxLength).trim()}..."
        : text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF1F5FF),
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
            width: 280,
          ),
          const SizedBox(height: 7),
          SizedBox(
            width: 280,
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
