// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_goal_cast/controller/user.dart';
import 'package:flutter_goal_cast/wedget/primary_btn.dart';

class Forecast extends StatefulWidget {
  const Forecast({super.key, required this.id, required this.type, required this.item});
  final int id;
  final int type;
  final Map item;

  @override
  State<Forecast> createState() => ForecastState();
}

class ForecastState extends State<Forecast> {
  int get _level => UserController.level.value;
  int get _points => UserController.points.value;
  String get _pointStr => UserController.pointStr.value;

  int amount = 100;
  
  @override
  Widget build(BuildContext context) {
    int homeId = widget.item['homeId'];
    int awayId = widget.item['awayId'];
    String homeName = widget.item['homeName'];
    String awayName = widget.item['awayName'];
    int forecastId = 0;
    String forecastName = 'Draw';
    if (widget.type == 1) {
      forecastId = homeId;
      forecastName = homeName;
    } else if (widget.type == 2) {
      forecastId = awayId;
      forecastName = awayName;
    }

    return Container(
      height: 386 - 52,
      padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Current level', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w400)),
              Text('Balance', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w400)),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Text('Lvl.$_level', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
              Spacer(),
              Image.asset('assets/icons/bets.png', width: 20),
              SizedBox(width: 4),
              Text(_pointStr, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              forecastName == 'Draw' ? Container() : Image.network('https://images.fotmob.com/image_resources/logo/teamlogo/${forecastId}.png', width: 24),
              SizedBox(width: forecastName == 'Draw' ? 0 : 8),
              Text(forecastName, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700))
            ],
          ),
          SizedBox(height: 4),
          Text('$homeName   x   $awayName', style: TextStyle(color: Colors.white30, fontSize: 12, fontWeight: FontWeight.w500)),
          Spacer(),
          Text('Amount', style: TextStyle(color: Colors.white30, fontSize: 12, fontWeight: FontWeight.w500)),
          SizedBox(height: 8),
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: Color(0xFF070123),
              borderRadius: BorderRadius.circular(8)
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (amount > 100) {
                      setState(() => amount -= 100);
                    }
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Color(0xFF38295E),
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Icon(Icons.remove, color: Colors.white70)
                  )
                ),
                Spacer(),
                Image.asset('assets/icons/bets.png', width: 24),
                SizedBox(width: 8),
                Text('$amount', style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w700)),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    if (amount < _points) {
                      setState(() => amount += 100);
                    }
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Color(0xFF38295E),
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Icon(Icons.add, color: Colors.white70)
                  ),
                )
              ],
            )
          ),
          SizedBox(height: 8),
          Row(
            spacing: 8,
            children: [
              AmountBtn(100),
              AmountBtn(200),
              AmountBtn(500),
              AmountBtn(1000)
            ],
          ),
          SizedBox(height: 16),
          PrimaryBtn(
            width: MediaQuery.of(context).size.width,
            text: 'Confirm',
            func: (){}
          )
        ],
      )
    );
  }

  Widget AmountBtn(count) {
    return GestureDetector(
      onTap: () => setState(() => amount = count),
      child: Container(
        width: (MediaQuery.of(context).size.width - 32 - 16 - 24) / 4,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xFF38295E),
          borderRadius: BorderRadius.circular(12)
        ),
        child: Text('$count', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
      )
    );
  }
}