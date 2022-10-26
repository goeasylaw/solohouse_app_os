import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:solohouse/_common/c_style.dart';
import 'package:solohouse/_common/util.dart';

import '../../_common/api.dart';
import '../../_common/user_model.dart';
import '../../app_config.dart';


class PushSettingPage extends StatefulWidget {
  const PushSettingPage({Key? key}) : super(key: key);

  @override
  State<PushSettingPage> createState() => _PushSettingPageState();
}

class _PushSettingPageState extends State<PushSettingPage> with WidgetsBindingObserver{
  bool isLoad = false;
  bool pushSetting = true;
  bool pushConfig = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      pushConfig = UserModel().myInformation!.userInfo!.pushConfig==0?false:true;
      Permission.notification.status.then((value) {
        if(!value.isGranted) {
          pushSetting = false;
        }

        setState(() {
          isLoad = true;
        });
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed) {
      Permission.notification.status.then((value) {
        if(value.isGranted) {
          FlutterSecureStorage().write(key: 'push_setting', value: '1');
          UserModel().sendPushSetting('1');
          setState(() {
            pushSetting = true;
          });
        } else {
          FlutterSecureStorage().write(key: 'push_setting', value: '0');
          UserModel().sendPushSetting('0');
          setState(() {
            pushSetting = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('알림 설정')
        ),
        body: isLoad?_buildBody(context):Center(child: CircularProgressIndicator())
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Visibility(
                visible: !pushSetting,
                child: ColoredBox(
                  color: hexColor('F3F3F3'),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: Row(
                          children: [
                            Icon(Icons.error, size: 22, color: CStyle.colorPri),
                            SizedBox(width: 10),
                            Text('알림이 오지 않으세요?', style: CStyle.p14_7_4),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(48, 6, 16, 0),
                        child: Text('회원님의 휴대전화 시스템 설정에서 솔로하우스 알림이 꺼져 있습니다.', style: CStyle.p12_5_3),
                      ),
                      InkWell(
                        onTap: () {
                          AppSettings.openNotificationSettings().then((value) {
                            Permission.notification.status.then((value) {
                              if(value.isGranted) {
                                FlutterSecureStorage().write(key: 'push_setting', value: '1');
                                UserModel().sendPushSetting('1');
                                setState(() {
                                  pushSetting = true;
                                });
                              } else {
                                FlutterSecureStorage().write(key: 'push_setting', value: '0');
                                UserModel().sendPushSetting('0');
                                setState(() {
                                  pushSetting = false;
                                });
                              }
                            });
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 20),
                          height: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: CStyle.colorPri,
                          ),
                          child: Text('시스템 알림 설정 바로가기', style: CStyle.p14_7_white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: !pushSetting,
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: hexColor('F5F5F5'),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.notifications_none, size: 24, color: Colors.black),
                        SizedBox(width: 10),
                        Text('푸시 알림', style: CStyle.p14_5_4),
                        Expanded(child: Container()),
                        Switch(
                          value: UserModel().myInformation!.userInfo!.pushConfig==1?true:false,
                          onChanged: (value) {
                            if(value) {
                              savePushSetting(1);
                            } else {
                              savePushSetting(0);
                            }
                          },
                          activeColor: CStyle.colorPri,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: hexColor('F5F5F5'),
              ),
            ],
          ),
        )
    );
  }

  void savePushSetting(int push) async {
    if(UserModel().isLogin) {
      String url = '${AppConfig().baseUrl()}/user/information';

      SmartDialog.showLoading();
      var response = await Api().put(Uri.parse(url), body: {'pushConfig': push.toString()});
      SmartDialog.dismiss();

      if(checkApiError(response)) {
        return;
      }

      if(response.statusCode == 200) {
        await UserModel().getMyInformation();
        setState(() {
        });
      }
    }
  }
}
