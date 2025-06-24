import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyek2/provider/berita/berita_provider.dart';
import 'package:proyek2/style/colors.dart';
import 'package:proyek2/screen/berita/berita_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BeritaScreen extends StatefulWidget {
  const BeritaScreen({super.key});

  @override
  State<BeritaScreen> createState() => _BeritaScreenState();
}

class _BeritaScreenState extends State<BeritaScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Setup scroll listener untuk pagination
    _scrollController.addListener(_scrollListener);

    // Load berita saat screen pertama kali dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BeritaProvider>().fetchBerita(isRefresh: true);
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more data saat user scroll mendekati bottom
      context.read<BeritaProvider>().loadMoreBerita();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  String getShortDescription(String text, int maxLength) {
    return text.length > maxLength
        ? "${text.substring(0, maxLength).trim()}..."
        : text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5FF),
      appBar: AppBar(
        backgroundColor: fbackgroundColor4,
        title: const Text(
          "Berita Desa",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
        ),
        elevation: 0,
      ),
      body: Consumer<BeritaProvider>(
        builder: (context, beritaProvider, child) {
          return RefreshIndicator(
            onRefresh: () async {
              await beritaProvider.fetchBerita(isRefresh: true);
            },
            child: _buildContent(beritaProvider),
          );
        },
      ),
    );
  }

  Widget _buildContent(BeritaProvider beritaProvider) {
    if (beritaProvider.isLoading && beritaProvider.beritaList.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Memuat berita...'),
          ],
        ),
      );
    }

    if (beritaProvider.errorMessage.isNotEmpty &&
        beritaProvider.beritaList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                beritaProvider.errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => beritaProvider.fetchBerita(isRefresh: true),
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
      );
    }

    if (beritaProvider.beritaList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada berita tersedia',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: beritaProvider.beritaList.length +
          (beritaProvider.hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        // Show loading indicator at the bottom
        if (index == beritaProvider.beritaList.length) {
          return _buildLoadMoreIndicator(beritaProvider);
        }

        final berita = beritaProvider.beritaList[index];
        return _buildBeritaCard(berita, beritaProvider);
      },
    );
  }

  Widget _buildLoadMoreIndicator(BeritaProvider beritaProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: beritaProvider.isLoadingMore
            ? const Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 8),
                  Text('Memuat lebih banyak...'),
                ],
              )
            : beritaProvider.hasMoreData
                ? ElevatedButton(
                    onPressed: () => beritaProvider.loadMoreBerita(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: fbackgroundColor4,
                    ),
                    child: const Text(
                      'Muat Lebih Banyak',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : const Text(
                    'Tidak ada berita lagi',
                    style: TextStyle(color: Colors.grey),
                  ),
      ),
    );
  }

  Widget _buildBeritaCard(berita, BeritaProvider beritaProvider) {
    return Card(
      color: const Color(0xFFF1F5FF),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BeritaDetailScreen(beritaId: berita.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar berita
            _buildBeritaImage(berita, beritaProvider),

            // Konten berita
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kategori dan tanggal
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: fbackgroundColor4,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          berita.kategori,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        beritaProvider.formatDate(berita.createdAt),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Judul berita
                  Text(
                    berita.judul,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Isi berita (preview)
                  Text(
                    getShortDescription(berita.isi, 100),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Penulis
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        berita.penulis,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Baca selengkapnya',
                        style: TextStyle(
                          color: fbackgroundColor4,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: fbackgroundColor4,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Ganti CachedNetworkImage di BeritaScreen dengan ini untuk debugging
  Widget _buildBeritaImage(berita, BeritaProvider beritaProvider) {
    String imageUrl = beritaProvider.getImageUrl(berita.gambar);

    // Debug print tambahan
    print('=== BUILDING IMAGE WIDGET ===');
    print('Raw gambar field: ${berita.gambar}');
    print('Processed image URL: $imageUrl');
    print('============================');

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
      child: Container(
        height: 200,
        width: double.infinity,
        child: Stack(
          children: [
            // Gambar utama
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              httpHeaders: {
                // Tambahkan headers jika diperlukan
                'User-Agent': 'Flutter App',
              },
              placeholder: (context, url) {
                print('📱 Loading image: $url');
                return Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 8),
                        Text(
                          'Memuat gambar...',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              errorWidget: (context, url, error) {
                print('❌ Error loading image: $url');
                print('❌ Error details: $error');
                print('❌ Error type: ${error.runtimeType}');

                return Container(
                  color: Colors.grey[300],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Gambar tidak dapat dimuat',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'URL: ${url.length > 50 ? '${url.substring(0, 50)}...' : url}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Error: ${error.toString()}',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
            // Gradient overlay
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black12,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
