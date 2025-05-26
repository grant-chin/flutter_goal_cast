// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_goal_cast/common/utils.dart';
import 'package:flutter_goal_cast/controller/user.dart';
import 'package:flutter_goal_cast/pages/home.dart';
import 'package:flutter_goal_cast/pages/challenge.dart';
import 'package:flutter_goal_cast/pages/map.dart';
import 'package:flutter_goal_cast/pages/mines.dart';
import 'package:flutter_goal_cast/pages/profile.dart';


class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => IndexPageState();
}

class IndexPageState extends State<IndexPage> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    UserController.init();
    if (UserController.first.value != false) {
      Utils.welcomeBonus(context);
    }
  }

  /// Tab 改变
  void onTabChanged(int index) {
    setState(() {
      if (currentIndex != index) {
        currentIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          IndexedStack(
            index: currentIndex,
            children: [
              HomePage(),
              MinesPage(),
              ChallengePage(),
              MapPage(),
              ProfilePage()
            ],
          ),
          TabbarBox()
        ],
      ),
    );
  }

  Widget TabbarBox() {
    return Positioned(child: Container(
      height: 64 + MediaQuery.of(context).padding.bottom,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Color(0xFF070123),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TabbarItem(icon: 'home', text: 'Home', index: 0),
          TabbarItem(icon: 'ticket', text: 'Mines', index: 1),
          TabbarItem(icon: 'challenge', text: 'Challenge', index: 2),
          TabbarItem(icon: 'map', text: 'Map', index: 3),
          TabbarItem(icon: 'person', text: 'Profile', index: 4),
        ],
      )
    ));
  }
  Widget TabbarItem({icon, text, index}) {
    return GestureDetector(
      onTap: () => onTabChanged(index),
      child: Container(
        width: 64,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: currentIndex == index ? [Color.fromRGBO(1, 255, 247, 0), Color.fromRGBO(1, 255, 247, 0.25)] : [Colors.transparent, Colors.transparent],
            stops: [0, 1], // 调整渐变范围
          ),
          border: Border(bottom: BorderSide(color: currentIndex == index ? Color(0xFF01FFF7) : Colors.transparent))
        ),
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                currentIndex == index ? SizedBox(height: 24) : Image.asset('assets/images/tabbar/$icon.png', width: 24),
                SizedBox(height: 4),
                Text('$text', style: TextStyle(color: currentIndex == index ? Colors.white : Colors.white38, fontSize: 11, fontWeight: FontWeight.w600))
              ],
            ),
            Positioned(
              top: 2,
              child: currentIndex == index ? Pulse(child: Image.asset('assets/images/tabbar/${icon}_ac.png', width: 42)) : Container()
            )
          ],
        )
      ),
    );
  }
}
