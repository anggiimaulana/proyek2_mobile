import 'package:flutter/material.dart';
import 'package:proyek2/data/api/api_services.dart';
import 'package:proyek2/screen/home/header_home.dart';
import 'package:proyek2/style/colors.dart';
import 'package:proyek2/screen/home/berita_home_widget.dart';
import 'package:proyek2/screen/home/fitur_utama.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyek2/data/models/pengguna/client/client_detail.dart';

class AppHomeScreen extends StatefulWidget {
  const AppHomeScreen({super.key});

  @override
  State<AppHomeScreen> createState() => _AppHomeScreenState();
}

class _AppHomeScreenState extends State<AppHomeScreen> {
  String? _userName;
  bool _isLoading = true;
  String? _errorMessage;
  final ApiServices _apiServices = ApiServices();

  @override
  void initState() {
    _fetchUserData();
    super.initState();
  }

  Future<void> _fetchUserData() async {
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
        return;
      }

      final clientId = prefs.getInt('id');
      if (clientId != null) {
        try {
          final ClientDetail userDetail =
              await _apiServices.getDetailUser(clientId);
          if (mounted) {
            setState(() {
              _userName = userDetail.data.name;
              _isLoading = false;
            });
          }
        } catch (e) {
          if (mounted) {
            setState(() {
              _errorMessage = "Gagal memuat data: ${e.toString()}";
              _isLoading = false;
            });
          }
          print("Error fetching user details: $e");
        }
      } else {
        final savedName = prefs.getString('name');
        if (mounted) {
          setState(() {
            _userName = savedName ?? 'Pengguna';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "Terjadi kesalahan: ${e.toString()}";
          _isLoading = false;
        });
      }
      print("Error in _fetchUserData: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _fetchUserData,
                  child: Text("Coba Lagi"),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5FF),
      body: RefreshIndicator(
        onRefresh: _fetchUserData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              MyHeader(
                name: _userName != null
                    ? (_userName!.length > 6
                        ? _userName!.substring(0, 6)
                        : _userName!)
                    : 'Pengguna',
              ),
              const SizedBox(height: 150), // FIXED height
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  children: [
                    Text(
                      "Fitur Utama",
                      style: TextStyle(
                        color: fbackgroundColor4,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const FiturUtama(),
              const SizedBox(height: 20), // FIXED height
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Berita Desa Terkini",
                      style: TextStyle(
                        color: fbackgroundColor4,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const BeritaHome(),
              const SizedBox(height: 20), // FIXED height
            ],
          ),
        ),
      ),
    );
  }
}
