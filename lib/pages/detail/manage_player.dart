
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_goal_cast/wedget/detail_navbar.dart';

class PlayerMPage extends StatefulWidget {
  const PlayerMPage({super.key});

  @override
  State<PlayerMPage> createState() => PlayerMPageState();
}

class PlayerMPageState extends State<PlayerMPage> {
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
    return DetailNavbar(
      title: 'My players',
      right: Container(
        height: 32,
        padding: EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF8033D1), Color.fromRGBO(56, 41, 94, 0.6)],
            stops: [0, 1], // 调整渐变范围
          ),
          border: Border(left: BorderSide(color: Color.fromRGBO(255, 255, 255, 0.32)), top: BorderSide(color: Color.fromRGBO(255, 255, 255, 0.32))),
          borderRadius: BorderRadius.circular(8)
        ),
        child: Row(
          children: [
            Image.asset('assets/icons/bets.png', width: 16),
            SizedBox(width: 6),
            Text('1,000', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500))
          ],
        )
      ),
    );
  }

  Widget ContentBox() {
    return Expanded(child: CustomScrollView(slivers: [
      SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.only(top: 16, bottom: MediaQuery.of(context).padding.bottom + 16),
          child: Wrap(
            spacing: 16,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: List.generate(18, (index) => PlayerItem(index))
          ),
        )
      )
    ]));
  }
  Widget PlayerItem(index) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/images/map/player_border_blue.png', height: 240),
            Positioned(child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16)
              ),
              child: Image.asset('assets/images/map/player${index+1}.png', height: 216, fit: BoxFit.cover),
            )),
            Positioned(
              bottom: 12,
              child: Container(
                width: 153,
                height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color.fromRGBO(128, 51, 209, 0), Color(0xFF8033D1)],
                    stops: [0, 1], // 调整渐变范围
                  ),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))
                ),
                child: Row(
                  spacing: 4,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('1000', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
                    Image.asset('assets/icons/bets.png', width: 24)
                  ],
                ),
              )
            ),
            Positioned(
              top: 0,
              child: Container(
                width: 84,
                height: 21,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xFF38295E),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12))
                ),
                child: Text('S1', style: TextStyle(color: Colors.white, fontSize: 16)),
              )
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          width: 99,
          height: 36,
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
              disabledBackgroundColor: Color(0xFF38295E),
              shadowColor: Colors.transparent,
              overlayColor: Colors.black26,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: (){},
            child: Text('Upgrade', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))
          )
        )
      ],
    );
  }
}