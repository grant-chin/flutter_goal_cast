// ignore_for_file: non_constant_identifier_names

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_goal_cast/common/eventbus.dart';
import 'package:flutter_goal_cast/controller/match.dart';
import 'package:flutter_goal_cast/controller/user.dart';
import 'package:flutter_goal_cast/wedget/primary_btn.dart';
import 'package:flutter_goal_cast/wedget/soccer_item.dart';
import 'package:get/get.dart' hide Response;

class MinesPage extends StatefulWidget {
  const MinesPage({super.key});

  @override
  State<MinesPage> createState() => MinesPageState();
}

class MinesPageState extends State<MinesPage> {
  List _dataList = [];
  List get _openList => MatchController.matchList.where((o) => o['forecast'] == true && o['status'] == 1).toList();
  List get _closeList => MatchController.forcastFullList.where((o) => o['status'] == 6).toList();
  List get _rewardList => MatchController.rewardList;
  List get _collectionList => MatchController.matchList.where((o) => o['collected'] == true).toList();
  int get _level => UserController.level.value;
  String get _nickname => UserController.nickname.value;
  String get _points => UserController.pointStr.value;
  
  final List _tabs = ['Open', 'Closed', 'Collection'];
  int _curTab = 0;
  List _tabSoccer = ['All Matches'];
  int _curTabSoccer = 0;

  @override
  initState() {
    super.initState();
    bus.on('updateLeagues', (_) => _onTabChange(_curTab));
  }
  @override
  dispose() {
    super.dispose();
    bus.off('updateLeagues');
  }

  _onTabChange(index) {
    setState(() {
      _curTab = index;
      switch (index) {
        case 0: _dataList = _openList; break;
        case 1: _dataList = _closeList; break;
        case 2: _dataList = _collectionList; break;
      }
    });
    // MatchController.initClosedData();
    List leagues = ['All Matches'];
    for (int i = 0; i < _dataList.length; i++) {
      String league = _dataList[i]['name'];
      if (!leagues.contains(league)) {
        leagues.add(league);
      }
    }
    setState(() {
      _tabSoccer = leagues;
    });
  }

  // 右上角提示
  _showInfo() {
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (_) => Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Material(
              color: Colors.transparent,
              child: SlideInUp(
                duration: Duration(milliseconds: 200),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 550 * MediaQuery.of(context).size.width / 402,
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 36),
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage('assets/images/bg/bg_info.png'))
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      PrimaryBtn(text: 'Got it', width: MediaQuery.of(context).size.width - 32, func: () => Get.back())
                    ],
                  )
                )
              )
            )
          ],
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Color(0xFF070123),
        child: Column(
          children: [
            HeaderBox(),
            TabBox(),
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
          Obx(() => Text(_nickname, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500))),
          Spacer(),
          Container(
            height: 32,
            padding: EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFF8033D1), Color.fromRGBO(56, 41, 94, 0.6)],
                stops: [0, 1], // 调整渐变范围
              ),
              border: Border(left: BorderSide(color: Color.fromRGBO(255, 255, 255, 0.32)), top: BorderSide(color: Color.fromRGBO(255, 255, 255, 0.32))),
              borderRadius: BorderRadius.circular(8)
            ),
            child: Row(
              children: [
                Image.asset('assets/icons/bets.png', width: 16),
                SizedBox(width: 6),
                Obx(() => Text(_points, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)))
              ],
            )
          ),
          SizedBox(width: 16),
          SizedBox(
            width: 32,
            height: 32,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(0),
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFF170C34),
                shadowColor: Colors.transparent,
                overlayColor: Colors.white10,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: _showInfo,
              child: Image.asset('assets/icons/info.png', width: 16)
            ),
          )
        ],
      ),
    );
  }
  
  Widget TabBox() {
    return Container(
      height: 40,
      color: Color(0xFF12072F),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_tabs.length, (index) => GestureDetector(
          onTap: () => _onTabChange(index),
          child: Container(
            width: 112,
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
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              _curTab == 1 && _rewardList.isNotEmpty ? AvailableRewards() : Container(),
              Soccer(),
              SizedBox(height: 24),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 36)
            ]
          ),
        )
      )
    ]));
  }
  
  Widget AvailableRewards() {
    return Column(
      spacing: 12,
      children: [
        Row(
          children: [
            SizedBox(width: 16),
            Image.asset('assets/icons/icon_reward.png', width: 16),
            SizedBox(width: 4),
            Text('Available Rewards', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
          ]
        ),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Obx(() => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                spacing: 12,
                children: List.generate(_rewardList.length, (index) => GestureDetector(
                  onTap: () => {},
                  child: Container(
                    width: 187,
                    height: 112,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(0xFF12072F),
                      border: Border.all(color: Color(0xFF38295E), width: 2),
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 12,
                          children: [
                            Image.network('https://images.fotmob.com/image_resources/logo/teamlogo/${_dataList[index]['homeId']}.png', width: 40),
                            Column(
                              children: [
                                Text('${_dataList[index]['homeScore']} : ${_dataList[index]['awayScore']}', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                                Text('Full time', style: TextStyle(color: Colors.white30, fontSize: 11, fontWeight: FontWeight.w400)),
                              ]
                            ),
                            Image.network('https://images.fotmob.com/image_resources/logo/teamlogo/${_dataList[index]['awayId']}.png', width: 40),
                          ],
                        ),
                        Container(
                          width: 66,
                          height: 22,
                          decoration: BoxDecoration(
                            color: Color(0xFF01FFF7),
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(0),
                              foregroundColor: Color(0xFF070123),
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              overlayColor: Colors.black26,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: (){},
                            child: Text('Claim', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))
                          )
                        )
                      ],
                    ),
                  ),
                ))
              )
            ));
          }
        ),
        SizedBox(height: 12)
      ]
    );
  }
  
  Widget Soccer() {
    return Column(
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
        SizedBox(height: 12),
        SoccerTab(),
        SizedBox(height: 12),
        (_curTabSoccer == 0 ? _dataList : _dataList.where((xx) => xx['name'] == _tabSoccer[_curTabSoccer]).toList()).isNotEmpty ? SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            spacing: 8,
            children: List.generate(
              _curTabSoccer == 0 ? _dataList.length : _dataList.where((xx) => xx['name'] == _tabSoccer[_curTabSoccer]).length,
              (index) => SoccerItem(context, item: (_curTabSoccer == 0 ? _dataList : _dataList.where((xx) => xx['name'] == _tabSoccer[_curTabSoccer]).toList())[index], collectable: _curTab == 2, hideCollect: _curTab != 2)
            )
          ),
        ) : Container(
          height: 200,
          alignment: Alignment.center,
          child: Text('No Data', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
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