import 'package:flutter/material.dart';

class NotifVerifiedJurnal extends StatelessWidget {
  const NotifVerifiedJurnal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      padding: const EdgeInsets.all(0),
      width: MediaQuery.of(context).size.width,
      height: 32,
      decoration: const BoxDecoration(
        color: Color(0xffeeddbb),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.zero,
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 0),
        child: Text(
          "Sudah diverifikasi oleh Admin",
          textAlign: TextAlign.start,
          overflow: TextOverflow.clip,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 10,
            color: Color(0xff54b175),
          ),
        ),
      ),
    );
  }
}
