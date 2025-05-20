// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_goal_cast/wedget/challenge.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Color(0xFF070123),
        child: Column(
          children: [
            HeaderBox(),
            ContentBox()
          ],
        ),
      ),
    );
  }

  Widget HeaderBox() {
    return Container(
      height: 72,
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(8)
            ),
          ),
          SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Thomas021', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
              Container(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFF8033D1), Color.fromRGBO(56, 41, 94, 0.6)],
                    stops: [0, 1], // 调整渐变范围
                  ),
                  border: Border(left: BorderSide(color: Color.fromRGBO(255, 255, 255, 0.32)), top: BorderSide(color: Color.fromRGBO(255, 255, 255, 0.32))),
                  borderRadius: BorderRadius.circular(4)
                ),
                child: Row(
                  children: [
                    Image.asset('assets/icons/bets.png', width: 16),
                    SizedBox(width: 4),
                    Text('1000', style: TextStyle(color: Colors.white, fontSize: 13))
                  ],
                )
              )
            ],
          ),
          Spacer(),
          Image.asset('assets/icons/box_task.png', height: 40)
        ],
      ),
    );
  }
  
  Widget ContentBox() {
    return Expanded(child: CustomScrollView(slivers: [
      SliverToBoxAdapter(
        child: Stack(
          children: [
            Positioned(child: Image.asset('assets/images/bg/home_bg.png')),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).padding.bottom + 58 + 24),
              // color: Colors.amber,
              child: Column(
                spacing: 16,
                children: [
                  DailyReward(),
                  BoxMatches(),
                  BoxChallenge()
                ]
              ),
            ),
          ],
        )
      )
    ]));
  }

  // 首发奖励/每日奖励
  Widget DailyReward() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/icons/box_everyday.png'))
      ),
      child: Row(
        children: [
          SizedBox(width: 96),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome Bonus', style: TextStyle(color: Color(0xFF01FFF7), fontSize: 14, fontWeight: FontWeight.w700, shadows: [
                Shadow(
                  color: Color(0xFF170C34), // 阴影颜色
                  offset: Offset(1, 1), // 阴影偏移量 (水平, 垂直)
                  blurRadius: 0, // 阴影模糊程度
                ),
              ])),
              SizedBox(height: 2),
              Row(
                children: [
                  Text('Up to 1000', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                  SizedBox(width: 4),
                  Image.asset('assets/icons/bets.png', width: 16)
                ],
              )
            ],
          ),
          Spacer(),
          SizedBox(
            height: 30,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(0),
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFF01FFF7),
                shadowColor: Colors.transparent,
                overlayColor: Colors.black26,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: (){},
              child: Text('Claim', style: TextStyle(color: Color(0xFF070123), fontSize: 12, fontWeight: FontWeight.w700))
            ),
          ),
          SizedBox(width: 20)
        ],
      )
    );
  }
  Widget BoxMatches() {
    return Column(
      children: [
        Row(
          children: [
            Image.asset('assets/icons/icon_football.png', width: 16),
            SizedBox(width: 4),
            Text('Featured matches', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700))
          ]
        ),
        Container()
      ]
    );
  }
}