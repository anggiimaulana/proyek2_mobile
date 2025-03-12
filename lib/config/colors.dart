import 'package:flutter/material.dart';

Color bannerColor = const Color(0xffc4d1da);
Color fbackgroundColor1 = const Color(0xffe7e8ea);
Color fbackgroundColor2 = const Color(0xfff4f4f4);
Color fbackgroundColor3 = const Color(0xFF6495ED);
Color fbackgroundColor4 = const Color(0xFF6495ED);

Color getStatusColor(String status) {
  switch (status) {
    case 'Diserahkan':
      return Colors.amber;
    case 'Diproses':
      return Colors.lightBlue;
    case 'Ditolak':
      return Colors.red;
    case 'Disetujui':
      return Colors.green;
    default:
      return Colors.grey;
  }
}

Color getAksiColor(String aksi) {
  return aksi == 'Menunggu'
      ? const Color.fromARGB(255, 98, 174, 209)
      : Colors.blue;
}
