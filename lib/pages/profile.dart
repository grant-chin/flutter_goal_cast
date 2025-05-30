// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_goal_cast/controller/user.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  int get _level => UserController.level.value;
  String get _nickname => UserController.nickname.value;
  String get _point => UserController.pointStr.value;
  int get _xp => UserController.xp.value;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Positioned(child: Container(color: Color(0xFF070123))),
          Positioned(child: Image.asset('assets/images/bg/profile_bg.png')),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AccountInfo(),
                SizedBox(height: 32),
                AccountData(),
                SizedBox(height: 36),
                Text('Settings', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                SizedBox(height: 12),
                linkItem('Contact us', (){
                  launchUrl(Uri.parse(''));
                }),
                linkItem('Privacy Policy', (){
                  // launchUrl(Uri.parse('https://sites.google.com/view/script-canvas/terms-and-conditions'));
                }),
                linkItem('Terms of service', (){
                  // launchUrl(Uri.parse('https://sites.google.com/view/script-canvas/terms-and-conditions'));
                }),
                SizedBox(
                  height: 54,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('About', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
                      Text('v1.0.0', style: TextStyle(color: Colors.white30, fontSize: 12, fontWeight: FontWeight.w500)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      )
    );
  }

  Widget AccountInfo() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 48),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/avator.png')),
              borderRadius: BorderRadius.circular(12)
            ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
            decoration: BoxDecoration(
              color: Color.fromRGBO(1, 255, 247, 0.25),
              border: Border.all(color: Color(0xFF01FFF7)),
              borderRadius: BorderRadius.circular(8)
            ),
            child: Obx(() => Text('Lvl.$_level', style: TextStyle(color: Color(0xFF01FFF7), fontSize: 14, fontWeight: FontWeight.w500))),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SizedBox(width: 32),
              Obx(() => Text(_nickname, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500))),
              // SizedBox(width: 8),
              // Icon(Icons.create_outlined, color: Colors.white60, size: 22)
            ],
          )
        ],
      )
    );
  }

  Widget AccountData() {
    return Row(
      spacing: 16,
      children: [
        Expanded(child: Container(
        height: 76,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/images/bg/box_data.png'))
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/icons/bets.png', width: 32),
              SizedBox(height: 4),
              Obx(() => Text(_point, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)))
            ],
          ),
        )),
        Expanded(child: Container(
          height: 76,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/images/bg/box_data.png'))
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/icons/exp.png', width: 32),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() => Text('$_xp', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500))),
                  Text(' / 500', style: TextStyle(color: Colors.white30, fontSize: 16, fontWeight: FontWeight.w500)),
                ]
              )
            ],
          ),
        )),
      ],
    );
  }

  Widget linkItem(text, func) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(0),
          backgroundColor: Colors.transparent,
          overlayColor: Colors.white10,
          shadowColor: Colors.transparent,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(0)
          )
        ),
        onPressed: func,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
            Icon(Icons.arrow_forward_ios_rounded, color: Colors.white60)
          ],
        ),
      ),
    );
  }
}