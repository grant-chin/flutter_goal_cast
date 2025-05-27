// ignore_for_file: unnecessary_null_comparison, non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '/common/share_pref.dart';
import 'package:get/get.dart' hide Response;

var formater = DateFormat('yyyy-MM-dd');

class MatchController extends GetxController {
  static final matchList = RxList(); // 比赛列表

  // 初始化
  static init() async {
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
          matchList.add(item['matchList'][0]);
        }
      }
    } catch (e) {
      print('请求异常: $e');
    }
  }
}