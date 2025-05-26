// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
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
      globalDialog(context, title: 'Welcome Bouns', text: 'A new surprise awaits! Come back daily for free rewards.', point: 1000, callback: (){});
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

  static void globalDialog(context, { title, text, point, xp, callback }) {
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
          child: BounceIn(child: Stack(
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
                      child: Text('Goal! You Win!', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700, fontFamily: 'Lexend'))
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
                      child: Text('Your shot hits the net! Well done, champion!', style: TextStyle(color: Colors.white70), textAlign: TextAlign.center)
                    ),
                    Spacer(),
                    PrimaryBtn(text: 'Claim', width: 290, func: (){
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
          )),
        )
      )
    );
  }
}