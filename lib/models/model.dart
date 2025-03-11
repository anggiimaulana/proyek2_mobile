class AppModel {
  final String name, image, description;
  bool isCheck;

  AppModel(
      {required this.name,
      required this.image,
      required this.description,
      required this.isCheck});
}

List<AppModel> beritaHome = [
  // id: 1
  AppModel(
    name: "Wong Plered Top 5 Dutpol",
    image: "assets/images/erwan.jpg",
    description:
        "Tetap pakai kode ini di berita_home.dart supaya gambar hanya ditampilkan di sini:",
    isCheck: false,
  ),
  // id: 2
  AppModel(
    name: "Masyarakat Ikut Serta Belajar Figma",
    image: "assets/images/figma.jpg",
    description:
        "Kalau gambarnya jadi dua, kemungkinan besar CurratedItems juga menampilkan gambar selain dari BeritaHome.",
    isCheck: false,
  ),
  // id: 3
  AppModel(
    name: "Bulak Lor - Desa Digital",
    image: "assets/images/bulak-lor.jpg",
    description:
        "Ya, kemungkinan besar deskripsi tidak full karena ukuran width: size.width * 0.5 pada SizedBox, ditambah dengan padding left: 10. Solusinya adalah memperbesar width agar lebih mendekati lebar kontainer utama.",
    isCheck: false,
  ),
];

const myDescription1 = "Elevate your casual wardobe with you";
const myDescription2 =
    "Crafted from premium cotton for maximum comfort, this relaxed-fit tee feature";
