import 'package:hive/hive.dart';

part 'data_kk_hive_model.g.dart';

@HiveType(typeId: 1)
class NikHive extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String nomorNik;

  @HiveField(2)
  String tempatLahir;

  @HiveField(3)
  String tanggalLahir;

  @HiveField(4)
  int jk;

  @HiveField(5)
  int hubungan;

  @HiveField(6)
  int status;

  @HiveField(7)
  int agama;

  @HiveField(8)
  String alamat;

  @HiveField(9)
  int pendidikan;

  @HiveField(10)
  int pekerjaan;

  @HiveField(11)
  int id;

  NikHive({
    required this.id,
    required this.name,
    required this.nomorNik,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.jk,
    required this.hubungan,
    required this.status,
    required this.agama,
    required this.alamat,
    required this.pendidikan,
    required this.pekerjaan,
  });
}

@HiveType(typeId: 2)
class KartuKeluargaHive extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String nomorKk;

  @HiveField(2)
  String kepalaKeluarga;

  @HiveField(3)
  List<NikHive> anggota;

  KartuKeluargaHive({
    required this.id,
    required this.nomorKk,
    required this.kepalaKeluarga,
    required this.anggota,
  });
}
