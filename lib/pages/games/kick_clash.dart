// ignore_for_file: non_constant_identifier_names

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_goal_cast/wedget/primary_btn.dart';
import 'package:get/get.dart';

class KickClash extends StatefulWidget {
  const KickClash({super.key});

  @override
  State<KickClash> createState() => KickClashState();
}

class KickClashState extends State<KickClash> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Color(0xFF070123),
          image: DecorationImage(image: AssetImage('assets/images/game1/bg_park.png'), fit: BoxFit.cover)
        ),
        child: Column(
          children: [
            NavBar(),
            ContentBox()
          ],
        ),
      )
    );
  }
  
  Widget NavBar() {
    return Container(
      height: 56,
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(32)
              ),
              padding: EdgeInsets.all(4),
              child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 14),
            )
          ),
          SizedBox(width: 8),
          // Text('Kick clash', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
  
  Widget ContentBox() {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 56 - MediaQuery.of(context).padding.top,
        ),
        Positioned(top: 0, child: ElasticIn(delay: Duration(milliseconds: 1100), child: Image.asset('assets/images/game1/title.png', width: 200))),
        Positioned(top: 180, child: FadeInRightBig(duration: Duration(milliseconds: 500), child: Image.asset('assets/images/game1/football_net.png', height: 300))),
        Positioned(top: 520, child: FadeInLeftBig(duration: Duration(milliseconds: 1050), child: SpinPerfect(child: Image.asset('assets/images/game1/football.png', height: 56)))),
        Positioned(bottom: MediaQuery.of(context).padding.bottom + 32, child: PrimaryBtn(text: 'Free start (3)', width: MediaQuery.of(context).size.width - 32, func: (){}))
      ],
    );
  }
}