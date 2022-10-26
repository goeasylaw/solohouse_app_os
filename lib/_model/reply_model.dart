import '../_common/user_model.dart';

class ReplyListModel {
  String timestamp = '';
  int page = 0;
  int pageSize = 20;
  bool nextPage = false;

  List<ReplyItemModel> replyList = [];

  ReplyListModel(this.timestamp, this.replyList);

  ReplyListModel.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'];
    page = json['page'];
    pageSize = json['pageSize'];
    nextPage = json['nextPage'];
    if (json['replyList'] != null) {
      if(json['replyList'] != '') {
        replyList = [];
        json['replyList'].forEach((v) {
          replyList.add(ReplyItemModel.fromJson(v));
        });
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['timestamp'] = timestamp;
    data['page'] = page;
    data['pageSize'] = pageSize;
    data['nextPage'] = nextPage;
    data['replyList'] = replyList.map((v) => v.toJson()).toList();
    return data;
  }
}

class ReplyItemModel {
  int? replyNo;
  String? message;
  int? myReply;
  UserInfo? userInfo;
  String? createdAt;
  String? commentList;
  bool isShow = true;

  ReplyItemModel(
      this.replyNo,
      this.message,
      this.myReply,
      this.userInfo,
      this.createdAt,
      this.commentList);

  ReplyItemModel.fromJson(Map<String, dynamic> json) {
    replyNo = json['replyNo'];
    message = json['message'];
    myReply = json['myReply'];
    userInfo = json['userInfo'] != null
        ? UserInfo.fromJson(json['userInfo'])
        : null;
    createdAt = json['createdAt'];
    commentList = json['commentList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['replyNo'] = replyNo;
    data['message'] = message;
    data['myReply'] = myReply;
    if (userInfo != null) {
      data['userInfo'] = userInfo!.toJson();
    }
    data['createdAt'] = createdAt;
    data['commentList'] = commentList;
    return data;
  }
}
