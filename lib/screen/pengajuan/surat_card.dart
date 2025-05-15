import 'package:flutter/material.dart';

class SuratCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconPath;
  final String colorHex;

  const SuratCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconPath,
    required this.colorHex,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor = Color(int.parse("0xFF$colorHex"));

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5FF),
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Image.asset(
                iconPath,
                width: 60,
                height: 60,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  subtitle,
                  style: const TextStyle(color: Colors.black54),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Colors.black45,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
