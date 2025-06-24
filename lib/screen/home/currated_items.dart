import 'package:flutter/material.dart';
import 'package:proyek2/data/models/berita/berita_home_model.dart';
import 'package:provider/provider.dart';
import 'package:proyek2/provider/berita/berita_home_provider.dart';

class CurratedItems extends StatefulWidget {
  final Datum beritaItems;
  const CurratedItems({
    super.key,
    required this.beritaItems,
  });

  @override
  State<CurratedItems> createState() => _CurratedItemsState();
}

class _CurratedItemsState extends State<CurratedItems> {
  BeritaHomeProvider? _provider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Simpan reference ke provider saat widget masih aktif
    _provider = Provider.of<BeritaHomeProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _provider = null; // Clear reference saat dispose
    super.dispose();
  }

  String getShortDescription(String text, int maxLength) {
    return text.length > maxLength
        ? "${text.substring(0, maxLength).trim()}..."
        : text;
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan provider yang sudah disimpan, bukan context.read
    final provider = _provider;
    if (provider == null) {
      return Container(); // Return empty container jika provider null
    }

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
                image: NetworkImage(
                    provider.getImageUrl(widget.beritaItems.gambar)),
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
                      widget.beritaItems.judul,
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
                    getShortDescription(widget.beritaItems.isi, 50),
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
