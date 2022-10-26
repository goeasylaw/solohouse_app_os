import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:solohouse/_model/reply_model.dart';
import 'package:solohouse/_model/solohouse_model.dart';
import 'package:solohouse/_model/solohouse_repository.dart';

import '../_common/api.dart';
import '../_common/util.dart';
import '../app_config.dart';

class ReplyRepository with ChangeNotifier {
  ReplyRepository(this.contentNo);
  final int contentNo;
  bool loading = true;
  int page = 0;
  int pageSize = 20;
  bool nextPage = false;

  List<ReplyItemModel> list = [];

  Future<void> load() async {
    loading = true;

    var param = '?contentNo=$contentNo';
    param = '$param&page=$page';
    param = '$param&pageSize=$pageSize';

    var url = '${AppConfig().baseUrl()}/guest/contentReplyList$param';

    SmartDialog.showLoading();
    var response = await Api().get(Uri.parse(url));
    SmartDialog.dismiss();

    if(checkApiError(response)) {
      return;
    }


    ReplyListModel res = ReplyListModel.fromJson(jsonDecode(response.body));
    list = list + res.replyList;
    nextPage = res.nextPage;

    loading = false;

    notifyListeners();
  }


  Future<void> loadNextPage() async {
    page++;
    if(nextPage) {
      load();
    }
  }

  void init() {
    loading = true;
    page = 0;
    pageSize = 20;
    nextPage = false;
    list.clear();
    notifyListeners();
  }


  Future<void> replyDelete(int replyNo) async {
    var url = '${AppConfig().baseUrl()}/user/contentReply?replyNo=$replyNo';

    var response = await Api().delete2(Uri.parse(url));

    checkApiError(response);

    init();
    load();
  }

  Future<void> replyWrite(int contentNo, String reply) async {
    var url = '${AppConfig().baseUrl()}/user/contentReply?contentNo=$contentNo';

    var body = {
      'message': reply
    };

    SmartDialog.showLoading();
    var response = await Api().post(Uri.parse(url), body: body);
    SmartDialog.dismiss();

    checkApiError(response);

    SolohouseModel? item = SolohouseRepository().list.firstWhereOrNull((element) => element.contentNo == contentNo);
    if(item != null) {
      item.replyCount = item.replyCount! + 1;
      SolohouseRepository().notifyListeners();
    }


    init();
    load();
  }

}