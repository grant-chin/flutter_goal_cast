// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

Widget PrimaryBtn({ double? width, required String text, child, func }) {
  return Container(
    width: width,
    height: 54,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFBE71FD), Color(0xFF8033D1)],
        stops: [0, 1], // 调整渐变范围
      ),
      borderRadius: BorderRadius.circular(8)
    ),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(0),
        foregroundColor: Colors.white,
        disabledForegroundColor: Colors.white60,
        backgroundColor: Colors.transparent,
        disabledBackgroundColor: Color(0xFF170C34),
        shadowColor: Colors.transparent,
        overlayColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: func,
      child: child ?? Text(text, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700))
    )
  );
}