// ignore_for_file: unnecessary_null_comparison, non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:flutter_goal_cast/common/eventbus.dart';
import 'package:flutter_goal_cast/controller/user.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import '/common/share_pref.dart';
import 'package:get/get.dart' hide Response;

var formater = DateFormat('yyyy-MM-dd');

class MatchController extends GetxController {
  static final matchList = RxList(); // 比赛列表
  static final tomorrowMatch = RxList(); // 明日比赛列表
  static final collectMatch = RxList(); // 收藏列表
  static final forecastList = RxList(); // 预测列表
  static final forecastResult = RxList(); // 预测结果列表
  static final forcastFullList = RxList(); // 预测列表-完整数据
  static final betList = RxList(); // 投注列表
  static final forecastToday = RxBool(false); // 今日是否完成预测
  static final rewardList = RxList(); // 奖励列表
  static final rewardClaimedList = RxList(); // 已领取奖励列表

  // 初始化
  static init() {
    String now = formater.format(DateTime.now());
    forecastToday.value = (SharePref.getString('forecastTime') ?? '') == now;
    forcastFullList.value = SharePref.getString('forcastFullList') == null ? [] : jsonDecode(SharePref.getString('forcastFullList'));
    rewardList.value = SharePref.getString('rewardList') == null ? [] : SharePref.getString('rewardList').split(',');
    rewardClaimedList.value = SharePref.getString('rewardClaimedList') == null ? [] : SharePref.getString('rewardClaimedList').split(',');
    getTodayData();
    getTomorrowData();
  }

  // 已结束比赛
  static initClosedData() {
    for (int i = 0; i < forcastFullList.length; i++) {
      String forcastId = '${forcastFullList[i]['id']}';
      if (matchList.where((xx) => xx['id'] == forcastId).isEmpty) {
        forcastFullList[i]['status'] = 6;
        String resultId = forecastResult[forecastList.indexOf(forcastId)];
        int homeScore = forcastFullList[i]['homeScore'];
        int awayScore = forcastFullList[i]['awayScore'];
        bool forecastHome = resultId == '${forcastFullList[i]['homeId']}';
        bool forecastAway = resultId == '${forcastFullList[i]['awayId']}';
        bool forecastDraw = resultId == '0';
        bool forecastSuccess = (forecastHome && homeScore > awayScore) || (forecastAway && homeScore < awayScore) || (forecastDraw && homeScore == awayScore);
        if (!rewardClaimedList.contains(forcastId)) {
          if (forecastSuccess) {
            if (rewardList.contains(forcastId)) return;
            rewardList.add(forcastId);
            SharePref.setString('rewardList', rewardList.join(','));
          } else {
            UserController.increaseXP(30 * UserController.level.value);
            rewardClaimedList.add(forcastId);
            SharePref.setString('rewardClaimedList', rewardClaimedList.join(','));
          }
        }
      } else if (matchList.where((xx) => xx['id'] == forcastId).toList()[0]['status'] == 6) {
        forcastFullList[i] = matchList.where((xx) => xx['id'] == forcastId).toList()[0];
        forcastFullList[i]['forecastId'] = forecastResult[forecastList.indexOf(forcastId)];
      }
    }
  }
  // 领取奖励
  static onClaimReward(id) {
    rewardList.remove(id);
    rewardClaimedList.add(id);
    SharePref.setString('rewardList', rewardList.join(','));
    SharePref.setString('rewardClaimedList', rewardClaimedList.join(','));
  }

