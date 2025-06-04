import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:proyek2/provider/pengajuan/data/data_provider2.dart';
import 'package:proyek2/provider/pengajuan/edit/sku_edit_provider.dart';
import 'package:proyek2/provider/pengajuan/kartu_keluarga_provider.dart';
import 'package:proyek2/provider/pengajuan/tracking_surat_provider.dart';
import 'package:proyek2/style/colors.dart';

class SkuEditScreen extends StatefulWidget {
  final int detailId;
  final dynamic kategoriPengajuan;
  final String? pengajuanId;
  final String? catatan;

  const SkuEditScreen({
    super.key,
    this.kategoriPengajuan,
    required this.detailId,
    this.pengajuanId,
    this.catatan,
  });

  @override
  State<SkuEditScreen> createState() => _SkuEditScreenState();
}

class _SkuEditScreenState extends State<SkuEditScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  bool _isLoadingData = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadInitialData);
  }

  Future<void> _loadInitialData() async {
    try {
      await Provider.of<DataProvider>(context, listen: false)
          .loadAllAndCacheData();

      final kkProvider =
          Provider.of<KartuKeluargaProvider>(context, listen: false);
      await kkProvider.loadFromCache();
      if (kkProvider.data == null) {
        await kkProvider.fetchAndCacheKK();
      }

      await _loadSkuData();
    } catch (e) {
      debugPrint('Error loading initial data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingData = false;
        });
      }
    }
  }

  Future<void> _loadSkuData() async {
    final provider = Provider.of<SkuEditProvider>(context, listen: false);
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final kkProvider =
        Provider.of<KartuKeluargaProvider>(context, listen: false);

    try {
      final skuData = await provider.fetchSkuById(widget.detailId.toString());

      if (skuData != null) {
        provider.fillFormWithExistingData(
          skuData: skuData,
          jkList: dataProvider.jenisKelaminList,
          pekerjaanList: dataProvider.pekerjaanList,
          statusList: dataProvider.statusPerkawinanList,
          hubunganList: dataProvider.hubunganList,
          nikList: kkProvider.data?.anggota, // Tambahkan ini
        );
      }
    } catch (e) {
      debugPrint('Error loading SKU data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading SKU data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer4<SkuEditProvider, DataProvider, KartuKeluargaProvider,
        TrackingSuratProvider>(
      builder:
          (context, provider, dataProvider, kkProvider, trackingProvider, _) =>
              Scaffold(
        backgroundColor: const Color(0xFFF1F5FF),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Edit Surat Keterangan Usaha',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
          ),
          backgroundColor: fbackgroundColor3,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: _isLoadingData
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'Silahkan perbaiki data yang diperlukan dengan teliti!',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black54),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (widget.catatan != null &&
                            widget.catatan!.isNotEmpty) ...[
                          buildLabel('Catatan Perbaikan', isRequired: false),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              border: Border.all(color: Colors.red.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              widget.catatan!,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        // Perbaikan untuk NIK dropdown di SkuEditScreen
                        buildLabel('NIK', isRequired: true),
                        buildDropdownDynamic(
                          selectedValue: provider.selectedNikId,
                          onChanged: (value) {
                            // PERBAIKAN: Pastikan value ter-set dengan benar
                            debugPrint('NIK dropdown changed: $value');
                            provider.setSelectedNikId(value);

                            // Optional: Auto-fill data lain berdasarkan NIK yang dipilih
                            if (value != null &&
                                kkProvider.data?.anggota != null) {
                              final selectedAnggota =
                                  kkProvider.data!.anggota.firstWhere(
                                (anggota) => anggota.id == value,
                                orElse: () => kkProvider.data!.anggota.first,
                              );

                              // Auto-fill beberapa field berdasarkan data KK
                              provider.namaController.text =
                                  selectedAnggota.name;
                              provider.alamatController.text =
                                  selectedAnggota.alamat;
                              provider.tempatLahirController.text =
                                  selectedAnggota.tempatLahir;

                              // Set tanggal lahir
                              try {
                                final date = DateTime.parse(
                                    selectedAnggota.tanggalLahir);
                                provider.selectedDate = date;
                                provider.tanggalLahirController.text =
                                    DateFormat('yyyy-MM-dd').format(date);
                              } catch (e) {
                                debugPrint('Error parsing birth date: $e');
                              }

                              // Set dropdown values
                              provider.setSelectedHubunganId(
                                  selectedAnggota.hubungan);
                              provider.setSelectedKelaminId(selectedAnggota.jk);
                              provider.setSelectedPekerjaanId(
                                  selectedAnggota.pekerjaan);
                              provider
                                  .setSelectedStatusId(selectedAnggota.status);
                            }
                          },
                          items: kkProvider.data?.anggota
                                  .map((e) => DropdownMenuItem(
                                        value: e.id,
                                        child: Text(
                                          '${e.nomorNik} - ${e.name}',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ))
                                  .toList() ??
                              [],
                          isEnabled: true,
                        ),
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
                          isEnabled: true,
                        ),
                        buildLabel('Nama Lengkap', isRequired: true),
                        buildTextField(
                          'Nama lengkap',
                          provider.namaController,
                          isEnabled: true,
                        ),
                        buildLabel('Tempat Lahir', isRequired: true),
                        buildTextField(
                          'Tempat lahir',
                          provider.tempatLahirController,
                          isEnabled: true,
                        ),
                        buildLabel('Tanggal Lahir', isRequired: true),
                        GestureDetector(
                          onTap: () => provider.selectDate(context),
                          child: AbsorbPointer(
                            child: buildTextField(
                              'Tanggal lahir',
                              provider.tanggalLahirController,
                              isEnabled: true,
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
                          isEnabled: true,
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
                          isEnabled: true,
                        ),
                        buildLabel('Status Perkawinan', isRequired: true),
                        buildDropdownDynamic(
                          selectedValue: provider.selectedStatusId,
                          onChanged: provider.setSelectedStatusId,
                          items: dataProvider.statusPerkawinanList
                              .map((e) => DropdownMenuItem(
                                    value: e.id,
                                    child: Text(e.statusPerkawinan),
                                  ))
                              .toList(),
                          isEnabled: true,
                        ),
                        buildLabel('Nama Usaha', isRequired: true),
                        buildTextField(
                          'Nama usaha',
                          provider.namaUsahaController,
                          isEnabled: true,
                        ),
                        buildLabel('Alamat', isRequired: true),
                        buildTextField(
                          'Alamat',
                          provider.alamatController,
                          maxLines: 3,
                          isEnabled: true,
                        ),
                        buildLabel('Upload Kartu Tanda Penduduk (Baru)',
                            isRequired: true),
                        GestureDetector(
                          onTap: () => provider.pickKKFile(context),
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
                                    provider.selectedFileName ??
                                        'Pilih file KTP baru...',
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
                                ? null
                                : () async {
                                    // Debug: Print semua nilai sebelum validasi form
                                    print('=== PRE-SUBMIT DEBUG ===');
                                    print(
                                        'Form valid: ${_formKey.currentState?.validate()}');
                                    print(
                                        'selectedNikId: ${provider.selectedNikId}');
                                    print(
                                        'selectedHubunganId: ${provider.selectedHubunganId}');
                                    print(
                                        'selectedKelaminId: ${provider.selectedKelaminId}');
                                    print(
                                        'selectedPekerjaanId: ${provider.selectedPekerjaanId}');
                                    print(
                                        'selectedStatusId: ${provider.selectedStatusId}');
                                    print(
                                        'namaController: "${provider.namaController.text}"');
                                    print(
                                        'tempatLahirController: "${provider.tempatLahirController.text}"');
                                    print(
                                        'tanggalLahirController: "${provider.tanggalLahirController.text}"');
                                    print(
                                        'alamatController: "${provider.alamatController.text}"');
                                    print(
                                        'namaUsaha: "${provider.namaUsahaController.text}"');
                                    print(
                                        'selectedFile: ${provider.selectedFile?.name}');

                                    // Validasi form terlebih dahulu
                                    if (!_formKey.currentState!.validate()) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Mohon lengkapi semua field yang wajib diisi'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }

                                    // Validasi manual untuk dropdown yang mungkin tidak ter-handle oleh form validation
                                    List<String> missingFields = [];

                                    if (provider.selectedNikId == null) {
                                      missingFields.add('NIK');
                                    }
                                    if (provider.selectedHubunganId == null) {
                                      missingFields
                                          .add('Status dalam Keluarga');
                                    }
                                    if (provider.selectedKelaminId == null) {
                                      missingFields.add('Jenis Kelamin');
                                    }
                                    if (provider.selectedPekerjaanId == null) {
                                      missingFields.add('Pekerjaan');
                                    }
                                    if (provider.selectedStatusId == null) {
                                      missingFields.add('Status Perkawinan');
                                    }

                                    if (missingFields.isNotEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Field berikut belum dipilih: ${missingFields.join(', ')}'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }

                                    if (provider.selectedFile == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('File KTP harus dipilih'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }

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
                                                    'Memperbarui data, mohon tunggu...')),
                                          ],
                                        ),
                                      ),
                                    );

                                    try {
                                      final result = await provider.updateForm(
                                          context, widget.detailId.toString());

                                      if (mounted) {
                                        Navigator.of(context)
                                            .pop(); // tutup dialog

                                        if (result == 1) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Pengajuan berhasil diperbarui!'),
                                                backgroundColor: Colors.green),
                                          );
                                          Navigator.pop(context);
                                          await trackingProvider.refreshData();
                                        }
                                      }
                                    } catch (e) {
                                      if (mounted) {
                                        Navigator.of(context)
                                            .pop(); // tutup dialog
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Error: ${e.toString()}'),
                                              backgroundColor: Colors.red),
                                        );
                                      }
                                    } finally {
                                      if (mounted) {
                                        setState(() {
                                          _isSubmitting = false;
                                        });
                                      }
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: fbackgroundColor4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: _isSubmitting
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text(
                                    'Perbarui Pengajuan',
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
    bool isEnabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        enabled: isEnabled,
        style: const TextStyle(fontSize: 16),
        validator: (v) {
          if (v == null || v.trim().isEmpty) {
            print('TextField validation failed for hint: $hint - value: "$v"');
            return 'Wajib diisi';
          }
          print('TextField validation passed for hint: $hint - value: "$v"');
          return null;
        },
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
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 2),
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
    bool isEnabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<int>(
        value: selectedValue,
        isExpanded: true,
        onChanged: isEnabled ? onChanged : null,
        validator: (v) {
          if (v == null) {
            print('Dropdown validation failed - value is null');
            return 'Wajib dipilih';
          }
          print('Dropdown validation passed - value: $v');
          return null;
        },
        decoration: InputDecoration(
          filled: !isEnabled,
          fillColor: isEnabled ? Colors.white : Colors.grey.shade100,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isEnabled ? Colors.grey.shade300 : Colors.grey.shade400,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(12),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        items: items.map((e) {
          return DropdownMenuItem<int>(
            value: e.value,
            child: DefaultTextStyle(
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: isEnabled ? Colors.black87 : Colors.grey.shade600,
                fontSize: 16,
              ),
              child: e.child,
            ),
          );
        }).toList(),
        hint: const Text(
          'Pilih salah satu',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.normal,
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
