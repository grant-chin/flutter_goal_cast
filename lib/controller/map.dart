// ignore_for_file: unnecessary_null_comparison, non_constant_identifier_names

import 'dart:math';

import 'package:flutter_goal_cast/controller/user.dart';
import 'package:intl/intl.dart';
import '/common/share_pref.dart';
import 'package:get/get.dart';

var formater = DateFormat('yyyy-MM-dd HH:mm:ss');

class MapController extends GetxController {
  static final myPlayers = RxList(); // 已聘用球员
  static final levelList = RxList(); // 球员等级
  static final teamMap = RxMap(); // 阵营
  static final onlinePlayers = RxList(); // 已上场球员
  static final onlineLocation = RxList(); // 球员上场位置
  static final incomeAmount = RxInt(0); // 收入

  // 初始化
  static init() {
    myPlayers.value = SharePref.getString('myPlayers') == null ? [] : SharePref.getString('myPlayers').split(',');
    levelList.value = SharePref.getString('levelList') == null ? [] : SharePref.getString('levelList').split(',').map(int.parse).toList();
    onlinePlayers.value = SharePref.getString('onlinePlayers') == null ? [] : SharePref.getString('onlinePlayers').split(',');
    onlineLocation.value = SharePref.getString('onlineLocation') == null ? [] : SharePref.getString('onlineLocation').split(',');
    initTeam();
  }

  // 初始化当前状态
  static initTeam() {
    for (int i = 0; i < onlinePlayers.length; i++) {
      String player = onlinePlayers[i];
      String location = onlineLocation[i];
      String lastTime = SharePref.getString('player_${player}_start') ?? ''; // 开始上场时间
      int appareHour = SharePref.getInt('player_${player}_appare'); // 上场小时数
      if (lastTime != '') {
        int hours = DateTime.parse(lastTime).difference(DateTime.now()).inHours;
        incomeAmount.value = SharePref.getInt('incomeAmount') ?? 0;
        int level = levelList[myPlayers.indexOf(player)];
        if (appareHour + hours >= 24) {
          hours = 24 - appareHour; // 有效时间
        }
        if (appareHour > 18) { // 开始时状态-重度疲劳
          incomeAmount.value += 5 * level * hours;
        } else if (appareHour > 12) { // 开始时状态-中度疲劳
          if (appareHour + hours > 18) {
            incomeAmount.value += 8 * level * (18 - appareHour) + 5 * level * (appareHour + hours - 18);
          } else {
            incomeAmount.value += 8 * level * hours;
          }
        } else { // 开始时状态-满产
          if (appareHour + hours > 18) {
            incomeAmount.value += 10 * level * (12 - appareHour) + 8 * level * 6 + 5 * level * (appareHour + hours - 18);
          } else if (appareHour + hours > 12) {
            incomeAmount.value += 10 * level * (12 - appareHour) + 8 * level * (appareHour + hours - 12);
          } else {
            incomeAmount.value += 10 * level * hours;
          }
        }
        SharePref.setInt('incomeAmount', incomeAmount.value);
        
        appareHour += hours;
        SharePref.setInt('player_${player}_appare', appareHour);
        String now = formater.format(DateTime.now());
        SharePref.setString('player_${player}_start', now);
        teamMap['location_$location'] = {
          'player': player,
          'startTime': now,
          'appareHour': appareHour
        };
        if (appareHour >= 24) {
          SharePref.setString('player_${player}_start', '');
          SharePref.setInt('player_${player}_appare', 0);
          teamMap.remove('location_$location');
        }
      }
    }
  }

  // 球员上场
  static onAppear({ required int location, required int player }) {
    String lastTime = SharePref.getString('player_${player+1}_start') ?? '';
    int restTime = 0;
    int appareHour = SharePref.getInt('player_${player+1}_appare');
    if (lastTime != '') {
      restTime = DateTime.parse(lastTime).difference(DateTime.now()).inHours;
      appareHour = appareHour > restTime ? appareHour - restTime : 0;
      SharePref.setInt('player_${player+1}_appare', appareHour);
    }
    String now = formater.format(DateTime.now());
    SharePref.setString('player_${player+1}_start', now);
    teamMap['location_${location + 1}'] = {
      'player': '${player + 1}',
      'startTime': now,
      'appareHour': appareHour
    };
    onlinePlayers.add('${player + 1}');
    SharePref.setString('onlinePlayers', onlinePlayers.join(','));
    onlineLocation.add('${location + 1}');
    SharePref.setString('onlineLocation', onlineLocation.join(','));
  }

  // 聘用球员
  static onHiringPlayer(index) {
    if (myPlayers.contains('${index+1}')) return;
    UserController.decreasePoints(1000 + 500 * myPlayers.length);
    myPlayers.add('${index+1}');
    SharePref.setString('myPlayers', myPlayers.join(','));
    levelList.add(1);
    SharePref.setString('levelList', levelList.join(','));

    SharePref.setInt('player_${index+1}_appare', 0);
  }
  // 升级球员
  static onUpgradePlayer(index) {
    UserController.decreasePoints(2000 + 500 * pow(2, levelList[index] - 1).toInt());
    levelList[index] += 1;
    SharePref.setString('levelList', levelList.join(','));
  }
}