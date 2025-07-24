import 'package:flutter/material.dart';

class DefaultHead extends StatelessWidget {
  final String title;
  final String description;
  const DefaultHead({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(fontSize: 20, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}
