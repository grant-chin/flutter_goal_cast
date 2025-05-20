// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShotDaily extends StatefulWidget {
  const ShotDaily({super.key});

  @override
  State<ShotDaily> createState() => ShotDailyState();
}

class ShotDailyState extends State<ShotDaily> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/game2/bg.png'), fit: BoxFit.cover)
        ),
        child: Column(
          children: [
            NavBar(),
            MachineBox(),
            ConbinationBox(),
            FooterBtn()
          ],
        ),
      ),
    );
  }

  Widget NavBar() {
    return Container(
      height: 56,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 26,
              height: 26,
              color: Colors.transparent,
              padding: EdgeInsets.all(4),
              child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 14),
            )
          ),
          SizedBox(width: 8),
          Text('Shot daily', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
  
  Widget MachineBox() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Image.asset('assets/images/game2/shot_machine.png')
    );
  }
  
  Widget ConbinationBox() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Image.asset('assets/images/game2/title_combination.png'),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color.fromRGBO(18, 7, 47, 0.72),
              border: Border.all(color: Color(0xFF38295E)),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8))
            ),
            child: Column(
              spacing: 8,
              children: [
                ConbinationItem(),
                ConbinationItem(),
                ConbinationItem(),
                ConbinationItem(),
                ConbinationItem(),
                ConbinationItem(),
              ],
            ),
          )
        ],
      ),
    );
  }
  Widget ConbinationItem() {
    return Container(
      height: 32 * MediaQuery.of(context).size.width / 402,
      padding: EdgeInsets.only(left: 8, right: 16),
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/game2/box_default.png'))
      ),
      child: Row(
        children: [
          Row(
            spacing: 12,
            children: [
              CircleItem(),
              CircleItem(),
              CircleItem(),
              CircleItem(),
              CircleItem(),
            ],
          ),
          Spacer(),
          Image.asset('assets/icons/bets.png', width: 16),
          SizedBox(width: 5),
          Text('10', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w700))
        ],
      )
    );
  }
  Widget CircleItem() {
    return Container(
      width: 16,
      height: 16,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white30,
        borderRadius: BorderRadius.circular(16)
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF38295E),
          borderRadius: BorderRadius.circular(12)
        ),
      )
    );
  }

  Widget FooterBtn() {
    return Container();
  }
}