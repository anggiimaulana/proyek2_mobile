import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:proyek2/data/api/api_services.dart';
import 'package:proyek2/style/colors.dart';

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final TextEditingController nikSearchController = TextEditingController();
  final TextEditingController nikPengajuanController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController ttlController = TextEditingController();
  final TextEditingController pekerjaanController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController noHpController = TextEditingController();

  final urlBansos = ApiServices.urlBansos;

  String? selectedJenisKelamin;
  String? selectedAgama;
  String? selectedJenisPelayanan;
  String nomorPermohonan = "";

  PlatformFile? ktpFile;
  PlatformFile? kkFile;
  PlatformFile? depanRumahFile;
  PlatformFile? kamarMandiFile;
  PlatformFile? ruangTamuFile;
  PlatformFile? dapurFile;
  PlatformFile? suratFile;

  final List<String> jenisKelaminList = ["Laki-laki", "Perempuan"];
  final List<String> agamaList = [
    "Islam",
    "Kristen",
    "Katolik",
    "Hindu",
    "Buddha",
    "Konghucu"
  ];
  final List<String> jenisPelayananList = [
    "Keluarga Harapan",
    "Bantuan Pangan Non Tunai"
  ];

  @override
  void initState() {
    super.initState();
    generateRandomCode();
  }

  void generateRandomCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    setState(() {
      nomorPermohonan =
          List.generate(10, (index) => chars[rand.nextInt(chars.length)])
              .join();
    });
  }

  Future<void> fetchDataByNIK() async {
    final nik = nikSearchController.text.trim();
    if (nik.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Masukkan NIK terlebih dahulu")));
      return;
    }

    final url = Uri.parse("$urlBansos/get_warga.php?nik=$nik");
    final response = await http.get(url);

    if (response.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Server error: ${response.statusCode}")));
      return;
    }

    try {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        final d = data['data'];
        setState(() {
          nikPengajuanController.text = d['nik'];
          namaController.text = d['nama'];
          ttlController.text = d['ttl'];
          pekerjaanController.text = d['pekerjaan'];
          alamatController.text = d['alamat'];
          noHpController.text = d['no_hp'];
          selectedJenisKelamin = d['jenis_kelamin'];
          selectedAgama = d['agama'];
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Data ditemukan")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? "Data tidak ditemukan")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Gagal parsing data: $e")));
    }
  }

  void pickFile(Function(PlatformFile) onFilePicked) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;

      if (kIsWeb) {
        final bytes = file.bytes;
        print("File size: ${bytes?.lengthInBytes}");

        if (bytes != null) {
          onFilePicked(file);
        }
      } else {
        final path = file.path;
        print("File path: $path");

        if (path != null) {
          onFilePicked(file);
        }
      }
    } else {
      print("No file selected");
    }
  }

  Future<void> saveData({
    required String nomorPermohonan,
    required TextEditingController nikPengajuanController,
    required TextEditingController namaController,
    required TextEditingController ttlController,
    required String? selectedJenisKelamin,
    required String? selectedAgama,
    required TextEditingController pekerjaanController,
    required TextEditingController alamatController,
    required String? selectedJenisPelayanan,
    required TextEditingController noHpController,
    required PlatformFile? kkFile,
    required PlatformFile? ktpFile,
    required PlatformFile? depanRumahFile,
    required PlatformFile? kamarMandiFile,
    required PlatformFile? ruangTamuFile,
    required PlatformFile? dapurFile,
    required PlatformFile? suratFile,
  }) async {
    try {
      var uri = Uri.parse('$urlBansos/save_data.php');
      var request = http.MultipartRequest('POST', uri);

      request.fields['nomor_permohonan'] = nomorPermohonan;
      request.fields['nik'] = nikPengajuanController.text;
      request.fields['nama'] = namaController.text;
      request.fields['ttl'] = ttlController.text;
      request.fields['jenis_kelamin'] = selectedJenisKelamin ?? '';
      request.fields['agama'] = selectedAgama ?? '';
      request.fields['pekerjaan'] = pekerjaanController.text;
      request.fields['alamat'] = alamatController.text;
      request.fields['jenis_pelayanan'] = selectedJenisPelayanan ?? '';
      request.fields['no_hp'] = noHpController.text;

      Future<void> attachFile(String fieldName, PlatformFile? file) async {
        if (file != null) {
          if (kIsWeb) {
            if (file.bytes != null) {
              request.files.add(http.MultipartFile.fromBytes(
                fieldName,
                file.bytes!,
                filename: file.name,
              ));
            }
          } else {
            if (file.path != null) {
              request.files.add(await http.MultipartFile.fromPath(
                fieldName,
                file.path!,
                filename: file.name,
              ));
            }
          }
        }
      }

      await attachFile('foto_kk', kkFile);
      await attachFile('foto_ktp', ktpFile);
      await attachFile('foto_depan', depanRumahFile);
      await attachFile('foto_k_mandi', kamarMandiFile);
      await attachFile('foto_r_tamu', ruangTamuFile);
      await attachFile('foto_dapur', dapurFile);
      await attachFile('surat_t_mampu', suratFile);

      var response = await request.send();

      print('Response status code: ${response.statusCode}');
      var responseData = await response.stream.bytesToString();
      print('Response body: $responseData');

      if (response.statusCode == 200) {
        try {
          var jsonResponse = jsonDecode(responseData);

          if (jsonResponse['success'] == true) {
            print('Data berhasil disimpan');
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Data berhasil disimpan")));
          } else {
            print('Gagal menyimpan data: ${jsonResponse['message']}');
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text("Gagal menyimpan data: ${jsonResponse['message']}")));
          }
        } catch (e) {
          print("Error parsing JSON: $e");
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Terjadi kesalahan pada server.")));
        }
      } else {
        print('Gagal mengirim data: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "Gagal mengirim data, status code: ${response.statusCode}")));
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Terjadi kesalahan: $e")));
    }
  }

  Widget buildNotice() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.red.shade700),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "*Permohonan akan kami proses pada hari kerja",
                style: TextStyle(
                    color: Colors.red.shade700, fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      );

  Widget buildPersyaratan() => Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.orange.shade700),
                const SizedBox(width: 8),
                Text(
                  "Persyaratan Dokumen",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...const [
              "1. Foto KK",
              "2. Foto E-KTP",
              "3. Foto Depan Rumah",
              "4. Foto Kamar Mandi",
              "5. Foto Ruang Tamu",
              "6. Foto Dapur",
              "7. Foto Surat Keterangan Tidak Mampu"
            ]
                .map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_outline,
                              size: 16, color: Colors.orange.shade700),
                          const SizedBox(width: 8),
                          Text(item, style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ))
                .toList(),
          ],
        ),
      );

  Widget buildFileUpload(String label, PlatformFile? file,
          Function() onPickFile, IconData icon) =>
      Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: InkWell(
          onTap: onPickFile,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: file != null
                        ? Colors.green.shade50
                        : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    file != null ? Icons.check_circle : icon,
                    color: file != null ? Colors.green : Colors.blue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        file != null ? file.name : 'Tap untuk memilih file',
                        style: TextStyle(
                          fontSize: 12,
                          color: file != null
                              ? Colors.green.shade700
                              : Colors.grey.shade600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.cloud_upload_outlined,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      );

  Widget buildFileUploadSection() => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.attach_file, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(
                  "Upload Dokumen Persyaratan",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Pastikan file yang diupload jelas dan dapat dibaca",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),
            buildFileUpload(
                "Foto KTP",
                ktpFile,
                () => pickFile((file) => setState(() => ktpFile = file)),
                Icons.credit_card),
            buildFileUpload(
                "Foto Kartu Keluarga",
                kkFile,
                () => pickFile((file) => setState(() => kkFile = file)),
                Icons.people),
            buildFileUpload(
                "Foto Depan Rumah",
                depanRumahFile,
                () => pickFile((file) => setState(() => depanRumahFile = file)),
                Icons.home),
            buildFileUpload(
                "Foto Kamar Mandi",
                kamarMandiFile,
                () => pickFile((file) => setState(() => kamarMandiFile = file)),
                Icons.bathroom),
            buildFileUpload(
                "Foto Ruang Tamu",
                ruangTamuFile,
                () => pickFile((file) => setState(() => ruangTamuFile = file)),
                Icons.weekend),
            buildFileUpload(
                "Foto Dapur",
                dapurFile,
                () => pickFile((file) => setState(() => dapurFile = file)),
                Icons.kitchen),
            buildFileUpload(
                "Surat Keterangan Tidak Mampu",
                suratFile,
                () => pickFile((file) => setState(() => suratFile = file)),
                Icons.description),
          ],
        ),
      );

  Widget buildTextField(String label, TextEditingController controller) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label:",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue.shade400, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      );

  Widget buildDropdownField(String label, List<String> items,
          String? selectedItem, Function(String?) onChanged) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label:",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: selectedItem,
            onChanged: onChanged,
            items: items
                .map((value) =>
                    DropdownMenuItem<String>(value: value, child: Text(value)))
                .toList(),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue.shade400, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      );

  Widget buildButtons() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Batal",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                await saveData(
                  nomorPermohonan: nomorPermohonan,
                  nikPengajuanController: nikPengajuanController,
                  namaController: namaController,
                  ttlController: ttlController,
                  selectedJenisKelamin: selectedJenisKelamin,
                  selectedAgama: selectedAgama,
                  pekerjaanController: pekerjaanController,
                  alamatController: alamatController,
                  selectedJenisPelayanan: selectedJenisPelayanan,
                  noHpController: noHpController,
                  kkFile: kkFile,
                  ktpFile: ktpFile,
                  depanRumahFile: depanRumahFile,
                  kamarMandiFile: kamarMandiFile,
                  ruangTamuFile: ruangTamuFile,
                  dapurFile: dapurFile,
                  suratFile: suratFile,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
              ),
              child: const Text(
                'Simpan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Formulir Pengajuan Bansos",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
        ),
        backgroundColor: fbackgroundColor4,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildNotice(),
            const SizedBox(height: 20),

            // Section pencarian NIK
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.search, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      Text(
                        "Pencarian Data",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                      "NIK (untuk pencarian data)", nikSearchController),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: fetchDataByNIK,
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 22,
                      ),
                      label: const Text(
                        "Cari Data",
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Section form data
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      Text(
                        "Data Pemohon",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  buildTextField("NIK", nikPengajuanController),
                  buildTextField("Nama", namaController),
                  buildTextField("Tempat/Tanggal Lahir (Cirebon, 15/03/03)",
                      ttlController),
                  buildDropdownField(
                      "Jenis Kelamin",
                      jenisKelaminList,
                      selectedJenisKelamin,
                      (val) => setState(() => selectedJenisKelamin = val)),
                  buildDropdownField("Agama", agamaList, selectedAgama,
                      (val) => setState(() => selectedAgama = val)),
                  buildTextField("Pekerjaan", pekerjaanController),
                  buildTextField("Alamat", alamatController),
                  buildDropdownField(
                      "Jenis Pelayanan",
                      jenisPelayananList,
                      selectedJenisPelayanan,
                      (val) => setState(() => selectedJenisPelayanan = val)),
                  buildTextField("No. HP", noHpController),
                ],
              ),
            ),

            if (selectedJenisPelayanan != null) ...[
              const SizedBox(height: 20),
              buildPersyaratan(),
              buildFileUploadSection(),
            ],

            const SizedBox(height: 30),
            buildButtons(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