  // 获取今日比赛数据
  static getTodayData() async {
    BaseOptions options = BaseOptions();
    options.headers['X-CMC_PRO_API_KEY'] = '4cc00188-ea57-4fb0-aa41-f5f7f4d376bc';
    Dio dio = Dio(options);
    try {
      String today = formater.format(DateTime.now());
      Response response = await dio.get('https://api.sportflashoffcial.com/sport/match/list?date=$today&timeZone=0');
      if (response.statusCode == 200) {
        var resData = response.data['data']['allMatchList'];
        for(var i = 0; i < resData.length; i++) {
          var item = resData[i];
          if (item['level'] >= 0.5) {
            for(var j = 0; j < item['matchList'].length; j++) {
              matchList.add(item['matchList'][j]);
            }
          }
        }
        matchList.sort((a, b) => a['matchTime'].compareTo(b['matchTime']));
        formatterData();
      }
    } catch (e) {
      print('请求异常: $e');
    }
  }
  // 获取明日比赛数据
  static getTomorrowData() async {
    BaseOptions options = BaseOptions();
    options.headers['X-CMC_PRO_API_KEY'] = '4cc00188-ea57-4fb0-aa41-f5f7f4d376bc';
    Dio dio = Dio(options);
    try {
      DateTime now = DateTime.now();
      String tomorrow = formater.format(DateTime(now.year, now.month, now.day + 1));
      Response response = await dio.get('https://api.sportflashoffcial.com/sport/match/list?date=$tomorrow&timeZone=0');
      if (response.statusCode == 200) {
        var resData = response.data['data']['allMatchList'];
        for(var i = 0; i < resData.length; i++) {
          var item = resData[i];
          if (item['level'] >= 0.5) {
            for(var j = 0; j < item['matchList'].length; j++) {
              tomorrowMatch.add(item['matchList'][j]);
            }
          }
        }
        tomorrowMatch.sort((a, b) => a['matchTime'].compareTo(b['matchTime']));
        formatterData();
      }
    } catch (e) {
      print('请求异常: $e');
    }
  }

  // 数据格式化
  static formatterData() {
    forecastList.value = SharePref.getString('forecastList') == null ? [] : SharePref.getString('forecastList').split(',');
    forecastResult.value = SharePref.getString('forecastResult') == null ? [] : SharePref.getString('forecastResult').split(',');
    betList.value = SharePref.getString('betList') == null ? [] : SharePref.getString('betList').split(',');
    collectMatch.value = SharePref.getString('collectMatch') == null ? [] : SharePref.getString('collectMatch').split(',');
    for(var i = 0; i < matchList.length; i++) {
      var item = matchList[i];
      if (forecastList.contains('${item['id']}')) {
        int index = forecastList.indexOf('${item['id']}');
        item['forecast'] = true;
        item['forecastId'] = forecastResult[index];
        item['bet'] = betList[index];
      }
      item['collected'] = collectMatch.contains('${item['id']}');
    }
    for(var i = 0; i < tomorrowMatch.length; i++) {
      var item = tomorrowMatch[i];
      if (forecastList.contains('${item['id']}')) {
        int index = forecastList.indexOf('${item['id']}');
        item['forecast'] = true;
        item['forecastId'] = forecastResult[index];
        item['bet'] = betList[index];
      }
      item['collected'] = collectMatch.contains('${item['id']}');
    }
    bus.emit('updateLeagues');
  }

  // 收藏
  static onCollect(item) {
    String id = '${item['id']}';
    if (collectMatch.contains(id)) {
      collectMatch.remove(id);
    } else {
      collectMatch.add(id);
    }
    SharePref.setString('collectMatch', collectMatch.join(','));
    formatterData();
  }
  // 提交预测
  static onForecast({id, forecastId, amount, required item}) {
    if (forecastList.contains('$id')) return;

    String now = formater.format(DateTime.now());
    SharePref.setString('forecastTime', now);
    forecastToday.value = true;

    forecastList.add('$id');
    forecastResult.add('$forecastId');
    betList.add('$amount');
    forcastFullList.add(item);
    SharePref.setString('forecastList', forecastList.join(','));
    SharePref.setString('forecastResult', forecastResult.join(','));
    SharePref.setString('betList', betList.join(','));
    SharePref.setString('forcastFullList', jsonEncode(forcastFullList));

    formatterData();
  }
}