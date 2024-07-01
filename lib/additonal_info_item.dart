import 'package:flutter/material.dart';

class additioninfoitem extends StatelessWidget {
  final IconData icon;
  final String label;
  final double value;
  additioninfoitem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 34,
        ),
        Text(
          label,
          style: TextStyle(fontSize: 16),
        ),
        Text(
          '$value',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
