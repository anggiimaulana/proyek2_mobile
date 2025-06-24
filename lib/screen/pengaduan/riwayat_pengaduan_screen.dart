import 'package:flutter/material.dart';
import 'package:proyek2/data/api/api_services.dart';
import 'package:proyek2/data/models/pengaduan/pengaduan.dart';
import 'package:proyek2/style/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RiwayatPengaduanPage extends StatefulWidget {
  const RiwayatPengaduanPage({super.key});

  @override
  State<RiwayatPengaduanPage> createState() => _RiwayatPengaduanPageState();
}

class _RiwayatPengaduanPageState extends State<RiwayatPengaduanPage> {
  final ScrollController _scrollController = ScrollController();
  List<Datum> _pengaduanList = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  int _currentPage = 1;
  String? _userId;
  String _selectedStatus = 'Semua';
  final List<String> _statusOptions = [
    'Semua',
    'Menunggu',
    'Diproses',
    'Selesai'
  ];

  @override
  void initState() {
    super.initState();
    _initializeUser();
    _setupScrollListener();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      // Trigger pagination ketika user scroll mendekati bottom
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (_hasMoreData && !_isLoading && !_isLoadingMore) {
          _loadMorePengaduan();
        }
      }
    });
  }

  Future<void> _initializeUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('client_id')?.toString();
      if (userId == null) throw Exception('User belum login');

      setState(() {
        _userId = userId;
      });

      await _loadPengaduan(refresh: true);
    } catch (e) {
      _showErrorDialog('Error: ${e.toString()}');
    }
  }

  Future<void> _loadPengaduan({bool refresh = false}) async {
    if (_userId == null) return;

    // Jika refresh, reset pagination
    if (refresh) {
      setState(() {
        _currentPage = 1;
        _pengaduanList.clear();
        _hasMoreData = true;
        _isLoading = true;
      });
    } else {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      const urlApi = ApiServices.baseUrl;
      String baseUrl = '$urlApi/pengaduan/$_userId';

      Map<String, String> queryParams = {
        'client_id': _userId!,
        'page': _currentPage.toString(),
        'per_page': '10', // Limit per halaman
      };

      if (_selectedStatus != 'Semua' && _selectedStatus.isNotEmpty) {
        String apiStatus = _convertStatusForApi(_selectedStatus);
        queryParams['status'] = apiStatus;
      }

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
      print('Requesting: ${uri.toString()}');

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? prefs.getString('access_token');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
      ).timeout(const Duration(seconds: 30)); // Timeout 30 detik

      print('Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse is Map<String, dynamic>) {
          final pengaduan = Pengaduan.fromJson(jsonResponse);

          if (!pengaduan.error) {
            setState(() {
              if (refresh) {
                _pengaduanList = pengaduan.data.data;
              } else {
                _pengaduanList.addAll(pengaduan.data.data);
              }
              _hasMoreData = pengaduan.data.hasMorePages;
              if (pengaduan.data.data.isNotEmpty) {
                _currentPage++;
              }
            });

            print('Data loaded: ${pengaduan.data.data.length} items');
          } else {
            _showErrorDialog(pengaduan.message);
          }
        } else {
          _showErrorDialog('Format response tidak valid dari server');
        }
      } else {
        String errorMessage =
            _getErrorMessage(response.statusCode, response.reasonPhrase ?? '');
        _showErrorDialog(errorMessage);

        if (response.statusCode == 401) {
          _redirectToLogin();
        }
      }
    } catch (e) {
      print('Exception: $e');
      String errorMessage = 'Network Error';
      if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Koneksi timeout. Periksa koneksi internet Anda.';
      } else if (e.toString().contains('SocketException')) {
        errorMessage =
            'Tidak dapat terhubung ke server. Periksa koneksi internet.';
      } else {
        errorMessage = 'Error: ${e.toString()}';
      }

      _showErrorDialog(errorMessage);
    } finally {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _loadMorePengaduan() async {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });

    await _loadPengaduan();
  }

  String _getErrorMessage(int statusCode, String reasonPhrase) {
    switch (statusCode) {
      case 401:
        return 'Unauthorized. Silakan login ulang.';
      case 403:
        return 'Akses ditolak. Anda tidak memiliki izin.';
      case 404:
        return 'Endpoint tidak ditemukan. Periksa URL API.';
      case 500:
        return 'Server error. Hubungi administrator.';
      case 502:
        return 'Bad Gateway. Server sedang maintenance.';
      case 503:
        return 'Service Unavailable. Coba lagi nanti.';
      default:
        return 'HTTP $statusCode: $reasonPhrase';
    }
  }

  String _convertStatusForApi(String displayStatus) {
    switch (displayStatus.toLowerCase()) {
      case 'menunggu':
        return 'pending';
      case 'diproses':
        return 'processing';
      case 'selesai':
        return 'completed';
      default:
        return displayStatus.toLowerCase();
    }
  }

  String _convertStatusFromApi(String apiStatus) {
    switch (apiStatus.toLowerCase()) {
      case 'pending':
        return 'Menunggu';
      case 'processing':
        return 'Diproses';
      case 'completed':
        return 'Selesai';
      default:
        return apiStatus;
    }
  }

  Future<void> _onRefresh() async {
    await _loadPengaduan(refresh: true);
  }

  void _onFilterChanged(String status) {
    print('Filter selected: $status');
    setState(() {
      _selectedStatus = status;
    });
    _loadPengaduan(refresh: true);
  }

  void _clearFilter() {
    print('Clearing filter');
    setState(() {
      _selectedStatus = 'Semua';
    });
    _loadPengaduan(refresh: true);
  }

  void _showErrorDialog(String message) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
          if (message.contains('login'))
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _redirectToLogin();
              },
              child: const Text('Login'),
            ),
        ],
      ),
    );
  }

  void _redirectToLogin() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('token');
      prefs.remove('access_token');
      prefs.remove('client_id');
    });

    Navigator.pushReplacementNamed(context, '/login');
  }

  Color _getStatusColor(String status) {
    String normalizedStatus = status.toLowerCase();
    switch (normalizedStatus) {
      case 'menunggu':
      case 'pending':
        return Colors.orange;
      case 'diproses':
      case 'processing':
        return Colors.blue;
      case 'selesai':
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5FF),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Riwayat Pengaduan',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        backgroundColor: fbackgroundColor4,
        elevation: 2,
        actions: [
          //
        ],
      ),
      body: _userId == null
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Memuat data user...'),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _onRefresh,
              color: const Color(0xFF6495ED),
              child: Column(
                children: [
                  // Status Filter Indicator
                  if (_selectedStatus != 'Semua') ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      color: Colors.blue.shade50,
                      child: Row(
                        children: [
                          Icon(Icons.filter_list, color: Colors.blue, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Filter: $_selectedStatus',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${_pengaduanList.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: _clearFilter,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.blue,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                  ],

                  // Main Content
                  Expanded(
                    child: _buildContent(),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildContent() {
    if (_isLoading && _pengaduanList.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Memuat data pengaduan...'),
          ],
        ),
      );
    }

    if (_pengaduanList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _selectedStatus == 'Semua'
                  ? 'Belum ada pengaduan'
                  : 'Tidak ada pengaduan dengan status $_selectedStatus',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Tarik ke bawah untuk memuat ulang',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _pengaduanList.length + (_hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        // Loading indicator untuk pagination
        if (index == _pengaduanList.length) {
          return _buildLoadingIndicator();
        }

        final pengaduan = _pengaduanList[index];
        return _buildPengaduanCard(pengaduan);
      },
    );
  }

  Widget _buildLoadingIndicator() {
    if (!_hasMoreData) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (_isLoadingMore) ...[
            const CircularProgressIndicator(),
            const SizedBox(height: 8),
            Text(
              'Memuat lebih banyak...',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ] else ...[
            ElevatedButton(
              onPressed: _loadMorePengaduan,
              child: const Text('Muat Lebih Banyak'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPengaduanCard(Datum pengaduan) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigasi ke detail pengaduan
          // Navigator.pushNamed(context, '/detail-pengaduan', arguments: pengaduan);
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 248, 246, 246),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header dengan ID dan Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 16,
                          color: fbackgroundColor4,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Urutan Laporan: ${pengaduan.id}',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: fbackgroundColor4),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color:
                            _getStatusColor(pengaduan.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _getStatusColor(pengaduan.status),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        _convertStatusFromApi(pengaduan.status),
                        style: TextStyle(
                          color: _getStatusColor(pengaduan.status),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Kategori & Jenis Layanan
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        'Kategori',
                        pengaduan.kategori,
                        Icons.category_outlined,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInfoItem(
                        'Jenis Layanan',
                        pengaduan.jenisLayanan,
                        Icons.build_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Keluhan
                _buildInfoItem(
                  'Keluhan',
                  pengaduan.keluhan,
                  Icons.report_problem_outlined,
                  maxLines: 2,
                ),
                const SizedBox(height: 12),

                // Footer dengan Lokasi dan Tanggal
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              pengaduan.lokasi,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(pengaduan.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    String label,
    String value,
    IconData icon, {
    int? maxLines,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          maxLines: maxLines,
          overflow: maxLines != null ? TextOverflow.ellipsis : null,
        ),
      ],
    );
  }
}

// Custom RefreshController - sebenarnya tidak diperlukan karena menggunakan RefreshIndicator built-in
// Bisa dihapus jika tidak digunakan untuk custom implementation
