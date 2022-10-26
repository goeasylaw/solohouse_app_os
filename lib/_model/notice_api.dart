import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../_common/api.dart';
import '../_common/util.dart';
import '../app_config.dart';
import 'notice_model.dart';

class NoticeApi with ChangeNotifier, DiagnosticableTreeMixin {
  bool loading = true;

  int page = 0;
  int pagesize = 20;
  bool nextpage = false;

  List<NoticeListItem> list = [];

  Future<void> loadPage() async {
    loading = true;

    var param = '?page=$page';

    var url = '${AppConfig().baseUrl()}/guest/noticeList$param';

    var response = await Api().get(Uri.parse(url));

    if(checkApiError(response))
      return;

    var noticeList = NoticeListData.fromJson(jsonDecode(response.body));
    page = noticeList.page!;
    pagesize = noticeList.pagesize!;
    nextpage = noticeList.nextpage!;
    list = list + noticeList.noticeList!;

    loading = false;
    notifyListeners();
  }

  void initData() {
    page = 0;
    pagesize = 20;
    nextpage = false;
    list.clear();
  }

  void reloadPage() {
    initData();
    loadPage();
  }

  void loadNextPage() {
    if(nextpage) {
      page = page + 1;
      loadPage();
    }
  }
}

class NoticeViewModel with ChangeNotifier {
  NoticeViewModel(this.noticeNo);
  final int noticeNo;

  bool loading = true;

  late NoticeViewData detail;

  Future<void> loadPage() async {
    loading = true;

    var param = '?noticeNo=$noticeNo';

    var url = '${AppConfig().baseUrl()}/guest/notice$param';

    var response = await Api().get(Uri.parse(url));

    if(checkApiError(response))
      return;

    detail = NoticeViewData.fromJson(jsonDecode(response.body));

    loading = false;

    notifyListeners();
  }

  void reloadPage() {
    loadPage();
  }
}