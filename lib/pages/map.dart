// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/map/manage_team.png', height: 84),
                  Image.asset('assets/images/map/manage_players.png', height: 84),
                ],
              ),
            ),
            SizedBox(height: 12),
            Stack(
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
                    child: Image.asset('assets/images/map/map_all.png'),
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
            ),
          ],
        ),
      ),
    );
  }
}