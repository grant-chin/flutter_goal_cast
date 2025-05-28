
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_goal_cast/common/eventbus.dart';
import 'package:flutter_goal_cast/common/utils.dart';
import 'package:flutter_goal_cast/controller/match.dart';
import 'package:flutter_goal_cast/wedget/detail_navbar.dart';
import 'package:flutter_goal_cast/wedget/soccer_item.dart';
import 'package:intl/intl.dart';

var timeFormater = DateFormat('HH:mm');

String _timeFormatter(date) {
  return timeFormater.format(DateTime.fromMillisecondsSinceEpoch(date).toUtc());
}

class MatchesPage extends StatefulWidget {
  const MatchesPage({super.key});

  @override
  State<MatchesPage> createState() => MatchesPageState();
}

class MatchesPageState extends State<MatchesPage> {
  List _listData = MatchController.matchList.where((o) => o['status'] == 1).toList();
  List _matchList = MatchController.matchList.where((o) => o['status'] == 1).toList();
  final List _tabs = ['Today', 'Upcoming'];
  int _curTab = 0;
  int _curMatch = 0;
  final List _tabSoccer = ['All Matches'];
  int _curTabSoccer = 0;

  @override
  initState() {
    super.initState();
    initLeagues();
    bus.on('updateLeagues', (_) => _onTabChange(_curTab));
  }
  @override
  dispose() {
    super.dispose();
    bus.off('updateLeagues');
  }

  // 初始化联赛类型
  initLeagues() {
    _tabSoccer.clear();
    setState(() => _tabSoccer.add('All Matches'));
    for (int i = 0; i < _listData.length; i++) {
      String league = _listData[i]['name'];
      if (!_tabSoccer.contains(league)) {
        setState(() => _tabSoccer.add(league));
      }
    }
  }

  _onTabChange(index) {
    setState(() => _curMatch = 0);
    setState(() => _curTab = index);
    if (index == 0) {
      setState(() => _listData = MatchController.matchList.where((o) => o['status'] == 1).toList());
    } else {
      setState(() => _listData = MatchController.tomorrowMatch.where((o) => o['status'] == 1).toList());
    }
    _onTabSoccerChange(0);
    initLeagues();
  }
  _onTabSoccerChange(index) {
    setState(() => _curTabSoccer = index);
    if (index == 0) {
      setState(() => _matchList = _listData);
    } else {
      setState(() => _matchList = _listData.where((o) => o['name'] == _tabSoccer[index]).toList());
    }
  }

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
          onTap: () => _onTabChange(index),
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
          children: [
            BoxMatches(),
            SizedBox(height: 24),
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
                child: Text('${_listData[_curMatch]['name']}', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500, overflow: TextOverflow.ellipsis)),
              ),
              Expanded(child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 130,
                    height: 74,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Image.network('https://images.fotmob.com/image_resources/logo/teamlogo/${_listData[_curMatch]['homeId']}.png', width: 40),
                        SizedBox(width: 96, child: Text(_listData[_curMatch]['homeName'], style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis)),
                      ],
                    )
                  ),
                  SizedBox(
                    width: 80,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_curTab == 0 ? 'Today' : 'Tomorrow', style: TextStyle(color: Color(0xFF01FFF7), fontSize: 16, fontWeight: FontWeight.w700)),
                        Text(_timeFormatter(_listData[_curMatch]['matchTime'] * 1000), style: TextStyle(color: Color(0xFF01FFF7), fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    )
                  ),
                  Container(
                    width: 130,
                    height: 74,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Image.network('https://images.fotmob.com/image_resources/logo/teamlogo/${_listData[_curMatch]['awayId']}.png', width: 40),
                        SizedBox(width: 96, child: Text(_listData[_curMatch]['awayName'], style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis)),
                      ],
                    )
                  ),
                ],
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 16,
                children: [
                  GestureDetector(
                    onTap: () => Utils.forcastDialog(context, type: 1, item: _listData[_curMatch]),
                    child: Container(
                      width: 102,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _listData[_curMatch]['forecast'] == true && _listData[_curMatch]['forecastId'] == '${_listData[_curMatch]['homeId']}' ? Color(0xFF01FFF7) : Colors.white30,
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: Text('1', style: TextStyle(color: _listData[_curMatch]['forecast'] == true && _listData[_curMatch]['forecastId'] == '${_listData[_curMatch]['homeId']}' ? Color(0xFF070123) : Colors.white, fontSize: 14, fontWeight: FontWeight.w500))
                    )
                  ),
                  GestureDetector(
                    onTap: () => Utils.forcastDialog(context, type: 1, item: _listData[_curMatch]),
                    child: Container(
                      width: 102,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _listData[_curMatch]['forecast'] == true && _listData[_curMatch]['forecastId'] == '0' ? Color(0xFF01FFF7) : Colors.white30,
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: Text('Draw', style: TextStyle(color: _listData[_curMatch]['forecast'] == true && _listData[_curMatch]['forecastId'] == '0' ? Color(0xFF070123) : Colors.white, fontSize: 14, fontWeight: FontWeight.w500))
                    )
                  ),
                  GestureDetector(
                    onTap: () => Utils.forcastDialog(context, type: 1, item: _listData[_curMatch]),
                    child: Container(
                      width: 102,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _listData[_curMatch]['forecast'] == true && _listData[_curMatch]['forecastId'] == '${_listData[_curMatch]['awayId']}' ? Color(0xFF01FFF7) : Colors.white30,
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: Text('2', style: TextStyle(color: _listData[_curMatch]['forecast'] == true && _listData[_curMatch]['forecastId'] == '${_listData[_curMatch]['awayId']}' ? Color(0xFF070123) : Colors.white, fontSize: 14, fontWeight: FontWeight.w500))
                    )
                  ),
                ],
              ),
              SizedBox(height: 16)
            ],
          ),
        )),
        Positioned(
          left: 8,
          child: Offstage(
            offstage: _curMatch <= 0,
            child: GestureDetector(
              onTap: () => setState(() => _curMatch--),
              child: Container(
                width: 32,
                height: 32,
                padding: EdgeInsets.only(right: 2),
                decoration: ShapeDecoration(
                  color: Colors.white30,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Icon(Icons.arrow_back_ios_outlined, size: 16, color: Colors.white,)
              )
            )
          )
        ),
        Positioned(
          right: 8,
          child: Offstage(
            offstage: _curMatch >= _matchList.length || _curMatch >= 2,
            child: GestureDetector(
              onTap: () => setState(() => _curMatch++),
              child: Container(
                width: 32,
                height: 32,
                padding: EdgeInsets.only(left: 2),
                decoration: ShapeDecoration(
                  color: Colors.white30,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Icon(Icons.arrow_forward_ios_outlined, size: 16, color: Colors.white,)
              ),
            )
          )
        ),
      ]
    );
  }
  
  Widget Soccer() {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
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
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            spacing: 8,
            children: List.generate(_matchList.length, (index) => SoccerItem(context, item: _matchList[index]))
          ),
        )
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
              onTap: () => _onTabSoccerChange(index),
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