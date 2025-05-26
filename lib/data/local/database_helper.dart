// import 'dart:convert';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// class DatabaseHelper {
//   static final DatabaseHelper instance = DatabaseHelper._internal();
//   factory DatabaseHelper() => instance;
//   DatabaseHelper._internal();

//   static Database? _database;

//   Future<Database> get database async {
//     _database ??= await _initDatabase();
//     return _database!;
//   }

//   Future<Database> _initDatabase() async {
//     final path = join(await getDatabasesPath(), 'master_data.db');
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _onCreate,
//     );
//   }

//   Future _onCreate(Database db, int version) async {
//     await db.execute('''
//     CREATE TABLE agama(id INTEGER PRIMARY KEY, nama_agama TEXT)
//   ''');

//     await db.execute('''
//     CREATE TABLE hubungan(id INTEGER PRIMARY KEY, jenis_hubungan TEXT)
//   ''');

//     await db.execute('''
//     CREATE TABLE jenis_kelamin(id INTEGER PRIMARY KEY, jenis_kelamin TEXT)
//   ''');

//     await db.execute('''
//     CREATE TABLE kategori_pengajuan(id INTEGER PRIMARY KEY, nama_kategori TEXT)
//   ''');

//     await db.execute('''
//     CREATE TABLE pekerjaan(id INTEGER PRIMARY KEY, nama_pekerjaan TEXT)
//   ''');

//     await db.execute('''
//     CREATE TABLE pendidikan(id INTEGER PRIMARY KEY, jenis_pendidikan TEXT)
//   ''');

//     await db.execute('''
//     CREATE TABLE penghasilan(id INTEGER PRIMARY KEY, rentang_pendapatan TEXT)
//   ''');

//     await db.execute('''
//     CREATE TABLE status_perkawinan(id INTEGER PRIMARY KEY, status TEXT)
//   ''');

//     await db.execute('''
//     CREATE TABLE status_pengajuan(id INTEGER PRIMARY KEY, status_pengajuan TEXT)
//   ''');
//   }

//   Future<void> insertData(
//       String table, List<Map<String, dynamic>> dataList) async {
//     final db = await database;
//     final batch = db.batch();
//     await db.delete(table); // Clear old data

//     for (var item in dataList) {
//       batch.insert(table, item);
//     }

//     await batch.commit(noResult: true);
//   }

//   Future<List<Map<String, dynamic>>> getData(String table) async {
//     final db = await database;
//     return await db.query(table);
//   }

//   // Getter untuk data dari SQLite
//   Future<List<Map<String, dynamic>>> getAgamaList() => getData("agama");

//   Future<List<Map<String, dynamic>>> getPekerjaanList() => getData("pekerjaan");

//   Future<List<Map<String, dynamic>>> getHubunganList() => getData("hubungan");

//   Future<List<Map<String, dynamic>>> getJenisKelaminList() =>
//       getData("jenis_kelamin");

//   Future<List<Map<String, dynamic>>> getKategoriPengajuanList() =>
//       getData("kategori_pengajuan");

//   Future<List<Map<String, dynamic>>> getPenghasilanList() =>
//       getData("penghasilan");

//   Future<List<Map<String, dynamic>>> getStatusPerkawinanList() =>
//       getData("status_perkawinan");

//   Future<List<Map<String, dynamic>>> getStatusPengajuanList() =>
//       getData("status_pengajuan");

//   Future<List<Map<String, dynamic>>> getRentangPendapatanList() =>
//       getData("penghasilan");

//   Future<List<Map<String, dynamic>>> getPendidikanList() =>
//       getData("pendidikan");
// }
