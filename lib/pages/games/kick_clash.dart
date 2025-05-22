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
  bool _loading = false;
  bool _closeLoading = true;
  bool _start = false;
  bool _spining = false;

  // 开始游戏
  _startGame() {
    setState(() => _loading = true);
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() => _start = true);
    });
    Future.delayed(Duration(milliseconds: 2000), () {
      setState(() => _closeLoading = false);
    });
    Future.delayed(Duration(milliseconds: 2500), () {
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
    double scale =  MediaQuery.of(context).size.height / 720;
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 56 - MediaQuery.of(context).padding.top,
        ),
        Positioned(top: 0, child: ElasticIn(delay: Duration(milliseconds: 1100), child: Image.asset('assets/images/game1/title.png', width: 200))),
        Positioned(top: 100 * scale, child: FadeInRightBig(duration: Duration(milliseconds: 500), child: Image.asset('assets/images/game1/football_net.png', height: 280 * scale))),
        Positioned(top: 380 * scale, child: FadeInLeftBig(duration: Duration(milliseconds: 1050), child: SpinPerfect(child: Image.asset('assets/images/game1/football.png', height: 56 * scale)))),
        Positioned(bottom: MediaQuery.of(context).padding.bottom + 32, child: PrimaryBtn(text: 'Free start (3)', width: MediaQuery.of(context).size.width - 32, func: _startGame)),
      ],
    );
  }

  Widget MainBox() {
    double scale =  MediaQuery.of(context).size.width / 402;
    return Expanded(child: Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Positioned(top: 0, child: Image.asset('assets/images/game1/bg_park.png', width: MediaQuery.of(context).size.width)),
        ScoreBox(),
        Positioned(top: 150 * scale, child: Image.asset('assets/images/game1/football_net.png', height: 200)),
        Positioned(top: 360 * scale, child: Image.asset('assets/images/game1/football.png', height: 56 * scale)),
        Positioned(
          top: 490 * scale,
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
  Widget ScoreBox() {
    return Positioned(top: 24, child: Container(
      width: 370,
      height: 48,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/game1/bg_score.png'))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: 8,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(48),
                  image: DecorationImage(image: AssetImage('assets/images/avator.png'))
                ),
              ),
              Column(
                spacing: 6,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Thomas021', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500, height: 1)),
                  Row(
                    spacing: 8,
                    children: [
                      TurnItem(),
                      TurnItem(),
                      TurnItem(),
                    ],
                  )
                ],
              )
            ],
          ),
          Row(
            spacing: 2,
            children: [
              Text('0', style: TextStyle(color: Colors.white70, fontSize: 24, fontWeight: FontWeight.w700, fontFamily: 'Lexend')),
              Text(':', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
              Text('0', style: TextStyle(color: Colors.white70, fontSize: 24, fontWeight: FontWeight.w700, fontFamily: 'Lexend')),
            ],
          ),
          Row(
            spacing: 8,
            children: [
              Column(
                spacing: 6,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Thomas021', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500, height: 1)),
                  Row(
                    spacing: 8,
                    children: [
                      TurnItem(),
                      TurnItem(),
                      TurnItem(),
                    ],
                  )
                ],
              ),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(48),
                  image: DecorationImage(image: AssetImage('assets/images/avator_system.png'))
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
  Widget TurnItem() {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.white30,
        borderRadius: BorderRadius.circular(20)
      ),
    );
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
        alignment: Alignment.center,
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 162,
            child: Transform.rotate(angle: -15 * pi / 180, child: FadeInLeftBig(
              animate: _closeLoading,
              from: 1000,
              duration: Duration(milliseconds: 500),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset('assets/images/game1/bg_red.png', height: 160),
                  Positioned(
                    left: 120,
                    child: Container(
                      width: 80,
                      height: 80,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage('assets/images/avator.png')),
                        border: Border.all(color: Color(0xFFE70C0C), width: 2),
                        borderRadius: BorderRadius.circular(80)
                      ),
                    )
                  ),
                  Positioned(left: 234, child: PlayerNameBox(name: 'Thomas021'))
                ],
              )
            ))
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height / 2 - 162,
            child: Transform.rotate(angle: -15 * pi / 180, child: FadeInRightBig(
              animate: _closeLoading,
              from: 1000,
              duration: Duration(milliseconds: 500),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset('assets/images/game1/bg_blue.png', height: 160),
                  Positioned(
                    right: 120,
                    child: Container(
                      width: 80,
                      height: 80,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage('assets/images/avator_system.png')),
                        border: Border.all(color: Color(0xFF1165E4), width: 2),
                        borderRadius: BorderRadius.circular(80)
                      ),
                    )
                  ),
                  Positioned(right: 234, child: PlayerNameBox(name: 'System111', right: true)),
                ],
              )
            ))
          ),
          Positioned(child: _closeLoading ? BounceIn(
            animate: _closeLoading,
            delay: Duration(milliseconds: 1000),
            duration: Duration(milliseconds: 400),
            child: Image.asset('assets/images/game1/bg_VS.png', width: 120)
          ) : Container())
        ],
      ),
    ) : Container());
  }
  Widget PlayerNameBox({required String name, bool? right}) {
    return Column(
      crossAxisAlignment: right != null ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(name, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700, fontFamily: 'Lexend')),
        SizedBox(height: 8),
        Row(
          spacing: 12,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(32)
              ),
              child: BounceIn(delay: Duration(milliseconds: 600), child: Image.asset('assets/icons/icon_football.png')),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(32)
              ),
              child: BounceIn(delay: Duration(milliseconds: 600), child: Image.asset('assets/icons/icon_football.png')),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(32)
              ),
              child: BounceIn(delay: Duration(milliseconds: 600), child: Image.asset('assets/icons/icon_football.png')),
            ),
          ],
        )
      ],
    );
  }
}