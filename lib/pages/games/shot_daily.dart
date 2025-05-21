// ignore_for_file: non_constant_identifier_names, type_literal_in_constant_pattern

import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_goal_cast/wedget/primary_btn.dart';
import 'package:get/get.dart';

class ShotDaily extends StatefulWidget {
  const ShotDaily({super.key});

  @override
  State<ShotDaily> createState() => ShotDailyState();
}

class ShotDailyState extends State<ShotDaily> with SingleTickerProviderStateMixin {
  final _scrollControllers = List.generate(5, (_) => ScrollController());
  final List<String> _ballList = ['basketball', 'soccer', 'volleyball', 'tennis', 'golf'];
  final List<double> _randomOffsets = [0, 0, 0, 0, 0];
  final List<int> _randomEndIndex = [0, 0, 0, 0, 0];
  late AnimationController _animationController;
  final double _itemHeight = 80;
  bool runing = false;
  int _endingCount = 0;

  final List _combinations = [
    {
      'items': ['circle', 'circle', 'circle', 'circle', 'circle'],
      'reword': 300
    },
    {
      'items': ['circle', 'circle', 'circle', 'circle', 'other'],
      'reword': 150
    },
    {
      'items': ['circle', 'circle', 'circle', 'ring', 'ring'],
      'reword': 100
    },
    {
      'items': ['circle', 'circle', 'circle', 'other', 'other'],
      'reword': 50
    },
    {
      'items': ['circle', 'circle', 'ring', 'ring', 'other'],
      'reword': 30
    },
    {
      'items': ['circle', 'circle', 'other', 'other', 'other'],
      'reword': 10
    },
  ];
  int _bingoIndex = -1;

