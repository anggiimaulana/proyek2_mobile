class Berita {
  final String name, image, description;

  Berita({
    required this.name,
    required this.image,
    required this.description,
  });
}

List<Berita> beritaHome = [
  Berita(
    name: "Wong Plered Top 5 Dutpol",
    image: "assets/images/erwan.jpg",
    description:
        "Tetap pakai kode ini di berita_home.dart supaya gambar hanya ditampilkan di sini:",
  ),
  Berita(
    name: "Masyarakat Ikut Serta Belajar Figma",
    image: "assets/images/figma.jpg",
    description:
        "Kalau gambarnya jadi dua, kemungkinan besar CurratedItems juga menampilkan gambar selain dari BeritaHome.",
  ),
  Berita(
    name: "Bulak Lor - Desa Digital",
    image: "assets/images/bulak-lor.jpg",
    description:
        "Ya, kemungkinan besar deskripsi tidak full karena ukuran width: size.width * 0.5 pada SizedBox.",
  ),
];
