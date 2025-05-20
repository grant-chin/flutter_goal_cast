

// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      SizedBox(height: 12),
      Column(
        spacing: 8,
        children: [
          GestureDetector(
            onTap: () => Get.toNamed('/kick_clash'),
            child: Image.asset('assets/images/bg/bg_kick_clash.png')
          ),
          GestureDetector(
            onTap: () => Get.toNamed('/shot_daily'),
            child: Image.asset('assets/images/bg/bg_shot_daily.png')
          ),
        ],
      )
    ]
  );
}