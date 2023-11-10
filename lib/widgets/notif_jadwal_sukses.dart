import 'package:flutter/material.dart';

class NotifJadwalSukses extends StatelessWidget {
  const NotifJadwalSukses({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.all(0),
      width: 393,
      height: 32,
      decoration: const BoxDecoration(
        color: Color(0xffeeddbb),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.zero,
      ),
      child: const Align(
        alignment: Alignment.center,
        child: Text(
          "Jurnal dari jadwal ini sudah diisi",
          textAlign: TextAlign.start,
          overflow: TextOverflow.clip,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 10,
            color: Color(0xff53b175),
          ),
        ),
      ),
    );
  }
}
