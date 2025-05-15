import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:proyek2/provider/pengajuan/data/data_provider.dart';
import 'package:proyek2/provider/pengajuan/sktm_sekolah_provider.dart';
import 'package:proyek2/style/colors.dart';

class SktmSekolahScreen extends StatefulWidget {
  const SktmSekolahScreen({super.key});

  @override
  State<SktmSekolahScreen> createState() => _SktmSekolahScreenState();
}

class _SktmSekolahScreenState extends State<SktmSekolahScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<DataProvider>(context, listen: false)
        .loadAllAndCacheData());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<SktmSekolahProvider, DataProvider>(
      builder: (context, provider, dataProvider, _) => Scaffold(
        backgroundColor: const Color(0xFFF1F5FF),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'SKTM - Sekolah',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
          ),
          backgroundColor: fbackgroundColor3,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Silahkan cek dan lengkapi data yang diperlukan dengan teliti!',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  buildLabel('Hubungan pemilik akun dengan Pengaju',
                      isRequired: true),
                  buildDropdownDynamic(
                    selectedValue: provider.selectedHubunganId,
                    onChanged: provider.setSelectedHubunganId,
                    items: dataProvider.hubunganList
                        .map((e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(e.jenisHubungan),
                            ))
                        .toList(),
                  ),
                  buildLabel('Nama Lengkap Orang Tua', isRequired: true),
                  buildTextField('Masukkan nama lengkap orang tua',
                      provider.namaOrtuController),
                  buildLabel('Tempat Lahir Orang Tua', isRequired: true),
                  buildTextField(
                      'Masukkan tempat lahir', provider.tempatLahirOrtuController),
                  buildLabel('Tanggal Lahir Orang Tua', isRequired: true),
                  GestureDetector(
                    onTap: () => provider.selectDateOrtu(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: provider.tanggalLahirOrtuController,
                        decoration: InputDecoration(
                          hintText: 'Pilih tanggal lahir',
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                  buildLabel('Agama', isRequired: true),
                  buildDropdownDynamic(
                    selectedValue: provider.selectedAgamaId,
                    onChanged: provider.setSelectedAgamaId,
                    items: dataProvider.agamaList
                        .map((e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(e.namaAgama),
                            ))
                        .toList(),
                  ),
                  buildLabel('Pekerjaan Orang Tua', isRequired: true),
                  buildDropdownDynamic(
                    selectedValue: provider.selectedPekerjaanId,
                    onChanged: provider.setSelectedPekerjaanId,
                    items: dataProvider.pekerjaanList
                        .map((e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(e.namaPekerjaan),
                            ))
                        .toList(),
                  ),
                  buildLabel('Alamat', isRequired: true),
                  buildTextField(
                    'Masukkan alamat lengkap',
                    provider.alamatController,
                    maxLines: 3,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9\s,.\/-]')),
                    ],
                  ),
                  buildLabel('Nama Lengkap Anak', isRequired: true),
                  buildTextField('Masukkan nama lengkap anak',
                      provider.namaAnakController),
                  buildLabel('Tempat Lahir Anak', isRequired: true),
                  buildTextField(
                      'Masukkan tempat lahir', provider.tempatLahirAnakController),
                  buildLabel('Tanggal Lahir Anak', isRequired: true),
                  GestureDetector(
                    onTap: () => provider.selectDateAnak(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: provider.tanggalLahirAnakController,
                        decoration: InputDecoration(
                          hintText: 'Pilih tanggal lahir',
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                  buildLabel('Jenis Kelamin', isRequired: true),
                  buildDropdownDynamic(
                    selectedValue: provider.selectedKelaminId,
                    onChanged: provider.setSelectedKelaminId,
                    items: dataProvider.jenisKelaminList
                        .map((e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(e.jenisKelamin),
                            ))
                        .toList(),
                  ),
                  buildLabel('Nama Sekolah', isRequired: true),
                  buildTextField('Masukkan nama sekolah',
                      provider.namaSekolahController),
                  buildLabel('Kelas', isRequired: true),
                  buildTextField('Masukkan kelas anak di sekolah',
                      provider.kelasAnakController),
                  buildLabel('Upload KK', isRequired: true),
                  GestureDetector(
                    onTap: () => provider.pickKKFile(),
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Iconsax.gallery, color: Colors.blue),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              provider.selectedFileName ?? 'Pilih file KK...',
                              style: const TextStyle(
                                  color: Colors.black54, fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isSubmitting
                          ? null // Disable button if submitting
                          : () async {
                              if (!_formKey.currentState!.validate()) return;

                              setState(() {
                                _isSubmitting = true;
                              });

                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => const AlertDialog(
                                  content: Row(
                                    children: [
                                      CircularProgressIndicator(),
                                      SizedBox(width: 20),
                                      Expanded(
                                          child: Text(
                                              'Mengirim data... Mohon tunggu.')),
                                    ],
                                  ),
                                ),
                              );

                              try {
                                final result =
                                    await provider.submitForm(context);
                                Navigator.of(context).pop(); // tutup dialog
                                if (result == 1) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Pengajuan berhasil dikirim!')),
                                    );
                                    Navigator.pop(context);
                                    // Reset form after submission
                                    provider.resetForm();
                                  }
                                }
                              } catch (e) {
                                Navigator.of(context).pop(); // tutup dialog
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Error: ${e.toString()}')),
                                );
                              } finally {
                                setState(() {
                                  _isSubmitting =
                                      false; // Set submitting flag back to false
                                });
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: fbackgroundColor4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isSubmitting
                          ? const CircularProgressIndicator(
                              color: Colors.white) // Show loading indicator
                          : const Text(
                              'Ajukan',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: const TextStyle(fontSize: 16),
        validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget buildDropdownDynamic({
    required int? selectedValue,
    required Function(int?) onChanged,
    required List<DropdownMenuItem<int>> items,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<int>(
        value: selectedValue,
        isExpanded: true,
        hint: const Text(
          'Pilih salah satu',
          style: TextStyle(
            color: Colors.grey, // sama seperti kode 2
            fontWeight: FontWeight.normal, // disamakan
          ),
        ),
        items: items.map((e) {
          return DropdownMenuItem<int>(
            value: e.value,
            child: DefaultTextStyle(
              style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.black87,
                  fontSize: 16),
              child: e.child,
            ),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (v) => v == null ? 'Wajib dipilih' : null,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String text, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: RichText(
        text: TextSpan(
          text: text,
          style: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          children: isRequired
              ? [
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  )
                ]
              : [],
        ),
      ),
    );
  }
}
