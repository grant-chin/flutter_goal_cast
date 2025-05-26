
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_goal_cast/wedget/detail_navbar.dart';
import 'package:flutter_goal_cast/wedget/soccer_item.dart';

class MatchesPage extends StatefulWidget {
  const MatchesPage({super.key});

  @override
  State<MatchesPage> createState() => MatchesPageState();
}

class MatchesPageState extends State<MatchesPage> {
  final List _tabs = ['Today', 'Upcoming'];
  int _curTab = 0;
  final List _tabSoccer = ['All Matches', 'UEFA Champions League', 'UEFA Europa League'];
  int _curTabSoccer = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Color(0xFF070123),
        child: Column(
          children: [
            DetailNavbar(title: 'Matches'),
            TabBox(),
            ContentBox()
          ],
        ),
      ),
    );
  }

  Widget TabBox() {
    return Container(
      height: 44,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_tabs.length, (index) => GestureDetector(
          onTap: () => setState(() => _curTab = index),
          child: Container(
            width: 169,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: _curTab == index ? Color(0xFFAA53FD) : Colors.transparent, width: 2))
            ),
            child: Text(_tabs[index], style: TextStyle(color: _curTab == index ? Colors.white : Colors.white60, fontSize: 14, fontWeight: FontWeight.w700)),
          )
        ))
      ),
    );
  }

  Widget ContentBox() {
    return Expanded(child: CustomScrollView(slivers: [
      SliverToBoxAdapter(
        child: Column(
          spacing: 24,
          children: [
            BoxMatches(),
            Soccer(),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16)
          ]
        )
      )
    ]));
  }

  Widget BoxMatches() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(child: Image.asset('assets/images/bg/home_bg.png')),
        Positioned(child: Container(
          width: 370,
          height: 180,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/images/bg/box_match.png'))
          ),
          child: Column(
            children: [
              Container(
                height: 22,
                alignment: Alignment.center,
                child: Text('UEFA Champions League', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
              ),
              Expanded(child: Row(
                spacing: 16,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 130,
                    height: 62,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Image.asset('assets/icons/club/manCity.png', width: 40),
                        Text('ManCity', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500))
                      ],
                    )
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Today', style: TextStyle(color: Color(0xFF01FFF7), fontSize: 16, fontWeight: FontWeight.w700)),
                      Text('17:55', style: TextStyle(color: Color(0xFF01FFF7), fontSize: 16, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Container(
                    width: 130,
                    height: 62,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Image.asset('assets/icons/club/manCity.png', width: 40),
                        Text('ManCity', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500))
                      ],
                    )
                  ),
                ],
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 16,
                children: [
                  Container(
                    width: 102,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Text('1', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                  Container(
                    width: 102,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Text('Draw', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                  Container(
                    width: 102,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Text('2', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
              SizedBox(height: 16)
            ],
          ),
        ))
      ]
    );
  }
  
  Widget Soccer() {
    return Column(
      spacing: 12,
      children: [
        Row(
          children: [
            SizedBox(width: 16),
            Image.asset('assets/icons/icon_soccer.png', width: 16),
            SizedBox(width: 4),
            Text('Soccer', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
          ]
        ),
        SoccerTab(),
        Column(spacing: 8, children: List.generate(4, (index) => SoccerItem()))
      ]
    );
  }
  Widget SoccerTab() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            spacing: 12,
            children: List.generate(_tabSoccer.length, (index) => GestureDetector(
              onTap: () => setState(() => _curTabSoccer = index),
              child: Container(
                height: 30,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: _curTabSoccer == index ? [Color(0xFFBE71FD), Color(0xFF8033D1)] : [Color(0xFF170C34), Color(0xFF170C34)],
                    stops: [0, 1], // 调整渐变范围
                  ),
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Text(_tabSoccer[index], style: TextStyle(color: _curTabSoccer == index ? Colors.white : Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
              ),
            ))
          )
        );
      }
    );
  }
}