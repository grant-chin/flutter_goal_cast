// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_goal_cast/common/utils.dart';
import 'package:flutter_goal_cast/controller/map.dart';
import 'package:flutter_goal_cast/controller/user.dart';
import 'package:get/get.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  int get _level => UserController.level.value;
  int get _points => UserController.points.value;
  List get _myPlayers => MapController.myPlayers;
  List get _levelList => MapController.levelList;
  final List _locationList = ['North America', 'South America', 'Africa', 'Europe', 'Asia', 'Oceania'];

  _onHiringPlayer(index) {
    if (_points < 1000 + 500 * _myPlayers.length) {
      Utils.toast('Insufficient Balance');
    } else {
      MapController.onHiringPlayer(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        color: Color(0xFF070123),
        child: Column(
          children: [
            Image.asset('assets/images/map/title.png'),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.toNamed('/team_manage'),
                    child: Image.asset('assets/images/map/manage_team.png', width: MediaQuery.of(context).size.width / 2 - 16),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed('/player_manage'),
                    child: Image.asset('assets/images/map/manage_players.png', width: MediaQuery.of(context).size.width / 2 - 16),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            MapContent(),
            PlayerList()
          ],
        ),
      ),
    );
  }

  Widget MapContent() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset('assets/images/map/bg.png'),
        Positioned(
          top: 18 * MediaQuery.of(context).size.width / 402,
          child: Container(
            width: 369 * MediaQuery.of(context).size.width / 402,
            height: 172 * MediaQuery.of(context).size.width / 402,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/map/mask.png'), fit: BoxFit.cover)
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 0,
                  left: 33 * MediaQuery.of(context).size.width / 402,
                  child: Image.asset('assets/images/map/map_north_America${_level ~/ 5 == 0 ? '_cur' : (_level ~/ 5 > 0 ? '_reach' : '')}.png', width: 115 * MediaQuery.of(context).size.width / 402)
                ),
                Positioned(
                  bottom: 0,
                  left: 98 * MediaQuery.of(context).size.width / 402,
                  child: Image.asset('assets/images/map/map_south_America${_level ~/ 5 == 1 ? '_cur' : (_level ~/ 5 > 1 ? '_reach' : '')}.png', width: 34 * MediaQuery.of(context).size.width / 402)
                ),
                Positioned(
                  bottom: 13 * MediaQuery.of(context).size.width / 402,
                  left: 175 * MediaQuery.of(context).size.width / 402,
                  child: Image.asset('assets/images/map/map_Africa${_level ~/ 5 == 2 ? '_cur' : (_level ~/ 5 > 2 ? '_reach' : '')}.png', width: 51 * MediaQuery.of(context).size.width / 402)
                ),
                Positioned(
                  top: 7 * MediaQuery.of(context).size.width / 402,
                  left: 178 * MediaQuery.of(context).size.width / 402,
                  child: Image.asset('assets/images/map/map_Europe${_level ~/ 5 == 3 ? '_cur' : (_level ~/ 5 > 3 ? '_reach' : '')}.png', width: 69 * MediaQuery.of(context).size.width / 402)
                ),
                Positioned(
                  top: 9 * MediaQuery.of(context).size.width / 402,
                  left: 215 * MediaQuery.of(context).size.width / 402,
                  child: Image.asset('assets/images/map/map_Asia${_level ~/ 5 == 4 ? '_cur' : (_level ~/ 5 > 4 ? '_reach' : '')}.png', width: 121 * MediaQuery.of(context).size.width / 402)
                ),
                Positioned(
                  bottom: 10 * MediaQuery.of(context).size.width / 402,
                  left: 284 * MediaQuery.of(context).size.width / 402,
                  child: Image.asset('assets/images/map/map_Oceania${_level ~/ 5 >= 5 ? '_cur' : ''}.png', width: 49.33 * MediaQuery.of(context).size.width / 402)
                ),
              ],
            )
          )
        ),
        Positioned(
          bottom: 14 * MediaQuery.of(context).size.width / 402,
          child: Row(
            children: [
              Text('Current location:  ', style: TextStyle(color: Color.fromRGBO(7, 1, 35, 0.5), fontSize: 12, fontWeight: FontWeight.w500, height: 1)),
              Text(_locationList[_level ~/ 5 > 5 ? 5 : _level ~/ 5], style: TextStyle(color: Color.fromRGBO(7, 1, 35, 0.5), fontSize: 16, fontWeight: FontWeight.w700, height: 1)),
            ],
          )
        )
      ],
    );
  }

  Widget PlayerList() {
    return Expanded(child: CustomScrollView(slivers: [
      SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.only(top: 16, bottom: MediaQuery.of(context).padding.bottom + 80),
          alignment: Alignment.center,
          child: Wrap(
            spacing: 12,
            runSpacing: 24,
            children: List.generate(_level >= 30 ? 18 : (_level ~/ 5 + 1) * 3, (index) => PlayerItem(index))
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
            Obx(() => Image.asset('assets/images/map/player_border${_myPlayers.contains('${index+1}') ? '_blue' : ''}.png', height: 160)),
            Positioned(child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16)
              ),
              child: Image.asset('assets/images/map/player${index+1}.png', width: 102, height: 144, fit: BoxFit.cover),
            )),
            Positioned(
              top: 0,
              child: Container(
                width: 56,
                height: 14,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xFF38295E),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8))
                ),
                child: Obx(() => Text('S${_myPlayers.contains('${index+1}') ? _levelList[_myPlayers.indexOf('${index+1}')] : '1'}', style: TextStyle(color: Colors.white, fontSize: 11)))
              )
            ),
          ],
        ),
        SizedBox(height: 8),
        Obx(() => _myPlayers.contains('${index+1}') ? Container(
          width: 73,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color(0xFF38295E),
            border: Border.all(color: Color(0xFFBE71FD)),
            borderRadius: BorderRadius.circular(8)
          ),
          child: Text('Owned', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
        ) : GestureDetector(
          onTap: () => _onHiringPlayer(index),
          child: Container(
            width: 82,
            height: 32,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFBE71FD), Color(0xFF8033D1)],
                stops: [0, 1], // 调整渐变范围
              ),
              borderRadius: BorderRadius.circular(8)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() => Text('${UserController.pointFormat(1000 + 500 * _myPlayers.length)}', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600))),
                SizedBox(width: 4),
                Image.asset('assets/icons/bets.png', width: 16)
              ],
            )
          )
        ))
      ],
    );
  }
}