// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_goal_cast/controller/user.dart';
import 'package:flutter_goal_cast/wedget/primary_btn.dart';
import 'package:get/get.dart';

class Utils {
  static void toast(BuildContext context, { required message }) {
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (_) => GestureDetector(
        onTap: () {
          Navigator.of(context).pop(); // 点击内容区域关闭
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(message, style: TextStyle(
              decoration: TextDecoration.none,
              color: Colors.white,
              fontFamily: 'Lato',
              fontSize: 24,
              fontWeight: FontWeight.w700
            ))
          ],
        ),
      )
    );
  }

  // 第一次进入
  static void welcomeBonus(BuildContext context) {
    Future.delayed(Duration(milliseconds: 100), () {
      globalDialog(context, title: 'Welcome Bouns', text: 'A new surprise awaits! Come back daily for free rewards.', point: 1000, callback: () {
        UserController.onFirstUse();
      });
    });
  }
  // 游戏成功
  static void gameSuccess(BuildContext context, { Function? callback }) {
    globalDialog(context, title: 'Goal! You Win!', text: 'Your shot hits the net! Well done, champion!', point: 400, xp: 50, callback: callback);
  }
  // 游戏失败
  static void gameFailed(BuildContext context, { Function? callback }) {
    globalDialog(context, title: 'Missed! You Lose!', text: 'Tough luck! Better luck next time!', xp: 20, callback: callback);
  }
  // 平局
  static void gameDraw(BuildContext context, { Function? callback }) {
    globalDialog(context, title: "It's a Draw!", text: 'A fair match — try again to take the lead!', point: 300, xp: 30, callback: callback);
  }
  // 抽奖成功
  static void shotSuccess(BuildContext context, { point, Function? callback }) {
    globalDialog(context, title: "Goal! You Win!", text: 'What a strike!', point: point, callback: callback);
  }
  // 抽奖失败
  static void shotFailed(BuildContext context, { Function? callback }) {
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: Material(
          color: Colors.black38,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 322,
                height: 296,
                padding: EdgeInsets.only(bottom: 36),
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/images/bg/bg_dialog_fail.png'))
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PrimaryBtn(text: 'Try again', width: 290, func: (){
                      Get.back();
                      if (callback != null) {
                        callback();
                      }
                    })
                  ],
                )
              )
            ],
          )
        )
      )
    );
  }

  static void globalDialog(context, { required String title, required String text, point, xp, callback }) {
    List<Widget> content = [];
    if (point != null) {
      content.add(Column(
        children: [
          Image.asset('assets/icons/bets.png', width: 64),
          Text('$point', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700))
        ],
      ));
    }
    if (xp != null) {
      content.add(Column(
        children: [
          Image.asset('assets/icons/exp.png', width: 64),
          Text('$xp', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700))
        ],
      ));
    }
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: Material(
          color: Colors.black38,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(child: BounceIn(child: Container(
                width: 322,
                height: 436,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/images/bg/bg_dialog.png'))
                ),
                child: Column(
                  children: [
                    Container(
                      height: 66,
                      alignment: Alignment.center,
                      child: Text(title, style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700, fontFamily: 'Lexend'))
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 44),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 44,
                        children: content
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      margin: EdgeInsets.only(top: 16),
                      child: Text(text, style: TextStyle(color: Colors.white70), textAlign: TextAlign.center)
                    ),
                    Spacer(),
                    PrimaryBtn(text: 'Claim', width: 290, func: (){
                      if (point != null) {
                        UserController.increasePoints(point);
                      }
                      if (xp != null) {
                        UserController.increaseXP(xp);
                      }
                      Get.back();
                      if (callback != null) {
                        callback();
                      }
                    }),
                    SizedBox(height: 32)
                  ],
                ),
              )))
            ],
          )
        )
      )
    );
  }

  static void showDailyTasks(context) {
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (_) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FadeInUpBig(
            duration: Duration(milliseconds: 200),
            child: Container(
              height: 570,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xFF12072F),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))
              ),
              child: Column(
                children: [
                  Image.asset('assets/images/bg/dialog_point.png'),
                  Image.asset('assets/images/bg/daily_tasks.png'),
                  SizedBox(height: 16),
                  Container(
                    width: MediaQuery.of(context).size.width - 32,
                    height: 76,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white30),
                      borderRadius: BorderRadius.circular(16)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Complete a forecast', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                            Row(
                              children: [
                                Text('+200', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
                                SizedBox(width: 4),
                                Image.asset('assets/icons/bets.png', width: 16)
                              ],
                            )
                          ],
                        ),
                        Container(
                          width: 66,
                          height: 30,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFFBE71FD), Color(0xFF8033D1)],
                              stops: [0, 1], // 调整渐变范围
                            ),
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(0),
                              foregroundColor: Colors.white,
                              disabledForegroundColor: Colors.white60,
                              backgroundColor: Colors.transparent,
                              disabledBackgroundColor: Color(0xFF38295E),
                              shadowColor: Colors.transparent,
                              overlayColor: Colors.black26,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: (){},
                            child: Text('Claim', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))
                          )
                        )
                        // SizedBox(
                        //   width: 49,
                        //   height: 30,
                        //   child: ElevatedButton(
                        //     style: ElevatedButton.styleFrom(
                        //       padding: EdgeInsets.all(0),
                        //       foregroundColor: Colors.white,
                        //       backgroundColor: Color(0xFF38295E),
                        //       shadowColor: Colors.transparent,
                        //       overlayColor: Colors.white10,
                        //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        //     ),
                        //     onPressed: (){},
                        //     child: Text('Go', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))
                        //   ),
                        // )
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: MediaQuery.of(context).size.width - 32,
                    height: 76,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white30),
                      borderRadius: BorderRadius.circular(16)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Participate in a competition', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                            Row(
                              children: [
                                Text('+50', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
                                SizedBox(width: 4),
                                Image.asset('assets/icons/exp.png', width: 16)
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          width: 49,
                          height: 30,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(0),
                              foregroundColor: Colors.white,
                              backgroundColor: Color(0xFF38295E),
                              shadowColor: Colors.transparent,
                              overlayColor: Colors.white10,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: (){},
                            child: Text('Go', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          )
        ],
      )
    );
  }
}