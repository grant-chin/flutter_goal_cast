// ignore_for_file: non_constant_identifier_names, deprecated_member_use, use_build_context_synchronously

import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_goal_cast/common/utils.dart';
import 'package:flutter_goal_cast/controller/game.dart';
import 'package:flutter_goal_cast/controller/user.dart';
import 'package:flutter_goal_cast/wedget/primary_btn.dart';
import 'package:get/get.dart';

class KickClash extends StatefulWidget {
  const KickClash({super.key});

  @override
  State<KickClash> createState() => KickClashState();
}

class KickClashState extends State<KickClash> with SingleTickerProviderStateMixin {
  int get _freeCount => GameController.freeKick.value;
  int get _points => UserController.points.value;

  final List _type = [0, 5, 1, 4, 2, 3, 0, 5, 1, 2];
  bool _loading = false; // 开启对决动画
  bool _closeLoading = true; // 是否已关闭对决动画
  bool _start = false; // 是否已开始游戏
  bool _spining = false; // 正在旋转
  bool _overSpin = false; // 结束旋转
  double _angle = 0; // 旋转角度
  int _endIndex = 0; // 结束下标
  String _turn = ''; // 当前回合
  bool _toastYourTurn = false;
  bool _toastOppsTurn = false;
  int _roundNum = 0;
  bool _toastRound = false;
  final List _leftShots = []; // 左边抽到次数
  final List _rightShots = []; // 右边抽到次数
  int _domainCount = 0; // 剩余踢球数
  int _leftScore = 0; // 左边分数
  int _rightScore = 0; // 右边分数
  bool _spinDisabled = true;

