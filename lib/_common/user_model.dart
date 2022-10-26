import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

import '../app_config.dart';
import 'api.dart';

AndroidOptions _getAndroidOptions() => const AndroidOptions(
  encryptedSharedPreferences: true,
);



class UserData {
  int? userNo;
  String? userId;
  String? userName;
  String? sub;
  String? iss;
  int? exp;
  List<String>? scope;

  UserData(
      {this.userNo,
        this.userName,
        this.sub,
        this.iss,
        this.exp,
        this.scope});

  UserData.fromJson(Map<String, dynamic> json) {
    userNo = json['user_no'];
    userId = json['user_id'];
    userName = json['user_name'];
    sub = json['sub'];
    iss = json['iss'];
    exp = json['exp'];
    scope = json['scope'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['user_no'] = userNo;
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['sub'] = sub;
    data['iss'] = iss;
    data['exp'] = exp;
    data['scope'] = scope;
    return data;
  }
}

class MyInformation {
  String? timestamp;
  int? replaceCount;
  int? scrapCount;
  int? likeCount;
  int? replyCount;
  UserInfo? userInfo;

  MyInformation(
      {this.timestamp,
        this.replaceCount,
        this.scrapCount,
        this.likeCount,
        this.replyCount,
        this.userInfo});

  MyInformation.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'];
    replaceCount = json['replaceCount'];
    scrapCount = json['scrapCount'];
    likeCount = json['likeCount'];
    replyCount = json['replyCount'];
    userInfo = json['userInfo'] != null
        ? UserInfo.fromJson(json['userInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['timestamp'] = timestamp;
    data['replaceCount'] = replaceCount;
    data['scrapCount'] = scrapCount;
    data['likeCount'] = likeCount;
    data['replyCount'] = replyCount;
    if (userInfo != null) {
      data['userInfo'] = userInfo!.toJson();
    }
    return data;
  }
}

class UserInfo {
  int? userNo;
  String? userName;
  String? email;
  String? mobile;
  String? photoUrl;
  String? backgroundUrl;
  String? comment;
  String? middlePhotoUrl;
  String? smallPhotoUrl;
  int? pushConfig;
  UserInfo(
      {this.userNo,
        this.userName,
        this.email,
        this.mobile,
        this.photoUrl,
        this.backgroundUrl,
        this.comment,
        this.middlePhotoUrl,
        this.smallPhotoUrl,
        this.pushConfig});

  UserInfo.fromJson(Map<String, dynamic> json) {
    userNo = json['userNo'];
    userName = json['userName'];
    email = json['email'];
    mobile = json['mobile'];
    photoUrl = json['photoUrl'];
    backgroundUrl = json['backgroundUrl'];
    comment = json['comment'];
    middlePhotoUrl = json['middlePhotoUrl'];
    smallPhotoUrl = json['smallPhotoUrl'];
    pushConfig = json['pushConfig'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['userNo'] = userNo;
    data['userName'] = userName;
    data['email'] = email;
    data['mobile'] = mobile;
    data['photoUrl'] = photoUrl;
    data['backgroundUrl'] = backgroundUrl;
    data['comment'] = comment;
    data['middlePhotoUrl'] = middlePhotoUrl;
    data['smallPhotoUrl'] = smallPhotoUrl;
    data['pushConfig'] = pushConfig;
    return data;
  }
}

class UserModel with ChangeNotifier {
  static final UserModel _instance = UserModel._internal();
  factory UserModel() {
    return _instance;
  }
  //클래스가 최초 생성될때 1회 발생
  UserModel._internal() {
    //초기화 코드
  }

  bool isLogin = false;
  UserData? user;
  MyInformation? myInformation;
  late String? deviceId;
  late String os;
  late String osVersion;
  late String deviceName;
  late String appVersion;
  late String userToken;

  String appUpdateVersion = '';
  bool forceUpdate = false;
  String storeUrl = '';

  String? pushToken;

  List<int> blockUsers = [];
  List<int> blockReply = [];
  List<int> blockContent = [];


  Future<void> getDeviceInfo() async {
    await initDeviceId();
    await initAppState();
    await initPlatformState();
    await sendDeviceInfo();
  }

  static final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  // DeviceID를 가져오고 없으면 생성한다.
  Future<void> initDeviceId() async {

    final storage = FlutterSecureStorage();

    deviceId = await storage.read(key: 'deviceId', aOptions: _getAndroidOptions());

    if(deviceId == null) {
      var uuid = Uuid().v4();
      deviceId = uuid;
      storage.write(key: 'deviceId', value: uuid, aOptions: _getAndroidOptions());
    }
  }

  //앱 버전을 가져온다.
  Future<void> initAppState() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
  }

