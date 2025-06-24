import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyek2/provider/berita/berita_home_provider.dart';
import 'package:proyek2/screen/berita/berita_detail_screen.dart';
import 'package:proyek2/screen/home/currated_items.dart';

class BeritaHome extends StatefulWidget {
  const BeritaHome({super.key});

  @override
  State<BeritaHome> createState() => _BeritaHomeState();
}

class _BeritaHomeState extends State<BeritaHome> {
  @override
  void initState() {
    super.initState();
    // Alternatif 1: Gunakan Future.microtask
    Future.microtask(() {
      Provider.of<BeritaHomeProvider>(context, listen: false).fetchBeritaHome();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BeritaHomeProvider>(
      builder: (context, beritaProvider, child) {
        if (beritaProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (beritaProvider.errorMessage.isNotEmpty) {
          return Center(child: Text(beritaProvider.errorMessage));
        }
        final beritaHome = beritaProvider.beritaHomeList;
        if (beritaHome.isEmpty) {
          return const Center(child: Text('Belum ada berita'));
        }
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
                    color: const Color(0xFFF1F5FF),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BeritaDetailScreen(beritaId: berita.id),
                              ),
                            );
                          },
                          child: CurratedItems(
                            beritaItems: berita,
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
      },
    );
  }
}
