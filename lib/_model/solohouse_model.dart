import 'package:flutter/material.dart';

import '../_common/user_model.dart';

class SolohouseListModel {
  SolohouseListModel({
    this.timestamp,
    this.nextPage,
    this.contentList,});

  SolohouseListModel.fromJson(dynamic json) {
    timestamp = json['timestamp'];
    nextPage = json['nextPage'];
    if (json['contentList'] != null) {
      contentList = [];
      json['contentList'].forEach((v) {
        contentList?.add(SolohouseModel.fromJson(v));
      });
    }
  }
  String? timestamp;
  bool? nextPage;
  List<SolohouseModel>? contentList;
  SolohouseListModel copyWith({
    String? timestamp,
    bool? nextPage,
    List<SolohouseModel>? contentList,}) => SolohouseListModel(
    timestamp: timestamp ?? this.timestamp,
    nextPage: nextPage ?? this.nextPage,
    contentList: contentList ?? this.contentList,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['timestamp'] = timestamp;
    map['nextPage'] = nextPage;
    if (contentList != null) {
      map['contentList'] = contentList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class SolohouseModel {
  SolohouseModel({
    this.contentNo,
    this.category,
    this.images,
    this.title,
    this.cover,
    this.message,
    this.magazine,
    this.scrapCount,
    this.likeCount,
    this.replyCount,
    this.myLike,
    this.myScrap,
    this.keyword,
    this.userInfo,
    this.createdAt,});

  SolohouseModel.fromJson(dynamic json) {
    contentNo = json['contentNo'];
    category = json['category'];
    images = json['images'];
    title = json['title'];
    cover = json['cover'];
    if(cover!.isNotEmpty) {
      if(!cover!.toLowerCase().startsWith('http')) {
        cover = 'https://server/$cover';
      }
    }

    message = json['message'];
    magazine = json['magazine'];
    scrapCount = json['scrapCount'];
    likeCount = json['likeCount'];
    replyCount = json['replyCount'];
    myLike = json['myLike'];
    myScrap = json['myScrap'];
    keyword = json['keyword'];
    userInfo = json['userInfo'] != null ? UserInfo.fromJson(json['userInfo']) : null;
    createdAt = json['createdAt'];
  }
  int? contentNo;
  String? category;
  String? images;
  int imageIndex = 0;
  Key key = GlobalKey();
  String? title;
  String? cover;
  String? message;
  String? magazine;
  int? scrapCount;
  int? likeCount;
  int? replyCount;
  int? myLike;
  int? myScrap;
  String? keyword;
  UserInfo? userInfo;
  String? createdAt;
  SolohouseModel copyWith({  int? contentNo,
    String? category,
    String? images,
    String? title,
    String? cover,
    String? message,
    String? magazine,
    int? scrapCount,
    int? likeCount,
    int? replyCount,
    int? myLike,
    int? myScrap,
    String? keyword,
    UserInfo? userInfo,
    String? createdAt,
  }) => SolohouseModel(  contentNo: contentNo ?? this.contentNo,
    category: category ?? this.category,
    images: images ?? this.images,
    title: title ?? this.title,
    cover: cover ?? this.cover,
    message: message ?? this.message,
    magazine: magazine ?? this.magazine,
    scrapCount: scrapCount ?? this.scrapCount,
    likeCount: likeCount ?? this.likeCount,
    replyCount: replyCount ?? this.replyCount,
    myLike: myLike ?? this.myLike,
    myScrap: myScrap ?? this.myScrap,
    keyword: keyword ?? this.keyword,
    userInfo: userInfo ?? this.userInfo,
    createdAt: createdAt ?? this.createdAt,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['contentNo'] = contentNo;
    map['category'] = category;
    map['images'] = images;
    map['title'] = title;
    map['cover'] = cover;
    map['message'] = message;
    map['magazine'] = magazine;
    map['scrapCount'] = scrapCount;
    map['likeCount'] = likeCount;
    map['replyCount'] = replyCount;
    map['myLike'] = myLike;
    map['myScrap'] = myScrap;
    map['keyword'] = keyword;
    if (userInfo != null) {
      map['userInfo'] = userInfo?.toJson();
    }
    map['createdAt'] = createdAt;
    return map;
  }

}