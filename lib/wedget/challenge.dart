

// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

Widget BoxChallenge() {
  return Column(
    children: [
      Row(
        children: [
          Image.asset('assets/icons/icon_cap.png', width: 16),
          SizedBox(width: 4),
          Text('Challenge', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700))
        ]
      ),
      Container()
    ]
  );
}