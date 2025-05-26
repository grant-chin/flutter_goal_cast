import 'package:flutter/material.dart';
import 'package:flutter_goal_cast/pages/detail/invited.dart';
import 'package:flutter_goal_cast/pages/detail/manage_player.dart';
import 'package:flutter_goal_cast/pages/detail/manage_team.dart';
import 'package:flutter_goal_cast/pages/detail/matches.dart';
import 'package:flutter_goal_cast/pages/games/kick_clash.dart';
import 'package:flutter_goal_cast/pages/games/shot_daily.dart';
import 'package:get/get.dart';
import 'common/share_pref.dart';
import 'package:flutter/services.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';

import 'pages/index.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // 设置支持的屏幕方向为竖屏（正反方向）
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SharePref.init().then((e) => runApp(MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        fontFamily: 'Manrope',
      ),
      initialRoute: '/',
      home: FlutterSplashScreen.fadeIn(
        duration: const Duration(milliseconds: 3000),
        childWidget: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Image.asset("assets/images/goal_cast.png"),
        ),
        nextScreen: const IndexPage(),
      ),
      getPages: [
        GetPage(name: '/matches', page: () => MatchesPage()),
        GetPage(name: '/invited', page: () => InvitedPage()),
        GetPage(name: '/team_manage', page: () => TeamMPage()),
        GetPage(name: '/player_manage', page: () => PlayerMPage()),

        GetPage(name: '/kick_clash', page: () => KickClash()),
        GetPage(name: '/shot_daily', page: () => ShotDaily()),
      ],
    );
  }
}
