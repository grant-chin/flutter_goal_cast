
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_goal_cast/wedget/detail_navbar.dart';

class TeamMPage extends StatefulWidget {
  const TeamMPage({super.key});

  @override
  State<TeamMPage> createState() => TeamMPageState();
}

class TeamMPageState extends State<TeamMPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Color(0xFF070123),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailNavbar(
              title: 'Manage team',
              right: Row(
                children: [
                  Text('Income:', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
                  SizedBox(width: 8),
                  Image.asset('assets/icons/bets.png', width: 16),
                  SizedBox(width: 2),
                  Text('0', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                ],
              )
            ),
            CourtBox(),
            Container(
              padding: EdgeInsets.only(left: 16, top: 24, bottom: 16),
              child: Text('My Players', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700))
            ),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    spacing: 16,
                    children: List.generate(10, (index) => PlayerItem())
                  )
                );
              }
            )
          ],
        ),
      ),
    );
  }
  Widget PlayerItem() {
    return Container(
      width: 64,
      height: 64,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF170C34), Color(0xFF38295E)],
          stops: [0, 1], // 调整渐变范围
        ),
        border: Border(top: BorderSide(color: Colors.white30)),
        borderRadius: BorderRadius.circular(6)
      ),
      child: Stack(
        children: [
          Image.asset('assets/images/map/team_player_1.png', width: 64),
          Positioned(bottom: 0, child: Container(
            width: 64,
            height: 14,
            alignment: Alignment.center,
            color: Color.fromRGBO(91, 0, 165, 0.72),
            child: Text('S1', style: TextStyle(color: Color(0xFF01FFF7), fontSize: 12, fontWeight: FontWeight.w500)),
          ))
        ],
      ),
    );
  }

  Widget CourtBox() {
    double scale = MediaQuery.of(context).size.width / 402;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 582 * scale,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/bg/bg_court.png'))
      ),
      child: Stack(
        children: [
          PlaceItem(top: 78 * scale, left: 92 * scale),
          PlaceItem(top: 78 * scale, left: 238 * scale),
          PlaceItem(top: 160 * scale, left: 34 * scale),
          PlaceItem(top: 160 * scale, left: 298 * scale),
          PlaceItem(top: 214 * scale, left: MediaQuery.of(context).size.width / 2 - 36),
          PlaceItem(top: 296 * scale, left: 92 * scale),
          PlaceItem(top: 296 * scale, left: 238 * scale),
          PlaceItem(top: 380 * scale, left: 34 * scale),
          PlaceItem(top: 380 * scale, left: 298 * scale),
          PlaceItem(top: 380 * scale, left: MediaQuery.of(context).size.width / 2 - 36),
          PlaceItem(top: 464 * scale, left: MediaQuery.of(context).size.width / 2 - 36),
        ]
      ),
    );
  }
  Widget PlaceItem({ required double top, required double left }) {
    double scale = MediaQuery.of(context).size.width / 402;
    return Positioned(
      top: top,
      left: left,
      child: Image.asset('assets/images/bg/player_box_none.png', width: 72 * scale)
    );
  }
}