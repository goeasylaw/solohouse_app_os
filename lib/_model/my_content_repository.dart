import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:http/http.dart';
import 'package:solohouse/_model/solohouse_model.dart';
import 'package:solohouse/app_config.dart';

import '../_common/api.dart';
import '../_common/user_model.dart';
import '../_common/util.dart';

class MyContentRepository with ChangeNotifier {
  String mode = 'my';
  List<SolohouseModel> list = [];
  String startDate = '';
  bool nextPage = false;

  void initData(String mode) {
    list.clear();
    startDate = '';
    this.mode = mode;
    nextPage = false;
  }

  Future<void> load() async {
    String url = '${AppConfig().baseUrl()}/user/myList?mode=$mode';
    if (startDate != '') {
      url += '&startDate=${Uri.encodeComponent(startDate)}';
    }

    SmartDialog.showLoading();
    var response = await Api().get(Uri.parse(url));
    SmartDialog.dismiss();
    if(response.statusCode == 200) {
      SolohouseListModel data = SolohouseListModel.fromJson(jsonDecode(response.body));
      nextPage = data.nextPage!;

      for(var item in data.contentList!) {
        if(UserModel().blockContent.contains(item.contentNo)) {
          continue;
        }
        if(UserModel().blockUsers.contains(item.userInfo!.userNo)) {
          continue;
        }
        list.add(item);
      }

      if(list.isNotEmpty) {
        SolohouseModel lastItem = list.last;
        startDate = lastItem.createdAt!;
      }
    } else {
      SmartDialog.showToast('Server Error');
    }

    notifyListeners();
  }

  Future<void> loadNext() async {
    if(nextPage) {
      await load();
    }
  }

  Future<SolohouseModel?> getOne(int no) async {
    for(var item in list) {
      if(item.contentNo == no) {
        return item;
      }
    }

    SmartDialog.showLoading();
    String url = '${AppConfig().baseUrl()}/guest/contentList?contentNo=$no';
    var response = await Api().get(Uri.parse(url));
    SmartDialog.dismiss();
    if(response.statusCode == 200) {
      SolohouseListModel data = SolohouseListModel.fromJson(jsonDecode(response.body));
      return data.contentList!.first;
    } else {
      SmartDialog.showToast('Server Error');
    }

    return null;
  }


  Future<void> delete(int contentNo) async {
    SmartDialog.showLoading();
    String url = '${AppConfig().baseUrl()}/user/content?contentNo=$contentNo&disable=1';
    var response = await Api().delete2(Uri.parse(url));
    SmartDialog.dismiss();
    if(response.statusCode == 200) {
      SmartDialog.showToast('?????? ???????????????.');
    }
  }


  Future<void> like(bool isLike, int contentNo) async {
    //?????????
    var url = '${AppConfig().baseUrl()}/user/contentLike?contentNo=$contentNo';

    Response response;
    SmartDialog.showLoading();
    if(isLike) {
      response = await Api().post(Uri.parse(url));
    } else {
      response = await Api().delete2(Uri.parse(url));
    }
    SmartDialog.dismiss();

    if(checkApiError(response)) {
      return;
    }
    //?????? ???????????? ????????????.

    SolohouseModel? item = list.firstWhereOrNull((element) => element.contentNo == contentNo);
    if(item != null) {
      if(isLike) {
        item.likeCount = item.likeCount! + 1;
        item.myLike = 1;

      } else {
        item.likeCount = item.likeCount! -1;
        item.myLike = 0;
      }
    }

    notifyListeners();
  }

  Future<void> scrap(bool isScrap, int contentNo) async {
    var url = '${AppConfig().baseUrl()}/user/contentScrap?contentNo=$contentNo';

    Response response;
    SmartDialog.showLoading();
    if(isScrap) {
      response = await Api().post(Uri.parse(url));
    } else {
      response = await Api().delete2(Uri.parse(url));
    }
    SmartDialog.dismiss();

    if(checkApiError(response)) {
      return;
    }
    //?????? ???????????? ????????????.

    SolohouseModel? item = list.firstWhereOrNull((element) => element.contentNo == contentNo);
    if(item != null) {
      if(isScrap) {
        item.scrapCount  = item.scrapCount! + 1;
        item.myScrap = 1;
      } else {
        item.scrapCount = item.scrapCount! -1;
        item.myScrap = 0;
      }
    }

    notifyListeners();
  }




}