// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_goal_cast/common/utils.dart';
import 'package:flutter_goal_cast/controller/match.dart';
import 'package:flutter_goal_cast/controller/task.dart';
import 'package:flutter_goal_cast/controller/user.dart';
import 'package:flutter_goal_cast/wedget/challenge.dart';
import 'package:get/get.dart' hide Response;
import 'package:intl/intl.dart';

var formater = DateFormat('yyyy-MM-dd');
var timeFormater = DateFormat('yyyy-MM-dd HH:mm');

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int get _level => UserController.level.value;
  String get _nickname => UserController.nickname.value;
  String get _point => UserController.pointStr.value;
  bool get _dailyClaimed => TaskController.dailyClaimed.value;
  List get _matchList => MatchController.matchList.where((o) => o['status'] == 1).toList();

  _timeFormatter(date) {
    return timeFormater.format(DateTime.fromMillisecondsSinceEpoch(date).toUtc());
  }

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
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/avator.png')),
              borderRadius: BorderRadius.circular(8)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 48,
                  height: 14,
                  alignment: Alignment.center,
                  color: Color.fromRGBO(18, 7, 47, 0.64),
                  child: Obx(() => Text('Lv.$_level', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)))
                )
              ],
            ),
          ),
          SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => Text(_nickname, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500))),
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
                    Obx(() => Text(_point, style: TextStyle(color: Colors.white, fontSize: 13)))
                  ],
                )
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () => Utils.showDailyTasks(context),
            child: Image.asset('assets/icons/box_task.png', height: 40),
          )
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
              padding: EdgeInsets.fromLTRB(0, 16, 0, MediaQuery.of(context).padding.bottom + 58 + 24),
              // color: Colors.amber,
              child: Column(
                spacing: 24,
                children: [
                  DailyReward(),
                  BoxMatches(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: BoxChallenge()
                  )
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
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/icons/box_everyday.png'))
      ),
      child: Row(
        children: [
          SizedBox(width: 94),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Daily bonus', style: TextStyle(color: Color(0xFF01FFF7), fontSize: 14, fontWeight: FontWeight.w700, shadows: [
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
          Obx(() => SizedBox(
            height: 30,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(0),
                foregroundColor: Color(0xFF070123),
                backgroundColor: Color(0xFF01FFF7),
                disabledForegroundColor: Colors.white60,
                disabledBackgroundColor: Color(0xFF38295E),
                shadowColor: Colors.transparent,
                overlayColor: Colors.black26,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: _dailyClaimed ? null : () => Utils.dailyBonus(context),
              child: Text(_dailyClaimed ? 'Done' : 'Claim', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))
            ),
          )),
          SizedBox(width: 20)
        ],
      )
    );
  }
  
  Widget BoxMatches() {
    return Column(
      spacing: 12,
      children: [
        Row(
          children: [
            SizedBox(width: 16),
            Image.asset('assets/icons/icon_football.png', width: 16),
            SizedBox(width: 4),
            Text('Featured matches', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
            Spacer(),
            Obx(() => Offstage(
              offstage: _matchList.isEmpty,
              child: GestureDetector(
                onTap: () => Get.toNamed('/matches'),
                child: Row(
                  children: [
                    Text('More', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w700)),
                    SizedBox(width: 2),
                    Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 12)
                  ],
                )
              )
            )),
            SizedBox(width: 16),
          ]
        ),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Obx(() => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _matchList.isNotEmpty ? Row(
                spacing: 12,
                children: List.generate(_matchList.length > 3 ? 3 : _matchList.length, (index) => MatchItem(index))
              ) : Container(
                height: 60,
                alignment: Alignment.center,
                child: Text('No Data', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
              )
            ));
          }
        )
      ]
    );
  }
  Widget MatchItem(index) {
    return GestureDetector(
      onTap: () => Get.toNamed('/matches'),
      child: Container(
        width: 252,
        height: 146,
        decoration: BoxDecoration(
          color: Color(0xFF12072F),
          border: Border.all(color: Color(0xFF38295E), width: 2),
          borderRadius: BorderRadius.circular(8)
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 80,
              child: Container(
                width: 158,
                height: 158,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(190, 113, 253, 0.24),
                      offset: Offset(0, 0),
                      blurRadius: 60.3,
                    )
                  ],
                  borderRadius: BorderRadius.circular(158)
                ),
              )
            ),
            Column(
              children: [
                Container(
                  width: 172,
                  height: 22,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xFF38295E),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24))
                  ),
                  child: Obx(() => Text(_matchList[index]['name'], style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500), textAlign: TextAlign.center, overflow: TextOverflow.ellipsis))
                ),
                SizedBox(height: 8),
                Obx(() => Text('${_timeFormatter(_matchList[index]['matchTime'] * 1000)}', style: TextStyle(color: Colors.white30, fontSize: 11, fontWeight: FontWeight.w400))),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 12,
                  children: [
                    ClubBox(id: _matchList[index]['homeId'], name: _matchList[index]['homeName']),
                    Image.asset('assets/icons/VS.png', width: 40),
                    ClubBox(id: _matchList[index]['awayId'], name: _matchList[index]['awayName']),
                  ],
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
  Widget ClubBox({id, name}) {
    return Container(
      width: 74,
      alignment: Alignment.center,
      child: Column(
        spacing: 10,
        children: [
          Image.network('https://images.fotmob.com/image_resources/logo/teamlogo/$id.png', width: 24),
          Text(name, style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis)
        ],
      ),
    );
  }
}