  // 足球运动参数
  late AnimationController _controller;
  late Animation _animation;
  // 二阶贝塞尔曲线 p0：开始点、p1：控制点、p2：结束点
  Offset p0 = Offset(0,0), p1 = Offset(0,0), p2 = Offset(0,0);
  // 矩阵
  Matrix4 _matrix4 = Matrix4.identity();
  // 移动轨迹点，即移动物的中心点
  Offset? bezierCenter;
  // 当前移动距离
  Offset transSize = Offset(0.0, 0.0);
  /// 初始化动画
  _initAnim() {
    _controller = AnimationController(duration: Duration(milliseconds: 1000), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _animation.addListener(() {
      // t 动态变化的值
      var t = _animation.value;
      setState(() {
        _matrix4 = Matrix4.identity();
        // 根据二阶贝塞尔曲线计算移动轨迹点
        double left = pow(1 - t, 2) * p0.dx + 2 * t * (1 - t) * p1.dx + pow(t, 2) * p2.dx;
        double top = pow(1 - t, 2) * p0.dy + 2 * t * (1 - t) * p1.dy + pow(t, 2) * p2.dy;
        // 设置移动
        if (bezierCenter == null) {
          transSize = Offset(0.0, 0.0);
        } else {
          transSize = Offset(transSize.dx - (bezierCenter!.dx - left),
              transSize.dy - (bezierCenter!.dy - top));
        }
        _matrix4.translate(transSize.dx, transSize.dy, 0.0);
        bezierCenter = Offset(left, top);
        // 设置缩小倍数
        _matrix4.scale((1-t) < 0.3 ? 0.3 : (1-t));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initAnim();
  }

  // 重置游戏
  _resetGame() {
    setState(() {
      _loading = false; // 开启对决动画
      _closeLoading = true; // 是否已关闭对决动画
      _start = false; // 是否已开始游戏
      _spining = false; // 正在旋转
      _overSpin = false; // 结束旋转
      _angle = 0; // 旋转角度
      _endIndex = 0; // 结束下标
      _turn = ''; // 当前回合
      _toastYourTurn = false;
      _toastOppsTurn = false;
      _roundNum = 0;
      _toastRound = false;
      _leftShots.clear();
      _rightShots.clear();
      _domainCount = 0; // 剩余踢球数
      _leftScore = 0; // 左边分数
      _rightScore = 0; // 右边分数
      _spinDisabled = true;

      _controller.reset();
    });
  }

  // 开始游戏
  _startGame() async {
    if (_freeCount > 0) {
      GameController.onFreeKick();
    } else if (_points >= 200) {
      UserController.decreasePoints(200);
      setState(() => _loading = true);
      await Future.delayed(Duration(milliseconds: 4000));
      setState(() {
        _start = true;
        _closeLoading = false;
      });
      await Future.delayed(Duration(milliseconds: 500));
      setState(() => _loading = false);
      await Future.delayed(Duration(milliseconds: 500));
      _onNextRound();
    }
  }

  // 抽取次数
  _onSpin() async {
    if (_spining) return;
    setState(() {
      _spinDisabled = true;
      _overSpin = false;
      _spining = true;
      int oldIndex = _endIndex;
      _endIndex = Random().nextInt(20);
      _angle += 360 * 2 + oldIndex * 9 - _endIndex * 9;
    });
    await Future.delayed(Duration(seconds: 5));
    int type = _type[_endIndex % 10];
    setState(() {
      switch(_turn) {
        case 'left': _leftShots.add(type); break;
        case 'right': _rightShots.add(type); break;
      }
      _overSpin = true;
      _spining = false;
    });
    if (type == 0) {
      await Future.delayed(Duration(seconds: 1));
      _turn == 'left' ? _onOppsTurn() : _onNextRound();
    } else {
      setState(() => _domainCount = type);
      _onKickBall();
      await Future.delayed(Duration(seconds: type * 2));
      _turn == 'left' ? _onOppsTurn() : _onNextRound();
    }
  }

  // 踢球动画
  _onKickBall() {
    if (p0 != Offset.zero) _controller.reset();
    Size size = MediaQuery.of(context).size;
    double scale =  size.width / 402;
    int xP1 = Random().nextInt(250) - 100;
    int yP1 = Random().nextInt(200) - 100;
    int xP2 = Random().nextInt(300) - 100 - 50;
    int yP2 = Random().nextInt(80) + 80;

    if (xP2 > -50 && xP2 < 80) {
      Future.delayed(Duration(seconds: 1), () {
        switch(_turn) {
          case 'left': setState(() => _leftScore++); break;
          case 'right': setState(() => _rightScore++); break;
        }
      });
    } else {
      setState(() {
        xP2 < 0 ? xP2 -= 100 : xP2 += 100;
      });
    }
    setState(() {
      p0 = Offset(size.width/2, size.height/2);
      p1 = Offset(size.width/2 + xP1 * scale, yP1 * scale); // -100 200
      p2 = Offset(size.width/2 + xP2 * scale, size.height/2 - yP2 * scale); // -50 80 / 80 160
    });
    _controller.forward();

    setState(() => _domainCount--);
    if (_domainCount > 0) {
      Future.delayed(Duration(milliseconds: 2000), (){
        _controller.reset();
        _onKickBall();
      });
    }
  }

  // 下一回合
  _onNextRound() async {
    if (p0 != Offset.zero) _controller.reset();
    if (_roundNum == 3) {
      _gameOver();
      return;
    }
    setState(() {
      _roundNum++;
      _toastRound = true;
    });
    await Future.delayed(Duration(milliseconds: 2000));
    setState(() => _toastRound = false);
    await Future.delayed(Duration(milliseconds: 1000));
    _onYourTurn();
  }
  // 弹窗-你的回合
  _onYourTurn() async {
    if (p0 != Offset.zero) _controller.reset();
    setState(() => _turn = 'left');
    setState(() => _toastYourTurn = true);
    await Future.delayed(Duration(milliseconds: 2000));
    setState(() => _toastYourTurn = false);
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() => _spinDisabled = false);
  }
  // 弹窗-对手的回合
  _onOppsTurn() async {
    if (p0 != Offset.zero) _controller.reset();
    setState(() => _turn = 'right'); 
    setState(() => _toastOppsTurn = true);
    await Future.delayed(Duration(milliseconds: 2000));
    setState(() => _toastOppsTurn = false);
    await Future.delayed(Duration(milliseconds: 1000));
    _onSpin();
  }
  // 游戏结束
  _gameOver() async {
    await Future.delayed(Duration(milliseconds: 1000));
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: Material(
          color: Colors.black26,
          child: OverScore(),
        )
      )
    );
    Future.delayed(Duration(milliseconds: 2000), () {
      Get.back();
      if (_leftScore > _rightScore) {
        Utils.gameSuccess(context, callback: _resetGame);
      } else if (_rightScore > _leftScore) {
        Utils.gameFailed(context, callback: _resetGame);
      } else {
        Utils.gameDraw(context, callback: _resetGame);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Color(0xFF070123),
          image: DecorationImage(image: AssetImage('assets/images/game1/bg_park.png'), fit: BoxFit.cover)
        ),
        child: Stack(
          children: [
            _start ? MainBox() : FlashBox(),
            Loading()
          ],
        ),
      )
    );
  }
  
  Widget NavBar() {
    return Container(
      height: 56 + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 16, right: 16),
      color: _start ? Color(0xFF070123) : Colors.transparent,
      child: Row(
        crossAxisAlignment: _start ? CrossAxisAlignment.center : CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 36,
              height: 36,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: _start ? Colors.transparent : Colors.white30,
                borderRadius: BorderRadius.circular(32)
              ),
              child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 14),
            )
          ),
          SizedBox(width: 8),
          _start ? Text('Kick clash', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)) : Container()
        ],
      ),
    );
  }
  
  Widget FlashBox() {
    double scale =  MediaQuery.of(context).size.height / 640;
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(children: [NavBar()]),
        ),
        Positioned(top: MediaQuery.of(context).padding.top + 28, child: ElasticIn(delay: Duration(milliseconds: 500), child: Image.asset('assets/images/game1/title.png', width: 200))),
        Positioned(top: 200 * scale, child: FadeInRightBig(duration: Duration(milliseconds: 500), child: Image.asset('assets/images/game1/football_net.png', height: 200 * scale))),
        Positioned(top: 420 * scale, child: FadeInLeftBig(delay: Duration(seconds: 1), duration: Duration(seconds: 2), child: Spin(spins: 5, duration: Duration(seconds: 3), child: Image.asset('assets/images/game1/football.png', height: 48 * scale)))),
        Positioned(
          bottom: MediaQuery.of(context).padding.bottom + 32,
          child: ElasticIn(delay: Duration(milliseconds: 500), child: Obx(() => PrimaryBtn(
            text: 'Free start ($_freeCount)',
            width: MediaQuery.of(context).size.width - 32,
            func: _startGame,
            child: _freeCount > 0 ? null : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 4,
              children: [
                Text('Play for 200', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                Image.asset('assets/icons/bets.png', width: 16)
              ]
            ), 
          )))
        ),
      ],
    );
  }

  Widget MainBox() {
    double scale =  MediaQuery.of(context).size.width / 402;
    return Column(
      children: [
        NavBar(),
        Expanded(child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Positioned(top: 0, child: Image.asset('assets/images/game1/bg_park.png', width: MediaQuery.of(context).size.width)),
            ScoreBox(),
            Positioned(top: 150 * scale, child: Image.asset('assets/images/game1/football_net.png', height: 200)),
            Positioned(top: 360 * scale, child: Transform(
              transform: _matrix4,
              child: Image.asset('assets/images/game1/football.png', height: 56 * scale))
            ),
            Positioned(
              top: 490 * scale,
              child: Container(
                width: 1100,
                height: 1100,
                decoration: BoxDecoration(
                  color: Color(0xFF070123),
                  borderRadius: BorderRadius.circular(1100),
                  image: DecorationImage(image: AssetImage('assets/images/game1/bg_wheel.png'), fit: BoxFit.cover)
                ),
                child: SpinWheel()
              )
            ),
            Positioned(top: 490 * scale, child: _overSpin ? BounceIn(child: Image.asset('assets/images/game1/wheel_shot_${_type[_endIndex % 10]}.png', width: 92)) : Container()),
            Positioned(top: 570 * scale, child: Image.asset('assets/images/game1/wheel_point.png', width: 24)),
            Positioned(
              top: 660 * scale,
              child: BounceIn(
                child: _turn != 'right' ? 
                  PrimaryBtn(text: 'Spin', width: MediaQuery.of(context).size.width - 32, func: _spinDisabled ? null : _onSpin) 
                : _turn == 'right' ? Text("Opponent's turn", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)) : Container()
              )
            ),
            // 提示-当前回合
            Positioned(
              top: 250 * scale,
              child: FlipInX(animate: _toastRound, child: Container(
                width: 300,
                height: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/images/game1/bg_round.png'))
                ),
                child: Text('Round $_roundNum', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700, shadows: [
                  Shadow(
                    color: Colors.black26, // 阴影颜色
                    offset: Offset(0, 4), // 阴影偏移量 (水平, 垂直)
                    blurRadius: 4, // 阴影模糊程度
                  ),
                ]))
              ))
            ),
            // 提示-你的回合
            Positioned(top: 250 * scale, child: FlipInX(animate: _toastYourTurn, child: Image.asset('assets/images/game1/turn_me.png', height: 100))),
            // 提示-对手回合
            Positioned(top: 250 * scale, child: FlipInX(animate: _toastOppsTurn, child: Image.asset('assets/images/game1/turn_opponent.png', height: 100))),
          ],
        ))
      ],
    );
  }
  Widget ScoreBox() {
    return Positioned(top: 24, child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: _turn == '' ? Image.asset('assets/images/game1/bg_score.png', width: 370, height: 48) : Container()
          ),
          Positioned(top: -16, right: (MediaQuery.of(context).size.width - 370) / 2, child: FadeIn(animate: _turn == 'left', child: Image.asset('assets/images/game1/bg_score_left.png', height: 88))),
          Positioned(top: -16, left: (MediaQuery.of(context).size.width - 370) / 2, child: FadeIn(animate: _turn == 'right', child: Image.asset('assets/images/game1/bg_score_right.png', height: 88))),
          Positioned(child: SizedBox(
            width: 370,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 8,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border.all(color: _turn != 'left' ? Colors.grey : Color.fromRGBO(231, 12, 12, 0.5), width: 2),
                        borderRadius: BorderRadius.circular(48),
                        image: DecorationImage(image: AssetImage('assets/images/avator.png'))
                      ),
                    ),
                    Column(
                      spacing: 6,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Thomas021', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500, height: 1)),
                        Row(
                          spacing: 8,
                          children: List.generate(3, (index) => TurnItem('left', index)),
                        )
                      ],
                    )
                  ],
                ),
                Row(
                  spacing: 2,
                  children: [
                    Text('$_leftScore', style: TextStyle(color: Colors.white70, fontSize: 24, fontWeight: FontWeight.w700, fontFamily: 'Lexend')),
                    Text(':', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                    Text('$_rightScore', style: TextStyle(color: Colors.white70, fontSize: 24, fontWeight: FontWeight.w700, fontFamily: 'Lexend')),
                  ],
                ),
                Row(
                  spacing: 8,
                  children: [
                    Column(
                      spacing: 6,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Thomas021', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500, height: 1)),
                        Row(
                          spacing: 8,
                          children: List.generate(3, (index) => TurnItem('right', index)),
                        )
                      ],
                    ),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border.all(color: _turn != 'right' ? Colors.grey : Color.fromRGBO(17, 101, 228, 0.5), width: 2),
                        borderRadius: BorderRadius.circular(48),
                        image: DecorationImage(image: AssetImage('assets/images/avator_system.png'))
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
  Widget TurnItem(type, index) {
    List shots = type == 'left' ? _leftShots : _rightShots;
    return _roundNum > index && shots.length > index ? Container(
      width: 20,
      height: 20,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(image: AssetImage('assets/icons/icon_football.png'))
      ),
      child: shots[index] == 0 ? Container(
        color: Colors.black38,
        alignment: Alignment.center,
        child: Text('BOMB', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700, height: 0.9), textAlign: TextAlign.center)
      ) : Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 20,
            height: 12,
            alignment: Alignment.center,
            color: Colors.black38,
            child: Text('x${shots[index]}', style: TextStyle(color: Color(0xFF01FFF7), fontSize: 10, fontWeight: FontWeight.w500, height: 1)),
          )
        ],
      )
    ) : Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.white30,
        borderRadius: BorderRadius.circular(20)
      )
    );
  }
  Widget SpinWheel() {
    return AnimatedRotation(
      duration: Duration(seconds: 5),
      curve: Easing.legacy,
      turns: _angle / 360,
      child: Stack(
        alignment: Alignment.center,
        children: List.generate(20, (index) => Positioned(child: _overSpin && _endIndex == index ? Container() : FadeIn(child: Image.asset('assets/images/game1/spin_${index+1}.png', height: 1076 * cos(9 * index / 180 * pi).abs() + 73 * sin(9 * index / 180 * pi).abs()))))
      )
    );
  }

  Widget Loading() {
    return Positioned(child: _loading ? Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/game1/bg_loading.png'), fit: BoxFit.cover)
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 162,
            child: Transform.rotate(angle: -15 * pi / 180, child: FadeInLeftBig(
              animate: _closeLoading,
              from: 1000,
              duration: Duration(milliseconds: 500),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset('assets/images/game1/bg_red.png', height: 160),
                  Positioned(
                    left: 120,
                    child: Container(
                      width: 80,
                      height: 80,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage('assets/images/avator.png')),
                        border: Border.all(color: Color(0xFFE70C0C), width: 2),
                        borderRadius: BorderRadius.circular(80)
                      ),
                    )
                  ),
                  Positioned(left: 234, child: PlayerNameBox(name: 'Thomas021'))
                ],
              )
            ))
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height / 2 - 162,
            child: Transform.rotate(angle: -15 * pi / 180, child: FadeInRightBig(
              animate: _closeLoading,
              from: 1000,
              duration: Duration(milliseconds: 500),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset('assets/images/game1/bg_blue.png', height: 160),
                  Positioned(
                    right: 120,
                    child: Container(
                      width: 80,
                      height: 80,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage('assets/images/avator_system.png')),
                        border: Border.all(color: Color(0xFF1165E4), width: 2),
                        borderRadius: BorderRadius.circular(80)
                      ),
                    )
                  ),
                  Positioned(right: 234, child: PlayerNameBox(name: 'System111', right: true)),
                ],
              )
            ))
          ),
          Positioned(child: _closeLoading ? BounceIn(
            animate: _closeLoading,
            delay: Duration(milliseconds: 2000),
            // duration: Duration(milliseconds: 400),
            child: Image.asset('assets/images/game1/bg_VS.png', width: 120)
          ) : Container())
        ],
      ),
    ) : Container());
  }
  Widget PlayerNameBox({required String name, bool? right}) {
    return Column(
      crossAxisAlignment: right != null ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(name, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700, fontFamily: 'Lexend')),
        SizedBox(height: 8),
        Row(
          spacing: 12,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(32)
              ),
              child: right != null ? BackInLeft(delay: Duration(milliseconds: 700), child: Image.asset('assets/icons/icon_football.png')) : BackInRight(delay: Duration(milliseconds: 300), child: Image.asset('assets/icons/icon_football.png')),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(32)
              ),
              child: right != null ? BackInLeft(delay: Duration(milliseconds: 500), child: Image.asset('assets/icons/icon_football.png')) : BackInRight(delay: Duration(milliseconds: 500),child: Image.asset('assets/icons/icon_football.png')),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(32)
              ),
              child: right != null ? BackInLeft(delay: Duration(milliseconds: 300), child: Image.asset('assets/icons/icon_football.png')) : BackInRight(delay: Duration(milliseconds: 700),child: Image.asset('assets/icons/icon_football.png')),
            ),
          ],
        )
      ],
    );
  }

  Widget OverScore() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: MediaQuery.of(context).size.height / 2 - 200,
          child: FadeInLeftBig(
            from: 1000,
            duration: Duration(milliseconds: 500),
            child: Container(
              width: 500,
              height: 160,
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/game1/bg_red.png'))
              ),
              child: Row(
                spacing: 58,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage('assets/images/avator_system.png')),
                      border: Border.all(color: Color(0xFFE70C0C), width: 2),
                      borderRadius: BorderRadius.circular(80)
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('$_leftScore', style: TextStyle(color: Colors.white, fontSize: 56, fontWeight: FontWeight.w700, fontFamily: 'Lexend', height: 1)),
                      Text('Thomas021', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                    ],
                  )
                ],
              )
            ),
          )
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 2 - 200 + 160,
          child: FadeInRightBig(
            from: 1000,
            duration: Duration(milliseconds: 500),
            child: Container(
              width: 500,
              height: 160,
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/game1/bg_blue.png'))
              ),
              child: Row(
                spacing: 58,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('$_rightScore', style: TextStyle(color: Colors.white, fontSize: 56, fontWeight: FontWeight.w700, fontFamily: 'Lexend', height: 1)),
                      Text('Thomas021', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage('assets/images/avator_system.png')),
                      border: Border.all(color: Color(0xFF1165E4), width: 2),
                      borderRadius: BorderRadius.circular(80)
                    ),
                  ),
                ],
              )
            ),
          )
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 2 - 40 - 60,
          child: FadeIn(delay: Duration(milliseconds: 400), child: Image.asset('assets/images/game1/bg_VS.png', width: 120))
        ),
      ],
    );
  }
}