
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_goal_cast/controller/map.dart';
import 'package:flutter_goal_cast/wedget/detail_navbar.dart';
import 'package:get/get.dart';

class TeamMPage extends StatefulWidget {
  const TeamMPage({super.key});

  @override
  State<TeamMPage> createState() => TeamMPageState();
}

class TeamMPageState extends State<TeamMPage> {
  Map get _teamMap => MapController.teamMap;
  List get _onlinePlayers => MapController.onlinePlayers;
  int get _incomeAmount => MapController.incomeAmount.value;
  List get _myPlayers => MapController.myPlayers;
  List get _levelList => MapController.levelList;
  int _curLocation = -1;

  @override
  initState() {
    super.initState();
    MapController.initTeam();
  }

  _onAppearPlayer(index) {
    if (_curLocation == -1) return;
    MapController.onAppear(location: _curLocation, player: index);
  }
  
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
                  Obx(() => Text('$_incomeAmount', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)))
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
                    children: List.generate(_myPlayers.length, (index) => PlayerItem(index))
                  )
                );
              }
            )
          ],
        ),
      ),
    );
  }
  Widget PlayerItem(index) {
    return Obx(() => Offstage(
      offstage: _onlinePlayers.contains(_myPlayers[index]),
      child: GestureDetector(
        onTap: () => _onAppearPlayer(index),
        child: Container(
          width: 64,
          height: 64,
          margin: EdgeInsets.only(right: 16),
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
              Image.asset('assets/images/map/team_player_${_myPlayers[index]}.png', width: 64),
              Positioned(bottom: 0, child: Container(
                width: 64,
                height: 14,
                alignment: Alignment.center,
                color: Color.fromRGBO(91, 0, 165, 0.72),
                child: Text('S${_levelList[index]}', style: TextStyle(color: Color(0xFF01FFF7), fontSize: 12, fontWeight: FontWeight.w500)),
              ))
            ],
          ),
        ),
      ),
    ));
  }

  Widget CourtBox() {
    double scale = MediaQuery.of(context).size.width / 402;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 582 * scale,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/bg/bg_court.png'), fit: BoxFit.cover)
      ),
      child: Stack(
        children: [
          PlaceItem(top: 78 * scale, left: 92 * scale, index: 0),
          PlaceItem(top: 78 * scale, left: 238 * scale, index: 1),
          PlaceItem(top: 160 * scale, left: 34 * scale, index: 2),
          PlaceItem(top: 160 * scale, left: 298 * scale, index: 3),
          PlaceItem(top: 214 * scale, left: MediaQuery.of(context).size.width / 2 - 36, index: 4),
          PlaceItem(top: 296 * scale, left: 92 * scale, index: 5),
          PlaceItem(top: 296 * scale, left: 238 * scale, index: 6),
          PlaceItem(top: 380 * scale, left: 34 * scale, index: 7),
          PlaceItem(top: 380 * scale, left: 298 * scale, index: 8),
          PlaceItem(top: 380 * scale, left: MediaQuery.of(context).size.width / 2 - 36, index: 9),
          PlaceItem(top: 464 * scale, left: MediaQuery.of(context).size.width / 2 - 36, index: 10),
        ]
      ),
    );
  }
  Widget PlaceItem({ required double top, required double left, required int index }) {
    double scale = MediaQuery.of(context).size.width / 402;
    return Positioned(
      top: top,
      left: left,
      child: Obx(() => GestureDetector(
        onTap: () => setState(() => _curLocation = index),
        child: _teamMap['location_${index+1}'] != null ? Container(
          width: 72 * scale,
          height: 72 * scale,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/images/map/polygon_player_${_teamMap['location_${index+1}']['player']}.png'))
          ),
          child: Stack(
            children: [
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 12,
                  height: 12,
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: _teamMap['location_${index+1}']['appareHour'] < 12 ? Color.fromRGBO(30, 240, 139, 0.3) : (_teamMap['location_${index+1}']['appareHour'] < 18 ? Color.fromRGBO(240, 118, 30, 0.3) : Color.fromRGBO(240, 30, 30, 0.3)),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _teamMap['location_${index+1}']['appareHour'] < 12 ? Color.fromRGBO(30, 240, 139, 1) : (_teamMap['location_${index+1}']['appareHour'] < 18 ? Color.fromRGBO(240, 118, 30, 1) : Color.fromRGBO(240, 30, 30, 1)),
                      borderRadius: BorderRadius.circular(12)
                    ),
                  ),
                )
              )
            ],
          ),
        ) : _curLocation == index ? Image.asset('assets/images/map/polygon_player_empty.png', width: 72 * scale) : Image.asset('assets/images/bg/player_box_none.png', width: 72 * scale)
      ))
    );
  }
}