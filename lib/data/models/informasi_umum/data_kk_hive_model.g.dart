// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_kk_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NikHiveAdapter extends TypeAdapter<NikHive> {
  @override
  final int typeId = 1;

  @override
  NikHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NikHive(
      id: fields[11] as int,
      name: fields[0] as String,
      nomorNik: fields[1] as String,
      tempatLahir: fields[2] as String,
      tanggalLahir: fields[3] as String,
      jk: fields[4] as int,
      hubungan: fields[5] as int,
      status: fields[6] as int,
      agama: fields[7] as int,
      alamat: fields[8] as String,
      pendidikan: fields[9] as int,
      pekerjaan: fields[10] as int,
    );
  }

  @override
  void write(BinaryWriter writer, NikHive obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.nomorNik)
      ..writeByte(2)
      ..write(obj.tempatLahir)
      ..writeByte(3)
      ..write(obj.tanggalLahir)
      ..writeByte(4)
      ..write(obj.jk)
      ..writeByte(5)
      ..write(obj.hubungan)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.agama)
      ..writeByte(8)
      ..write(obj.alamat)
      ..writeByte(9)
      ..write(obj.pendidikan)
      ..writeByte(10)
      ..write(obj.pekerjaan)
      ..writeByte(11)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NikHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class KartuKeluargaHiveAdapter extends TypeAdapter<KartuKeluargaHive> {
  @override
  final int typeId = 2;

  @override
  KartuKeluargaHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return KartuKeluargaHive(
      id: fields[0] as int,
      nomorKk: fields[1] as String,
      kepalaKeluarga: fields[2] as String,
      anggota: (fields[3] as List).cast<NikHive>(),
    );
  }

  @override
  void write(BinaryWriter writer, KartuKeluargaHive obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nomorKk)
      ..writeByte(2)
      ..write(obj.kepalaKeluarga)
      ..writeByte(3)
      ..write(obj.anggota);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KartuKeluargaHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
