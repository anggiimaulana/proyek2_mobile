import 'package:flutter/material.dart';

Color bannerColor = const Color(0xffc4d1da);
Color fbackgroundColor1 = const Color(0xffe7e8ea);
Color fbackgroundColor2 = const Color(0xfff4f4f4);
Color fbackgroundColor3 = const Color(0xFF6495ED);
Color fbackgroundColor4 = const Color(0xFF6495ED);

Color getStatusColor(String status) {
  switch (status) {
    case 'Diserahkan':
      return Colors.amber.shade100;
    case 'Diproses':
      return Colors.lightBlue.shade100;
    case 'Ditolak':
      return Colors.red.shade100;
    case 'Disetujui':
      return Colors.green.shade100;
    case 'Direvisi':
      return Colors.orange.shade100;
    default:
      return Colors.grey;
  }
}

Color getTextStatusColor(String status) {
  switch (status) {
    case 'Diserahkan':
      return Colors.orange;
    case 'Diproses':
      return Colors.lightBlue;
    case 'Ditolak':
      return Colors.red;
    case 'Disetujui':
      return Colors.green;
    case 'Direvisi':
      return Colors.orange;
    default:
      return Colors.grey;
  }
}

Color getAksiColor(String aksi) {
  return aksi == 'Menunggu'
      ? const Color.fromARGB(255, 98, 174, 209)
      : Colors.blue;
}
