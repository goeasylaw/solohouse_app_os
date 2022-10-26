import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:app_settings/app_settings.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../app_config.dart';

bool checkApiError(Response response) {
  if(response.statusCode > 299) {
    if(AppConfig.env!='LIVE') {
      // print(response.request.toString());
      // print(response.body);
    }
    try {
      Map<String, dynamic> errorJson = jsonDecode(response.body);
      print(errorJson.toString());
      if(errorJson.containsKey('error')) {
        SmartDialog.showToast(errorJson['error']);
      } else {
        SmartDialog.showToast('Server Error');
      }
    } catch(e) {
      SmartDialog.showToast('Server Error');
    }
    return true;
  }
  return false;
}

Color hexColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll('#', '');

  if (hexColor.length == 6) {
    hexColor = 'FF$hexColor';
  }

  return Color(int.parse(hexColor, radix: 16));
}


String createdAtDate(String createdAt) {
  DateTime writeDate = DateTime.parse(createdAt);
  DateFormat dateFormat = DateFormat.yMd();
  return dateFormat.format(writeDate);
}

bool createdAtIsToday(String createdAt) {
  DateTime writeDate = DateTime.parse(createdAt);
  DateTime currDate = DateTime.now();

  DateFormat todayFormat = DateFormat.jm();
  DateFormat dateFormat = DateFormat.yMd();

  if(currDate.year==writeDate.year && currDate.month==writeDate.month && currDate.day==writeDate.day) {
    return true;
  } else {
    return false;
  }
}

String createdAtDateOrTimeChat(String createdAt) {
  DateTime writeDate = DateTime.parse(createdAt);
  DateTime currDate = DateTime.now();

  DateFormat todayFormat = DateFormat.jm();
  DateFormat dateFormat = DateFormat.yMd();

  if(currDate.year==writeDate.year && currDate.month==writeDate.month && currDate.day==writeDate.day) {
    return todayFormat.format(writeDate);
  } else {
    return dateFormat.format(writeDate);
  }
}

double getWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;

}

Future<bool> checkGrantPhoto(BuildContext context) async {
  var res = false;
  if (Platform.isAndroid) {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      //파일 접근 권한을 요청한다.
      status = await Permission.storage.request();
    }

    if(status == PermissionStatus.denied) {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.confirm,
        title: '권한 요청',
        text: '저장소에 접근할 수 없습니다. 권한을 수정하시겠습니까?\n[ 권한 ]에서 [ 저장공간 ]를 허용해 주세요.',
        confirmBtnText: '확인',
        cancelBtnText: '닫기',
        onConfirmBtnTap: () {
          AppSettings.openAppSettings().then((_) {
            return null;
          });
        }
      );
    } else {
      res = true;
    }
  } else if (Platform.isIOS) {
    var status = await Permission.photos.status;
    if (status.isDenied) {
      //파일 접근 권한을 요청한다.
      status = await Permission.photos.request();
    }
    if(status == PermissionStatus.denied) {
      CoolAlert.show(
          context: context,
          type: CoolAlertType.confirm,
          title: '권한 요청',
          text: '사진에 접근할 수 없습니다. 권한을 수정하시겠습니까?\n[ 사진 ]에서 [ 모든 사진 ] 체크해 주세요.',
          confirmBtnText: '확인',
          cancelBtnText: '닫기',
          onConfirmBtnTap: () {
            AppSettings.openAppSettings().then((_) {
              return null;
            });
          }
      );
    } else {
      res = true;
    }
  }

  return res;
}