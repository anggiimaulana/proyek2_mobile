import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:proyek2/style/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyek2/data/api/api_services.dart';

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashWidth = 8.0;
    const dashSpace = 4.0;
    const radius = 12.0;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(radius),
      ));

    final pathMetrics = path.computeMetrics().toList();
    for (final pathMetric in pathMetrics) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        final nextDistance = distance + dashWidth;
        final extractPath = pathMetric.extractPath(
          distance,
          nextDistance > pathMetric.length ? pathMetric.length : nextDistance,
        );
        canvas.drawPath(extractPath, paint);
        distance = nextDistance + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class FormLingkungan extends StatefulWidget {
  @override
  _FormLingkunganState createState() => _FormLingkunganState();
}

class _FormLingkunganState extends State<FormLingkungan> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _keluhanController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();

  File? _selectedImage;
  String? _selectedKategori;
  bool _isLoading = false;
  final String _jenisLayanan = 'Lingkungan'; // otomatis "Lingkungan"
  final List<String> _kategoriOptions = [
    'Kebersihan',
    'Sampah',
    'Pertanian',
    'Penghijauan',
    'Air Limbah',
    'Lainnya'
  ];

  final urlPengaduan = ApiServices.baseUrl;
  final Dio _dio = Dio();

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan upload gambar terlebih dahulu.')),
      );
      return;
    }

    // Set loading state
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Anda belum login, silakan login terlebih dahulu.')),
      );
      return;
    }

    try {
      FormData formData = FormData.fromMap({
        'nama': _namaController.text,
        'jenis_layanan': _jenisLayanan,
        'keluhan': _keluhanController.text,
        'lokasi': _lokasiController.text,
        'kategori': _selectedKategori,
        'gambar': await MultipartFile.fromFile(
          _selectedImage!.path,
          filename: 'upload.jpg',
        ),
      });

      final response = await _dio.post(
        '$urlPengaduan/pengaduan',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Laporan berhasil dikirim!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengirim: ${response.statusMessage}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5FF),
      body: Stack(
        children: [
          Column(
            children: [
              // Header bagian atas dengan background biru
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 50, bottom: 20),
                decoration: const BoxDecoration(
                  color: Color(0xFF6495ED),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Pengaduan Lingkungan',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Kartu informasi
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child:Row(
                          children: [
                            Icon(Icons.description, size: 40, color: fbackgroundColor4,),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Laporkan Keluhan?',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: fbackgroundColor4,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Form ini diperuntukkan untuk pengaduan Lingkungan seperti TPS liar, pencemaran air, kebakaran lahan, binatang liar, dll.',
                                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Expanded form scrollable
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Form Pengaduan Lingkungan',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: fbackgroundColor4,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Nama Field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nama Lengkap',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: fbackgroundColor4,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _namaController,
                              decoration: InputDecoration(
                                hintText: 'Masukkan nama lengkap Anda',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                filled: true,
                                fillColor: Colors.grey[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF6495ED),
                                    width: 2,
                                  ),
                                ),
                                prefixIcon: const Icon(
                                  Icons.person_outline,
                                  color: Color(0xFF6495ED),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Nama wajib diisi'
                                      : null,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Jenis Layanan Field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Jenis Layanan',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: fbackgroundColor4,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.eco_outlined,
                                    color: Color(0xFF6495ED),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    _jenisLayanan,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: fbackgroundColor4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Kategori Field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kategori Keluhan',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: fbackgroundColor4,
                              ),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: _selectedKategori,
                              decoration: InputDecoration(
                                hintText: 'Pilih kategori keluhan',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                filled: true,
                                fillColor: Colors.grey[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF6495ED),
                                    width: 2,
                                  ),
                                ),
                                prefixIcon: const Icon(
                                  Icons.category_outlined,
                                  color: Color(0xFF6495ED),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _selectedKategori = value;
                                });
                              },
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Kategori wajib dipilih'
                                      : null,
                              items: _kategoriOptions.map((kategori) {
                                return DropdownMenuItem(
                                  value: kategori,
                                  child: Text(kategori),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Keluhan Field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Deskripsi Keluhan',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: fbackgroundColor4,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _keluhanController,
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText:
                                    'Jelaskan keluhan Anda secara detail...',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                filled: true,
                                fillColor: Colors.grey[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF6495ED),
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.all(16),
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Keluhan wajib diisi'
                                      : null,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Lokasi Field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lokasi Kejadian',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: fbackgroundColor4,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _lokasiController,
                              decoration: InputDecoration(
                                hintText: 'Masukkan alamat lengkap lokasi',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                filled: true,
                                fillColor: Colors.grey[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF6495ED),
                                    width: 2,
                                  ),
                                ),
                                prefixIcon: const Icon(
                                  Icons.location_on_outlined,
                                  color: Color(0xFF6495ED),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Lokasi wajib diisi'
                                      : null,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Upload Gambar Section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Foto Bukti',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: fbackgroundColor4,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: _pickImage,
                              child: _selectedImage != null
                                  ? Container(
                                      height: 180,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Image.file(
                                              _selectedImage!,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                            ),
                                          ),
                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: const Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : CustomPaint(
                                      painter: DashedBorderPainter(),
                                      child: Container(
                                        height: 180,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[50],
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.cloud_upload_outlined,
                                              size: 48,
                                              color: Colors.grey[400],
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              'Tap untuk upload foto',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Format: JPG, PNG (Max 100MB)',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Tombol lapor di bawah
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isLoading ? Colors.grey[400] : const Color(0xFF6495ED),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: _isLoading ? 0 : 2,
                  ),
                  child: _isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Mengirim...',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      : const Text(
                          'Lapor',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ),

          // Loading Overlay
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF6495ED),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Mengirim Laporan...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF34495E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Mohon tunggu sebentar',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
