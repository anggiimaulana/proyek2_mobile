import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyek2/provider/berita/berita_provider.dart';
import 'package:proyek2/style/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BeritaDetailScreen extends StatefulWidget {
  final int beritaId;

  const BeritaDetailScreen({
    super.key,
    required this.beritaId,
  });

  @override
  State<BeritaDetailScreen> createState() => _BeritaDetailScreenState();
}

class _BeritaDetailScreenState extends State<BeritaDetailScreen> {
  BeritaProvider? _beritaProvider; // Simpan reference ke provider

  @override
  void initState() {
    super.initState();
    // Load detail berita saat screen pertama kali dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<BeritaProvider>().fetchBeritaDetail(widget.beritaId);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Simpan reference ke provider saat widget masih aktif
    _beritaProvider = Provider.of<BeritaProvider>(context, listen: false);
  }

  @override
  @override
  void dispose() {
    _beritaProvider?.clearBeritaDetail(notify: false);
    _beritaProvider = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5FF),
      body: Consumer<BeritaProvider>(
        builder: (context, beritaProvider, child) {
          return CustomScrollView(
            slivers: [
              // Custom App Bar dengan gambar dan title yang muncul saat scroll
              _buildSliverAppBar(beritaProvider),

              // Konten berita
              SliverToBoxAdapter(
                child: _buildContent(beritaProvider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(BeritaProvider beritaProvider) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: fbackgroundColor4,
      iconTheme: const IconThemeData(color: Colors.white),
      // Title yang akan muncul saat di-scroll
      title: const Text(
        'Detail Berita',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      // Mengatur kapan title muncul
      titleSpacing: 0,
      centerTitle: false,
      flexibleSpace: FlexibleSpaceBar(
        // Background berupa gambar
        background: beritaProvider.beritaDetail != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: beritaProvider
                        .getImageUrl(beritaProvider.beritaDetail!.data.gambar),
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Memuat gambar...',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) {
                      print('Error loading detail image: $url');
                      print('Error details: $error');
                      return Container(
                        color: Colors.grey[400],
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.broken_image,
                                size: 50,
                                color: Colors.white,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Gambar tidak dapat dimuat',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  // Gradient overlay untuk readability
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black38,
                          Colors.transparent,
                          Colors.black54,
                        ],
                        stops: [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ],
              )
            : Container(
                color: fbackgroundColor4,
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildContent(BeritaProvider beritaProvider) {
    if (beritaProvider.isLoadingDetail) {
      return const SizedBox(
        height: 400,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (beritaProvider.errorMessage.isNotEmpty) {
      return Container(
        height: 400,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                beritaProvider.errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (mounted) {
                    beritaProvider.fetchBeritaDetail(widget.beritaId);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: fbackgroundColor4,
                ),
                child: const Text(
                  'Coba Lagi',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final beritaDetail = beritaProvider.beritaDetail;
    if (beritaDetail == null) {
      return const SizedBox(
        height: 400,
        child: Center(
          child: Text('Data tidak ditemukan'),
        ),
      );
    }

    return Container(
      color: const Color(0xFFF1F5FF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header info
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kategori dan tanggal
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: fbackgroundColor4,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        beritaDetail.data.kategori,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      beritaProvider.formatDate(beritaDetail.data.createdAt),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Judul
                Text(
                  beritaDetail.data.judul,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 12),

                // Penulis
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: fbackgroundColor4,
                      child: const Icon(
                        Icons.person,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Oleh ${beritaDetail.data.penulis}',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Divider
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(color: Colors.grey[300]),
          ),

          // Konten berita
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  beritaDetail.data.isi,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.8,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.justify,
                ),

                const SizedBox(height: 30),

                // Footer info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Dipublikasikan ${beritaProvider.formatDate(beritaDetail.data.createdAt)}',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
