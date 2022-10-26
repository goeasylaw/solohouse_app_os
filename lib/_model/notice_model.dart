/// timestamp : "2021-10-08T10:52:40.287907"
/// page : 0
/// pagesize : 20
/// nextpage : false
/// noticeList : [{"noticeNo":1,"title":"title","isShow":1,"createdAt":"2021-06-17 10:31:17"}]

class NoticeListData {
  NoticeListData({
      String? timestamp, 
      int? page, 
      int? pagesize, 
      bool? nextpage, 
      List<NoticeListItem>? noticeList,}){
    _timestamp = timestamp;
    _page = page;
    _pagesize = pagesize;
    _nextpage = nextpage;
    _noticeList = noticeList;
}

  NoticeListData.fromJson(dynamic json) {
    _timestamp = json['timestamp'];
    _page = json['page'];
    _pagesize = json['pagesize'];
    _nextpage = json['nextpage'];
    if (json['noticeList'] != null) {
      _noticeList = [];
      json['noticeList'].forEach((v) {
        _noticeList?.add(NoticeListItem.fromJson(v));
      });
    }
  }
  String? _timestamp;
  int? _page;
  int? _pagesize;
  bool? _nextpage;
  List<NoticeListItem>? _noticeList;

  String? get timestamp => _timestamp;
  int? get page => _page;
  int? get pagesize => _pagesize;
  bool? get nextpage => _nextpage;
  List<NoticeListItem>? get noticeList => _noticeList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['timestamp'] = _timestamp;
    map['page'] = _page;
    map['pagesize'] = _pagesize;
    map['nextpage'] = _nextpage;
    if (_noticeList != null) {
      map['noticeList'] = _noticeList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// noticeNo : 1
/// title : "title"
/// isShow : 1
/// createdAt : "2021-06-17 10:31:17"

class NoticeListItem {
  NoticeListItem({
      int? noticeNo, 
      String? title, 
      int? isShow, 
      String? createdAt,}){
    _noticeNo = noticeNo;
    _title = title;
    _isShow = isShow;
    _createdAt = createdAt;
}

  NoticeListItem.fromJson(dynamic json) {
    _noticeNo = json['noticeNo'];
    _title = json['title'];
    _isShow = json['isShow'];
    _createdAt = json['createdAt'];
  }
  int? _noticeNo;
  String? _title;
  int? _isShow;
  String? _createdAt;

  int? get noticeNo => _noticeNo;
  String? get title => _title;
  int? get isShow => _isShow;
  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['noticeNo'] = _noticeNo;
    map['title'] = _title;
    map['isShow'] = _isShow;
    map['createdAt'] = _createdAt;
    return map;
  }
}


class NoticeViewData {
  NoticeViewData({
    String? timestamp,
    String? title,
    String? content,
    String? url,
    int? isShow,
    String? createdAt,}){
    _timestamp = timestamp;
    _title = title;
    _content = content;
    _url = url;
    _isShow = isShow;
    _createdAt = createdAt;
  }

  NoticeViewData.fromJson(dynamic json) {
    _timestamp = json['timestamp'];
    _title = json['title'];
    _content = json['content'];
    _url = json['url'];
    _isShow = json['isShow'];
    _createdAt = json['createdAt'];
  }
  String? _timestamp;
  String? _title;
  String? _content;
  String? _url;
  int? _isShow;
  String? _createdAt;

  String? get timestamp => _timestamp;
  String? get title => _title;
  String? get content => _content;
  String? get url => _url;
  int? get isShow => _isShow;
  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['timestamp'] = _timestamp;
    map['title'] = _title;
    map['content'] = _content;
    map['url'] = _url;
    map['isShow'] = _isShow;
    map['createdAt'] = _createdAt;
    return map;
  }

}