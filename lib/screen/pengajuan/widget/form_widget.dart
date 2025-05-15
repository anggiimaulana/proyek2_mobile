// import 'package:flutter/material.dart';

// Widget buildDropdown({
//   required List<String> items,
//   required String? selectedValue,
//   required String hint,
//   required void Function(String?) onChanged,
// }) {
//   return DropdownButtonFormField<String>(
//     value: selectedValue,
//     isExpanded: true,
//     style: const TextStyle(
//       fontSize: 16,
//       fontWeight: FontWeight.normal,
//       color: Colors.black,
//     ),
//     decoration: InputDecoration(
//       contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       enabledBorder: OutlineInputBorder(
//         borderSide: BorderSide(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(12),
//       ),
//     ),
//     hint: Text(
//       hint,
//       style: const TextStyle(
//         fontWeight: FontWeight.normal,
//         color: Colors.grey,
//         fontSize: 16,
//       ),
//     ),
//     items: items.isEmpty
//         ? [
//             const DropdownMenuItem(
//               value: null,
//               child: Text('Memuat...'),
//             )
//           ]
//         : items.map((item) {
//             return DropdownMenuItem<String>(
//               value: item,
//               child: Container(
//                 alignment: Alignment.centerLeft,
//                 child: Text(item),
//               ),
//             );
//           }).toList(),
//     onChanged: items.isEmpty ? null : onChanged,
//     validator: (value) {
//       if (value == null || value.isEmpty) {
//         return 'Harap pilih salah satu';
//       }
//       return null;
//     },
//     dropdownColor: const Color(0xFFF1F5FF),
//     iconEnabledColor: Colors.black,
//     iconDisabledColor: Colors.grey,
//   );
// }

// Widget buildLabel(String text, {bool isRequired = false}) {
//   return Padding(
//     padding: const EdgeInsets.only(top: 12, bottom: 4),
//     child: RichText(
//       text: TextSpan(
//         text: text,
//         style: const TextStyle(
//             color: Colors.blue, fontWeight: FontWeight.w600, fontSize: 16),
//         children: isRequired
//             ? [
//                 const TextSpan(
//                   text: ' *',
//                   style: TextStyle(color: Colors.red),
//                 )
//               ]
//             : [],
//       ),
//     ),
//   );
// }
