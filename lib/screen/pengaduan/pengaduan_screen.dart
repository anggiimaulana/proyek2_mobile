import 'package:flutter/material.dart';
import 'package:proyek2/screen/pengaduan/riwayat_pengaduan_screen.dart';
import 'package:proyek2/style/colors.dart';
import 'bantuan_screen.dart';
import 'buat_laporan_screen.dart';

class PengaduanScreen extends StatelessWidget {
  const PengaduanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cardItems = [
      {
        'icon': Icons.edit_document,
        'label': 'Pilih Pengaduan',
        'gradient': [fbackgroundColor3, fbackgroundColor3],
        'target': const BuatLaporanScreen(),
      },
      {
        'icon': Icons.workspace_premium_sharp,
        'label': 'Riwayat\nPelaporan',
        'gradient': [fbackgroundColor3, fbackgroundColor3],
        'target': const RiwayatPengaduanPage(),
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5FF),
      body: Column(
        children: [
          // Custom header (AppBar) dengan lekukan bawah
          ClipPath(
            clipper: HeaderClipper(),
            child: Container(
              width: double.infinity,
              color: fbackgroundColor3,
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: const Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                    'Layanan Pengaduan Masyarakat',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Text(
                    'Ayo Sampaikan Suaramu!',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: fbackgroundColor4,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Laporkan masalahmu sekarang demi kebaikan bersama. Kami siap mendengar dan membantu.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cardItems.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 0.85,
                    ),
                    itemBuilder: (context, index) {
                      final item = cardItems[index];
                      return _AnimatedMenuCard(
                        icon: item['icon'] as IconData,
                        label: item['label'] as String,
                        gradientColors: item['gradient'] as List<Color>,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => item['target'] as Widget),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 72,
        height: 72,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BantuanScreen(),
              ),
            );
          },
          backgroundColor: fbackgroundColor4, // Warna background4
          elevation: 4,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.menu_book,
                color: Colors.white,
                size: 25,
              ),
              SizedBox(height: 2),
              Text(
                "Panduan",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

// Clipper untuk bikin lekukan di bawah AppBar
class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _AnimatedMenuCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final List<Color> gradientColors;

  const _AnimatedMenuCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.gradientColors,
  }) : super(key: key);

  @override
  State<_AnimatedMenuCard> createState() => _AnimatedMenuCardState();
}

class _AnimatedMenuCardState extends State<_AnimatedMenuCard>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.95),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 150),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: widget.gradientColors.last.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  widget.icon,
                  size: 40,
                  color: widget.gradientColors.last,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