  @override
  void initState() {
    super.initState();
    setState(() => runing = true);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollControllers.asMap().forEach((index, controller) {
        controller.animateTo(
          354 + MediaQuery.of(context).padding.top,
          duration: Duration(seconds: 1),
          curve: Curves.bounceIn,
        );
      });
    });
  }

  // 开始抽奖
  void _startSpin() {
    if (runing) return;
    _animationController.reset();
    setState(() => runing = true);
    setState(() => _bingoIndex = -1);

    _scrollControllers.asMap().forEach((index, controller) {
      controller.animateTo(
        getRandom(index),
        duration: Duration(seconds: 3),
        curve: Curves.easeOutQuart,
      );
    });
  }
  // 递归随机数生成
  getRandom(index) {
    int endIndex = (Random().nextInt(20) + 5);
    double randomOffset = endIndex * _itemHeight * 6 - 46 + MediaQuery.of(context).padding.top; // 保证完整滚动圈数
    if (randomOffset > _randomOffsets[index] - 1000 && randomOffset < _randomOffsets[index] + 1000) {
      randomOffset += _itemHeight * 20;
    }
    setState(() {
      _randomEndIndex[index] = endIndex % 5;
      _randomOffsets[index] = randomOffset;
    });
    return randomOffset;
  }

  // 结束抽奖
  void _endSpin() {
    setState(() {
      _endingCount++;
      if (_endingCount / 5 % 1 == 0 && _endingCount / 5 > 0) {
        runing = false;
      }
    });
    if (runing || _endingCount <= 5) return;

    int bingoIndex = -1;
    Map count = _countRanks();
    if (count.values.any((count) => count == 5)) {
      bingoIndex = 0;
    } else if (count.values.any((count) => count == 4)) {
      bingoIndex = 1;
    } else if (count.values.any((count) => count == 3)) {
      if (count.length == 2) {
        bingoIndex = 2;
      } else {
        bingoIndex = 3;
      }
    } else if (count.values.any((count) => count == 2)) {
      if (count.length == 3) {
        bingoIndex = 4;
      } else {
        bingoIndex = 5;
      }
    }
    setState(() {
      _bingoIndex = bingoIndex;
    });
  }
  Map _countRanks() {
    final counts = <int, int>{};
    for (final rank in _randomEndIndex) {
      counts[rank] = (counts[rank] ?? 0) + 1;
    }
    return counts;
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/game2/bg.png'), fit: BoxFit.cover)
        ),
        child: Column(
          children: [
            NavBar(),
            MachineBox(),
            ConbinationBox(),
            SizedBox(height: 16),
            PrimaryBtn(text: 'Free shoot (3)', width: MediaQuery.of(context).size.width - 48, func: _startSpin)
          ],
        ),
      ),
    );
  }

  Widget NavBar() {
    return Container(
      height: 56,
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 26,
              height: 26,
              color: Colors.transparent,
              padding: EdgeInsets.all(4),
              child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 14),
            )
          ),
          SizedBox(width: 8),
          Text('Shot daily', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
  
  Widget MachineBox() {
    double scale =  MediaQuery.of(context).size.width / 402;
    return Bounce(child: Container(
      margin: EdgeInsets.only(top: 16),
      width: MediaQuery.of(context).size.width,
      height: 310 * scale,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/game2/shot_machine.png'), fit: BoxFit.cover)
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 122 * scale,
            child: SizedBox(
              width: 356 * scale,
              height: 166 * scale,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    spacing: 4,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) => _scrollItem(index))
                  ),
                  Positioned(child: Container(
                    width: 344 * scale,
                    height: 166 * scale,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color.fromRGBO(42, 8, 78, 1), Color.fromRGBO(42, 8, 78, 0)],
                        stops: [0, 0.4], // 调整渐变范围
                      ),
                    ),
                  )),
                  Positioned(child: Container(
                    width: 344 * scale,
                    height: 166 * scale,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Color.fromRGBO(42, 8, 78, 1), Color.fromRGBO(42, 8, 78, 0)],
                        stops: [0, 0.4], // 调整渐变范围
                      ),
                    ),
                  ))
                ],
              ),
            )
          ),
          Positioned(top: 196 * scale, child: Image.asset('assets/images/game2/machine_point.png', width: 364 * scale)),
        ],
      )
    ));
  }
  Widget _scrollItem(index) {
    double scale =  MediaQuery.of(context).size.width / 402;
    return SizedBox(
      width: 64 * scale,
      height: 166 * scale,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          switch (notification.runtimeType) {
            case ScrollEndNotification: _endSpin(); break;
          }
          return true;
        },
        child: ListView.builder(
          controller: _scrollControllers[index],
          physics: NeverScrollableScrollPhysics(),
          itemCount: 600, // 确保足够滚动长度
          itemBuilder: (_, i) => Container(
            height: _itemHeight,
            alignment: Alignment.center,
            child: Image.asset('assets/images/game2/ball_${_ballList[i%5]}.png', width: 64),
          ),
        ),
      ),
    );
  }

  Widget ConbinationBox() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Image.asset('assets/images/game2/title_combination.png'),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color.fromRGBO(18, 7, 47, 0.72),
              border: Border.all(color: Color(0xFF38295E)),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8))
            ),
            child: Column(
              spacing: 8,
              children: List.generate(_combinations.length, (index) => ConbinationItem(index))
            ),
          )
        ],
      ),
    );
  }
  Widget ConbinationItem(int index) {
    List items = _combinations[index]['items'];
    int reword = _combinations[index]['reword'];
    return FadeInRightBig(
      delay: Duration(milliseconds: 100 * (index + 1)),
      duration: Duration(milliseconds: 500),
      child: HeartBeat(
        animate: _bingoIndex == index,
        child: Container(
          height: 32 * MediaQuery.of(context).size.width / 402,
          padding: EdgeInsets.only(left: 8, right: 16),
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/images/game2/box_${_bingoIndex == index ? 'bingo' : 'default'}.png'))
          ),
          child: Row(
            children: [
              Row(
                spacing: 12,
                children: List.generate(items.length, (ii) => CircleItem(items[ii], _bingoIndex == index))
              ),
              Spacer(),
              Image.asset('assets/icons/bets.png', width: 16),
              SizedBox(width: 5),
              Text('$reword', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w700))
            ],
          )
        )
      )
    );
  }
  Widget CircleItem(String type, bool bingo) {
    return Container(
      width: 16,
      height: 16,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white30,
        borderRadius: BorderRadius.circular(16)
      ),
      child: type != 'other' ? Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: bingo ? Colors.white : Color(0xFF38295E),
          borderRadius: BorderRadius.circular(12)
        ),
        child: type == 'ring' ? Container(
          decoration: BoxDecoration(
            color: bingo ? Color(0xFF8033D1) : Colors.white30,
            borderRadius: BorderRadius.circular(12)
          ),
        ) : Container()
      ) : Container()
    );
  }
}