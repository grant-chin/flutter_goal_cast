// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
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
                  child: Image.asset('assets/images/map/map_north_America_reach.png', width: 115 * MediaQuery.of(context).size.width / 402)
                ),
                Positioned(
                  bottom: 0,
                  left: 98 * MediaQuery.of(context).size.width / 402,
                  child: Image.asset('assets/images/map/map_south_America_cur.png', width: 34 * MediaQuery.of(context).size.width / 402)
                ),
                Positioned(
                  bottom: 13 * MediaQuery.of(context).size.width / 402,
                  left: 175 * MediaQuery.of(context).size.width / 402,
                  child: Image.asset('assets/images/map/map_Africa.png', width: 51 * MediaQuery.of(context).size.width / 402)
                ),
                Positioned(
                  top: 7 * MediaQuery.of(context).size.width / 402,
                  left: 178 * MediaQuery.of(context).size.width / 402,
                  child: Image.asset('assets/images/map/map_Europe.png', width: 69 * MediaQuery.of(context).size.width / 402)
                ),
                Positioned(
                  top: 9 * MediaQuery.of(context).size.width / 402,
                  left: 215 * MediaQuery.of(context).size.width / 402,
                  child: Image.asset('assets/images/map/map_Asia.png', width: 121 * MediaQuery.of(context).size.width / 402)
                ),
                Positioned(
                  bottom: 10 * MediaQuery.of(context).size.width / 402,
                  left: 284 * MediaQuery.of(context).size.width / 402,
                  child: Image.asset('assets/images/map/map_Oceania.png', width: 49.33 * MediaQuery.of(context).size.width / 402)
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
              Text('North America', style: TextStyle(color: Color.fromRGBO(7, 1, 35, 0.5), fontSize: 16, fontWeight: FontWeight.w700, height: 1)),
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
            children: List.generate(18, (index) => PlayerItem(index))
          ),
        )
      )
    ]));
  }
  Widget PlayerItem(index) {
    late bool owned = false;
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/images/map/player_border.png', height: 160),
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
                child: Text('S1', style: TextStyle(color: Colors.white, fontSize: 11)),
              )
            ),
          ],
        ),
        SizedBox(height: 8),
        owned ? Container(
          width: 73,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color(0xFF38295E),
            border: Border.all(color: Color(0xFFBE71FD)),
            borderRadius: BorderRadius.circular(8)
          ),
          child: Text('Owned', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
        ) : Container(
          width: 80,
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
              Text('1500', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              SizedBox(width: 4),
              Image.asset('assets/icons/bets.png', width: 16)
            ],
          )
        )
      ],
    );
  }
}