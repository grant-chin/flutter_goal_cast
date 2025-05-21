// ignore_for_file: non_constant_identifier_names

import 'dart:math';

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
  bool _loading = true;
  bool _start = false;
  bool _spining = false;

  // 开始游戏
  _startGame() {
    setState(() => _loading = true);
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() => _start = true);
    });
    Future.delayed(Duration(milliseconds: 2000), () {
      setState(() => _loading = false);
    });
  }

  // 抽取次数
  _onSpin() {
    setState(() => _spining = true);
    Future.delayed(Duration(milliseconds: 2000), () {
      setState(() => _spining = false);
    });
  }

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
        child: Stack(
          children: [
            Column(
              children: [
                NavBar(),
                _start ? MainBox() : FlashBox()
              ],
            ),
            Loading()
          ],
        ),
      )
    );
  }
  
  Widget NavBar() {
    return Container(
      height: 56 + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 16, right: 16),
      color: _start ? Color(0xFF070123) : Colors.transparent,
      child: Row(
        crossAxisAlignment: _start ? CrossAxisAlignment.center : CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 36,
              height: 36,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: _start ? Colors.transparent : Colors.white30,
                borderRadius: BorderRadius.circular(32)
              ),
              child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 14),
            )
          ),
          SizedBox(width: 8),
          _start ? Text('Kick clash', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)) : Container()
        ],
      ),
    );
  }
  
  Widget FlashBox() {
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
        Positioned(bottom: MediaQuery.of(context).padding.bottom + 32, child: PrimaryBtn(text: 'Free start (3)', width: MediaQuery.of(context).size.width - 32, func: _startGame)),
      ],
    );
  }
  Widget MainBox() {
    return Expanded(child: Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Positioned(top: 0, child: Image.asset('assets/images/game1/bg_park.png', width: MediaQuery.of(context).size.width)),
        Positioned(top: 24, child: Image.asset('assets/images/game1/bg_score.png', height: 48)),
        Positioned(top: 150, child: Image.asset('assets/images/game1/football_net.png', height: 200)),
        Positioned(top: 370, child: Image.asset('assets/images/game1/football.png', height: 56)),
        Positioned(
          top: MediaQuery.of(context).size.height - 380,
          child: Container(
            width: 1100,
            height: 1100,
            decoration: BoxDecoration(
              color: Color(0xFF070123),
              borderRadius: BorderRadius.circular(1100),
              image: DecorationImage(image: AssetImage('assets/images/game1/bg_wheel.png'), fit: BoxFit.cover)
            ),
            child: _spining ? Spin(child: SpinWheel()) : SpinWheel()
          )
        ),
        Positioned(bottom: MediaQuery.of(context).padding.bottom + 32, child: PrimaryBtn(text: 'Spin', width: MediaQuery.of(context).size.width - 32, func: _onSpin)),
      ],
    ));
  }
  Widget SpinWheel() {
    return Stack(
      alignment: Alignment.center,
      children: List.generate(20, (index) => Positioned(
        child: Image.asset('assets/images/game1/spin_${index+1}.png', height: 1076 * cos(9 * index / 180 * pi).abs() + 74 * sin(9 * index / 180 * pi).abs())
      ))
    );
  }

  Widget Loading() {
    return Positioned(child: _loading ? Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/game1/bg1.png'), fit: BoxFit.cover)
      ),
      child: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 238,
            right: -40,
            child: FadeInLeftBig(
              duration: Duration(milliseconds: 500),
              child: SlideInUp(
                duration: Duration(milliseconds: 500),
                child: Stack(
                  children: [
                    Image.asset('assets/images/game1/bg_red.png', width: 500),
                    Positioned(
                      bottom: 70,
                      left: 120,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Color(0xFFE70C0C), width: 2),
                          borderRadius: BorderRadius.circular(80)
                        ),
                      )
                    )
                  ],
                )
              )
            )
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 82,
            left: -40,
            child: FadeInRightBig(
              duration: Duration(milliseconds: 500),
              child: SlideInDown(
                duration: Duration(milliseconds: 500),
                child: Image.asset('assets/images/game1/bg_blue.png', width: 500)
              )
            )
          ),
        ],
      ),
    ) : Container());
  }
}