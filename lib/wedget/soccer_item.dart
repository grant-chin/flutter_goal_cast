// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_goal_cast/common/utils.dart';
import 'package:flutter_goal_cast/controller/match.dart';
import 'package:intl/intl.dart';

var timeFormater = DateFormat('yyyy-MM-dd HH:mm');

String _timeFormatter(date) {
  return timeFormater.format(DateTime.fromMillisecondsSinceEpoch(date).toUtc());
}

Widget SoccerItem(context, { required item, bool? collectable, bool? hideCollect }) {
  bool forecastHome = item['forecast'] == true && item['forecastId'] == '${item['homeId']}';
  bool forecastAway = item['forecast'] == true && item['forecastId'] == '${item['awayId']}';
  bool forecastDraw = item['forecast'] == true && item['forecastId'] == '0';
  bool result = (item['homeScore'] > item['awayScore'] && forecastHome) || (item['homeScore'] < item['awayScore'] && forecastAway) || (item['homeScore'] == item['awayScore'] && forecastDraw);
  
  return Container(
    width: 370,
    height: item['status'] == 6 ? 174 : 188,
    decoration: BoxDecoration(
      color: Color(0xFF12072F),
      borderRadius: BorderRadius.circular(8)
    ),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 80,
          child: Container(
            width: 276,
            height: 186,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(190, 113, 253, 0.24),
                  offset: Offset(0, 0),
                  blurRadius: 60.3,
                )
              ],
              borderRadius: BorderRadius.circular(186)
            ),
          )
        ),
        Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(
                height: 38,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item['name'], style: TextStyle(color: Colors.white30, fontSize: 14, fontWeight: FontWeight.w500, height: 1)),
                    Text(_timeFormatter(item['matchTime'] * 1000), style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500, height: 1)),
                  ],
                ),
              ),
              Offstage(
                offstage: item['status'] != 6,
                child: Container(
                  width: 58,
                  height: 14,
                  margin: EdgeInsets.only(top: 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(4)
                  ),
                  child: Text('Full Time', style: TextStyle(color: Colors.white60, fontSize: 11))
                )
              ),
              Expanded(
                child: Row(
                  spacing: 24,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 129,
                      child: Row(
                        spacing: 8,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(width: 96, child: Text(item['homeName'], style: TextStyle(color: Colors.white70), textAlign: TextAlign.right, maxLines: 2, overflow: TextOverflow.ellipsis)),
                          Image.network('https://images.fotmob.com/image_resources/logo/teamlogo/${item['homeId']}.png', width: 24),
                        ],
                      ),
                    ),
                    Image.asset('assets/icons/VS.png', width: 32),
                    SizedBox(
                      width: 129,
                      child: Row(
                        spacing: 8,
                        children: [
                          Image.network('https://images.fotmob.com/image_resources/logo/teamlogo/${item['awayId']}.png', width: 24),
                          SizedBox(width: 96, child: Text(item['awayName'], style: TextStyle(color: Colors.white70), textAlign: TextAlign.left, maxLines: 2, overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ),
                  ]
                )
              ),
              
              Offstage(
                offstage: item['status'] != 1 || collectable == true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 16,
                  children: [
                    GestureDetector(
                      onTap: () => Utils.forcastDialog(context, type: 1, item: item),
                      child: Container(
                        width: 102,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: forecastHome ? Color(0xFF01FFF7) : Colors.white10,
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: Text('1', style: TextStyle(color: forecastHome ? Color(0xFF070123) : Colors.white70, fontSize: 14, fontWeight: FontWeight.w500))
                      )
                    ),
                    GestureDetector(
                      onTap: () => Utils.forcastDialog(context, type: 0, item: item),
                      child: Container(
                        width: 102,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: forecastDraw ? Color(0xFF01FFF7) : Colors.white10,
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: Text('Draw', style: TextStyle(color: forecastDraw ? Color(0xFF070123) : Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
                      )
                    ),
                    GestureDetector(
                      onTap: () => Utils.forcastDialog(context, type: 2, item: item),
                      child: Container(
                        width: 102,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: forecastAway ? Color(0xFF01FFF7) : Colors.white10,
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: Text('2', style: TextStyle(color: forecastAway ? Color(0xFF070123) : Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
                      )
                    )
                  ],
                )
              ),
              Offstage(
                offstage: item['status'] != 6,
                child: Image.asset('assets/images/bg/box_${result ? 'win' : 'lose'}.png')
              ),
              Offstage(
                offstage: collectable != true,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Text('${item['homeScore']} : ${item['awayScore']}', style: TextStyle(color: Colors.white60, fontSize: 16, fontWeight: FontWeight.w700))
                )
              ),
            ],
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: Offstage(
            offstage: hideCollect == true,
            child: GestureDetector(
              onTap: () => MatchController.onCollect(item),
              child: Container(
                width: 24,
                height: 24,
                color: Colors.transparent,
                padding: EdgeInsets.all(4),
                child: Image.asset('assets/icons/collection${item['collected'] ? '_ac' : ''}.png', width: 16)
              ),
            )
          )
          
        )
      ],
    ),
  );
}