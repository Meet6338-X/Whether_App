import 'package:flutter/material.dart';

class cardwhethercast extends StatelessWidget {
  final String time;
  final String temperature;
  final IconData icon;
  const cardwhethercast(
      {super.key,
      required this.time,
      required this.temperature,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 100,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Text(
              '$time',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Icon(
              icon,
              size: 32,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              '$temperature',
            ),
            //   style: TextStyle(
            //       fontSize: 16, fontWeight: FontWeight.w400),
            // ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
