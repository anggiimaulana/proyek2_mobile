import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:proyek2/provider/pengajuan/data/data_provider2.dart';
import 'package:proyek2/provider/pengajuan/kartu_keluarga_provider.dart';
import 'package:proyek2/provider/pengajuan/create/sktm_listrik_create_provider.dart';
import 'package:proyek2/style/colors.dart';

class SktmListrikScreen extends StatefulWidget {
  const SktmListrikScreen({super.key});

  @override
  State<SktmListrikScreen> createState() => _SktmListrikScreenState();
}

class _SktmListrikScreenState extends State<SktmListrikScreen> {
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
    return Consumer3<SktmListrikCreateProvider, DataProvider,
        KartuKeluargaProvider>(
      builder: (context, provider, dataProvider, kkProvider, _) => Scaffold(
        backgroundColor: const Color(0xFFF1F5FF),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'SKTM - Listrik',
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
                      ? const Center(child: ModernLoadingWidget())
                      : buildDropdownNIK(dataProvider, provider, kkProvider),
                  buildLabel('Status dalam Keluarga', isRequired: true),
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
                  buildLabel('Nama Lengkap', isRequired: true),
                  buildTextField(
                      'Masukkan nama lengkap', provider.namaController),
                  buildLabel('Umur', isRequired: true),
                  buildTextField(
                    'Masukkan umur',
                    provider.umurController,
                    keyboardType: TextInputType.number,
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
                  buildLabel('Pekerjaan', isRequired: true),
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
                  buildLabel('Penghasilan', isRequired: true),
                  buildDropdownDynamic(
                    selectedValue: provider.selectedPenghasilanId,
                    onChanged: provider.setSelectedPenghasilanId,
                    items: dataProvider.penghasilanList
                        .map((e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(e.rentangPenghasilan),
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
                  buildLabel('Nama PLN', isRequired: true),
                  buildTextField(
                      'Masukkan nama PLN', provider.namaPlnController),
                  buildLabel('Upload Kartu Keluarga', isRequired: true),
                  GestureDetector(
                    onTap: () => provider.pickFile(context),
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
                                builder: (_) => const ModernLoadingDialog(),
                              );

                              try {
                                final result =
                                    await provider.submitForm(context);
                                Navigator.of(context).pop(); // tutup dialog
                                if (result == 1) {
                                  if (context.mounted) {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (_) =>
                                          const ModernSuccessDialog(),
                                    );
                                    await Future.delayed(
                                        const Duration(seconds: 2));
                                    Navigator.of(context).pop();
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
      SktmListrikCreateProvider provider, KartuKeluargaProvider kkProvider) {
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
        value: provider.selectedNikIndex,
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
            provider.setSelectedNik(value, selectedAnggota.id, selectedAnggota,
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
            color: Colors.grey,
            fontWeight: FontWeight.normal,
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

/// Widget loading modern (putar animasi + text)
class ModernLoadingDialog extends StatelessWidget {
  const ModernLoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      content: Row(
        children: [
          const ModernLoadingWidget(),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mengirim data...',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: fbackgroundColor4,
                        fontSize: 16)),
                const SizedBox(height: 6),
                Text(
                  'Mohon tunggu sebentar, data sedang diproses.',
                  style: TextStyle(color: fbackgroundColor4.withOpacity(0.8)),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget loading circle modern
class ModernLoadingWidget extends StatelessWidget {
  const ModernLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: CircularProgressIndicator(
        strokeWidth: 4,
        valueColor: AlwaysStoppedAnimation<Color>(fbackgroundColor4),
        backgroundColor: fbackgroundColor4.withOpacity(0.15),
      ),
    );
  }
}

/// Widget loading untuk tombol
class ModernBtnLoading extends StatelessWidget {
  const ModernBtnLoading({super.key});
  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'Mengirim...',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}

/// Dialog selesai modern
class ModernSuccessDialog extends StatelessWidget {
  const ModernSuccessDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      backgroundColor: Colors.white,
      content: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: fbackgroundColor4.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(
              Icons.check_circle_rounded,
              color: fbackgroundColor4,
              size: 38,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              "Pengajuan berhasil dikirim!",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: fbackgroundColor4,
                  fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
