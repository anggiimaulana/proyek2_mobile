import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:proyek2/provider/pengajuan/data/data_provider2.dart';
import 'package:proyek2/provider/pengajuan/kartu_keluarga_provider.dart';
import 'package:proyek2/provider/pengajuan/sktm_beasiswa_provider.dart';
import 'package:proyek2/style/colors.dart';

class SktmBeasiswaScreen extends StatefulWidget {
  const SktmBeasiswaScreen({super.key});

  @override
  State<SktmBeasiswaScreen> createState() => _SktmBeasiswaScreenState();
}

class _SktmBeasiswaScreenState extends State<SktmBeasiswaScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // Load data provider
      Provider.of<DataProvider>(context, listen: false).loadAllAndCacheData();

      // Load KK data
      Provider.of<KartuKeluargaProvider>(context, listen: false)
          .loadFromCache();
      if (Provider.of<KartuKeluargaProvider>(context, listen: false).data ==
          null) {
        Provider.of<KartuKeluargaProvider>(context, listen: false)
            .fetchAndCacheKK();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<SktmBeasiswaProvider, DataProvider, KartuKeluargaProvider>(
      builder: (context, provider, dataProvider, kkProvider, _) => Scaffold(
        backgroundColor: const Color(0xFFF1F5FF),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'SKTM - Beasiswa',
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
                  buildLabel('NIK', isRequired: true),
                  kkProvider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : buildDropdownNIK(dataProvider, provider, kkProvider),
                  buildLabel('Status dalam Keluarga', isRequired: true),
                  buildDropdownDynamic(
                    selectedValue: provider.selectedHubunganIdCreate,
                    onChanged: provider.setSelectedHubunganIdCreate,
                    items: dataProvider.hubunganList
                        .map((e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(e.jenisHubungan),
                            ))
                        .toList(),
                  ),
                  buildLabel('Nama Lengkap Anak', isRequired: true),
                  buildTextField('Masukkan nama lengkap anak',
                      provider.namaAnakControllerCreate),
                  buildLabel('Tempat Lahir', isRequired: true),
                  buildTextField(
                      'Masukkan tempat lahir', provider.tempatLahirControllerCreate),
                  buildLabel('Tanggal Lahir', isRequired: true),
                  GestureDetector(
                    onTap: () => provider.selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: provider.tanggalLahirControllerCreate,
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
                    selectedValue: provider.selectedKelaminIdCreate,
                    onChanged: provider.setSelectedKelaminIdCreate,
                    items: dataProvider.jenisKelaminList
                        .map((e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(e.jenisKelamin),
                            ))
                        .toList(),
                  ),
                  buildLabel('Suku', isRequired: true),
                  buildTextField('Masukkan nama suku', provider.sukuControllerCreate),
                  buildLabel('Agama', isRequired: true),
                  buildDropdownDynamic(
                    selectedValue: provider.selectedAgamaIdCreate,
                    onChanged: provider.setSelectedAgamaIdCreate,
                    items: dataProvider.agamaList
                        .map((e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(e.namaAgama),
                            ))
                        .toList(),
                  ),
                  buildLabel('Pekerjaan Anak', isRequired: true),
                  buildDropdownDynamic(
                    selectedValue: provider.selectedPekerjaanAnakIdCreate,
                    onChanged: provider.setSelectedPekerjaanAnakIdCreate,
                    items: dataProvider.pekerjaanList
                        .map((e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(e.namaPekerjaan),
                            ))
                        .toList(),
                  ),
                  buildLabel('Nama Lengkap Ayah', isRequired: true),
                  buildTextField('Masukkan nama lengkap ayah',
                      provider.namaAyahControllerCreate),
                  buildLabel('Nama Lengkap Ibu', isRequired: true),
                  buildTextField(
                      'Masukkan nama lengkap ibu', provider.namaIbuControllerCreate),
                  buildLabel('Pekerjaan Orang Tua', isRequired: true),
                  buildDropdownDynamic(
                    selectedValue: provider.selectedPekerjaanOrtuIdCreate,
                    onChanged: provider.setSelectedPekerjaanOrtuIdCreate,
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
                    provider.alamatControllerCreate,
                    maxLines: 3,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9\s,.\/-]')),
                    ],
                  ),
                  buildLabel('Upload Kartu Keluarga', isRequired: true),
                  GestureDetector(
                    onTap: () => provider.pickKKFileCreate(context),
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
                              provider.selectedFileNameCreate ?? 'Pilih file KK...',
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
                                      SizedBox(width: 40),
                                      Expanded(
                                          child: Text(
                                              'Mengirim data ke server, mohon tunggu.')),
                                    ],
                                  ),
                                ),
                              );

                              try {
                                final result =
                                    await provider.submitFormCreate(context);
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
                                    provider.resetFormCreate();
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
                                  _isSubmitting = false;
                                });
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: fbackgroundColor4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
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

  Widget buildDropdownNIK(DataProvider dataProvider,
      SktmBeasiswaProvider provider, KartuKeluargaProvider kkProvider) {
    final anggotaList = kkProvider.data?.anggota ?? [];

    // Buat list item dropdown dari anggota KK
    final dropdownItems = anggotaList.asMap().entries.map((entry) {
      final index = entry.key;
      final anggota = entry.value;
      return DropdownMenuItem<int>(
        value: index,
        child: Text(
          "${anggota.nomorNik} - ${anggota.name}",
          style: const TextStyle(fontWeight: FontWeight.normal),
        ),
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<int>(
        value: provider.selectedNikIndexCreate,
        isExpanded: true,
        hint: const Text(
          'Pilih NIK dari kartu keluarga',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.normal,
          ),
        ),
        items: dropdownItems,
        onChanged: (value) {
          if (value != null && kkProvider.data != null) {
            final selectedAnggota = kkProvider.data!.anggota[value];

            // Panggil method baru untuk set data otomatis
            provider.setSelectedNikCreate(value, selectedAnggota.id, selectedAnggota,
                agamaList: dataProvider.agamaList,
                jkList: dataProvider.jenisKelaminList,
                pekerjaanList: dataProvider.pekerjaanList);
          }
        },
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
