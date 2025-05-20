// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_goal_cast/wedget/challenge.dart';

class ChallengePage extends StatefulWidget {
  const ChallengePage({super.key});

  @override
  State<ChallengePage> createState() => ChallengePageState();
}

class ChallengePageState extends State<ChallengePage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Color(0xFF070123),
        child: Column(
          children: [
            HeaderBox(),
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                spacing: 16,
                children: [
                  DailyTasks(),
                  InvitedFriends(),
                  BoxChallenge()
                ],
              )
            )
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
          ),
          SizedBox(width: 8),
          Text('Thomas021', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
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
                SizedBox(width: 4),
                Text('1000', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500))
              ],
            )
          )
        ],
      ),
    );
  }

  Widget DailyTasks() {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/bg/box_daily_tasks.png'))
      ),
      child: Row(
        children: [
          SizedBox(width: 92),
          Text('Daily tasks', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
          Spacer(),
          SizedBox(
            width: 59,
            height: 32,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(0),
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFF01FFF7),
                shadowColor: Colors.transparent,
                overlayColor: Colors.black26,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: (){},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Go', style: TextStyle(color: Color(0xFF070123), fontSize: 12, fontWeight: FontWeight.w700)),
                  SizedBox(width: 2),
                  Icon(Icons.call_made, color: Colors.black, size: 16)
                ],
              )
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
    );
  }
  Widget InvitedFriends() {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/bg/box_invited_friends.png'))
      ),
      child: Row(
        children: [
          SizedBox(width: 92),
          Text('Invited friends', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
          Spacer(),
          SizedBox(
            width: 75,
            height: 32,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(0),
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFF01FFF7),
                shadowColor: Colors.transparent,
                overlayColor: Colors.black26,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: (){},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Share', style: TextStyle(color: Color(0xFF070123), fontSize: 12, fontWeight: FontWeight.w700)),
                  SizedBox(width: 2),
                  Icon(Icons.call_made, color: Colors.black, size: 16)
                ],
              )
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
    );
  }
}