  //디바이스 정보를 가져온다.
  Future<void> initPlatformState() async {
    try {
      if (Platform.isAndroid) {
        os = 'aos';
        _readAndroidBuildData(await deviceInfo.androidInfo);
      } else if (Platform.isIOS) {
        os = 'ios';
        _readIosDeviceInfo(await deviceInfo.iosInfo);
      }
    } on PlatformException{
      if (kDebugMode) {
        print('error');
      }
    }
  }

  bool isMy(int userNo) {
    if(isLogin) {
      if(userNo == myInformation!.userInfo!.userNo!) {
        return true;
      }
    }
    return false;
  }

  void _readAndroidBuildData(AndroidDeviceInfo build) {
    osVersion = build.version.sdkInt.toString();
    deviceName = build.model!;
  }

  void _readIosDeviceInfo(IosDeviceInfo data) {
    osVersion = data.systemVersion!;
    deviceName = data.utsname.machine!;
  }

  String getUserToken() => userToken;

  // 기본 디바이스 정보를 보낸다.
  Future<void> sendDeviceInfo() async {
    var url = '${AppConfig().baseUrl()}/guest/device';
    var body = {
      'deviceId': deviceId,
      'appVersion': appVersion,
      'deviceName': deviceName,
      'osVersion': osVersion,
      'osType': os,
    };

    var response = await Api().post(Uri.parse(url), body: body);
  }

  //푸시 토큰 정보를 보낸다.
  void sendPushToken(String token) async {
    pushToken = token;
    var url = '${AppConfig().baseUrl()}/guest/device';
    var body = {
    'deviceId': deviceId,
    'pushToken': token,
    };

    await Api().post(Uri.parse(url), body: body);
  }

  //푸시 가능 여부값을 보낸다.
  void sendPushSetting(String setting) async {
    var url = '${AppConfig().baseUrl()}/guest/device';
    var body = {
      'deviceId': deviceId,
      'pushSetting': setting,
    };
    await Api().post(Uri.parse(url), body: body);
  }

  void sendIDFA(String idfa) async {
    var url = '${AppConfig().baseUrl()}/guest/device';
    var body = {
      'deviceId': deviceId,
      'idfa': idfa,
    };

    await Api().post(Uri.parse(url), body: body);
  }

  //재로그인을 한다.
  Future<bool> refreshLogin() async {
    final storage = FlutterSecureStorage();
    var refreshToken = await storage.read(key: 'refresh_token', aOptions: _getAndroidOptions());
    if(refreshToken != null) {
      var url = '${AppConfig().baseUrl()}/auth';
      var body = {
        'refreshToken': refreshToken,
        'deviceId': deviceId,
      };

      var response = await Api().post(Uri.parse(url), body: body);

      if (response.statusCode == 201) {
        await saveUserInfo(response.body);

        return true;
      }
      else {
        return false;
      }
    } else {
      return false;
    }
  }

  //로그인을 한다.
  Future<Map<String, String>> login(String uid) async {
    var url = '${AppConfig().baseUrl()}/auth/login';
    var body = {
      'uid': uid,
      'deviceId': deviceId,
    };

    var response = await Api().post(Uri.parse(url), body: body);

    Map<String, dynamic> json = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode <= 201) {
      final storage = FlutterSecureStorage();
      storage.write(key: 'refresh_token', value: json['refresh_token'], aOptions: _getAndroidOptions());

      await saveUserInfo(json['token']);

      for(var blockUser in json['block_user']) {
        blockUsers.add(blockUser);
      }

      return {'result': 'success'};
    }
    else {
      return {'result': 'fail', 'error': json['error']};
    }
  }

  Future<void> saveUserInfo(String token) async {
    print(token);
    final String payload = token.split('.')[1];
    Map<String, dynamic> payloadJson = jsonDecode(B64urlEncRfc7515.decodeUtf8(payload));

    user = UserData.fromJson(payloadJson);
    userToken = token;
    isLogin = true;
    await getMyInformation();
    // PushUnreadModel().load();
    notifyListeners();
  }

  Future<void> getMyInformation() async {
    if(!isLogin) {
      return;
    }

    var url = '${AppConfig().baseUrl()}/user/myInformation';

    var response = await Api().get(Uri.parse(url), headers: {HttpHeaders.authorizationHeader:'Bearer ${UserModel().getUserToken()}'});

    myInformation = MyInformation.fromJson(jsonDecode(response.body));

    notifyListeners();
  }


  void notify() {
    notifyListeners();
  }

  Future<bool> logout() async {
    // var url = AppConfig().baseUrl() + '/auth/logout';
    // var body = {
    //   'deviceId': this.deviceId
    // };
    //
    // var response = await Api().post(Uri.parse(url), body: body);
    //
    // PushUnreadModel().clear();

    isLogin = false;
    userToken = '';
    user = null;
    myInformation = null;

    await FlutterSecureStorage().delete(key: 'refresh_token', aOptions: _getAndroidOptions());

    await FirebaseAuth.instance.signOut();

    notifyListeners();

    return true;
  }
}