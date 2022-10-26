import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:solohouse/_common/c_style.dart';
import 'package:solohouse/_common/util.dart';
import 'package:solohouse/pages/root_page.dart';
import 'package:notification_permissions/notification_permissions.dart' as PushPermission;

import '_common/user_model.dart';
import 'app_config.dart';

enum TabItem { magazine, soloHouse, home, soloStay, my }

Map<TabItem, String> tabName = {
  TabItem.magazine: '매거진',
  TabItem.soloHouse: '솔로하우스',
  TabItem.home: '홈',
  TabItem.soloStay: '솔로스테이',
  TabItem.my: '마이',
};

FirebaseMessaging messaging = FirebaseMessaging.instance;

var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with TickerProviderStateMixin {

  var userModel = UserModel();
  bool loaded = false;

  late  TabController _tabController;
  int tabIndex = 2;



  @override
  void initState() {

    _tabController = TabController(
      length: 5,
      initialIndex: tabIndex,
      vsync: this,
    );

    _tabController.addListener(() {
      setState((){
        tabIndex = _tabController.index;
      });
    });

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await userModel.getDeviceInfo();

      //안드로이드 사용자는 4등급 푸시 채널 만든다.
      if (Theme.of(context).platform == TargetPlatform.android) {
        _initializeLocalNotifications().then((value) {
          _createNotificationChannel().then((value) {
            firebaseCloudMessagingListeners();
          });
        });
      } else {
        firebaseCloudMessagingListeners();
      }

      Permission.notification.status.then((value) {
        if(!value.isGranted) {
          Permission.notification.request();
        }
      });


      if(FirebaseAuth.instance.currentUser != null) {
        UserModel().login(FirebaseAuth.instance.currentUser!.uid).then((value) {
          setState(() {
            loaded = true;
          });
        });
      } else {
        setState(() {
          loaded = true;
        });
      }

      Timer(Duration(seconds: 3), () {
        setState(() {
          loaded = true;
        });
      });
    });
  }

  Future<void> _initializeLocalNotifications() async {
    var initializationSettingsAndroid = AndroidInitializationSettings('drawable/ic_launcher');
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel androidNotificationChannel =
    AndroidNotificationChannel(
        'SoloHouse',
        'SoloHouse',
        importance: Importance.max
    );
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(androidNotificationChannel);
  }

  Future<void> firebaseCloudMessagingListeners() async {
    //알림내역의 모든 알림을 지운다.
    flutterLocalNotificationsPlugin.cancelAll();

    //알림 퍼미션을 확인하고 저장한다.
    PushPermission.NotificationPermissions.getNotificationPermissionStatus().then((value) {
      PushPermission.PermissionStatus res = value;
      if(res == PushPermission.PermissionStatus.granted || res == PushPermission.PermissionStatus.provisional) {
        // FlutterSecureStorage().write(key: 'push_setting', value: '1');
        // UserModel().sendPushSetting('1');
      } else if(res == PushPermission.PermissionStatus.denied) {
        // FlutterSecureStorage().write(key: 'push_setting', value: '0');
        // UserModel().sendPushSetting('0');
      } else if(res == PushPermission.PermissionStatus.unknown) {
        //설정된 권한이 없으면 권한을 요청한다.
        PushPermission.NotificationPermissions.requestNotificationPermissions(
            iosSettings:PushPermission.NotificationSettingsIos(
                sound: true,
                badge: true,
                alert: true
            )
        ).then((_) {
          PushPermission.NotificationPermissions.getNotificationPermissionStatus().then((value) {
            if(value == PushPermission.PermissionStatus.granted || value == PushPermission.PermissionStatus.provisional) {
              // FlutterSecureStorage().write(key: 'push_setting', value: '1');
              // UserModel().sendPushSetting('1');
            } else {
              // FlutterSecureStorage().write(key: 'push_setting', value: '0');
              // UserModel().sendPushSetting('0');
            }
          });
        });
      }
    });

    messaging.getToken().then((token) {
      userModel.pushToken = token;
      userModel.sendPushToken(token!);
      print("Push Toekn : $token");
      //FlutterSecureStorage().write(key: 'push_token', value: token);
    });

    //앱에 처음 시작할때
    messaging.getInitialMessage().then((message) {
      if(message != null) {
        if(message.data != null) {
        }
      }
    });

    //앱이 리줌 되었을때
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // pushProcessor(parsingPushMessage(message), true);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // pushProcessor(parsingPushMessage(message), false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '솔로하우스',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ko', 'KR'),
      ],
      theme: ThemeData(
        backgroundColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: CStyle.colorPri,
        secondaryHeaderColor: CStyle.colorSec,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        tabBarTheme: TabBarTheme(
        ),
        buttonTheme: ButtonThemeData(
          padding: EdgeInsets.all(4)
        ),
        appBarTheme: AppBarTheme(
          centerTitle: false,
          color: Colors.white,
          titleSpacing: 16,
          iconTheme: IconThemeData(
            size: 18,
            color: Colors.black
          ),
          elevation: 0,
          shadowColor: Colors.black26,
          titleTextStyle: CStyle.appbarTitle
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: hexColor('F3F3F3')),
              borderRadius: BorderRadius.circular(8)
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: CStyle.colorPri),
              borderRadius: BorderRadius.circular(8)
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: hexColor('F3F3F3')),
              borderRadius: BorderRadius.circular(8)
          ),
        ),

        popupMenuTheme: PopupMenuThemeData(
          elevation: 2,
          shape:  RoundedRectangleBorder(
              side: BorderSide(color: Colors.white), //the outline color
              borderRadius: BorderRadius.all(Radius.circular(10))
          ),
        ),
      ),
      builder: FlutterSmartDialog.init(),
      home: !loaded?Center(child: CircularProgressIndicator()):Scaffold(
        backgroundColor: Colors.black,
        body: RootPage(),
        // body: SafeArea(
        //   child: DefaultTabController(
        //     length: 5,
        //     child: TabBarView(
        //       physics: NeverScrollableScrollPhysics(),
        //       controller: _tabController,
        //       children: [
        //         MagazinePage(),
        //         SolohousePage(),
        //         HomePage(),
        //         SolostayPage(),
        //         MyPage(),
        //       ],
        //     ),
        //   ),
        // ),
        // bottomNavigationBar: SafeArea(
        //   child: ColoredBox(
        //     color: hexColor('F6F6F6'),
        //     child: TabBar(
        //       controller: _tabController,
        //       indicatorColor: Colors.transparent,
        //       labelStyle: TextStyle(fontSize: 12.0),
        //       labelPadding: EdgeInsets.zero,
        //       unselectedLabelStyle: TextStyle(fontSize: 12.0,fontFamily: 'Family Name'),
        //       tabs: [
        //         Tab(
        //           icon: tabIndex==0?Image.asset('assets/images/tab_icon_magazine_on.png', width: 24, height: 24):Image.asset('assets/images/tab_icon_magazine_off.png', width: 24, height: 24),
        //           text: tabName[TabItem.magazine]!,
        //         ),
        //         Tab(
        //           icon: tabIndex==1?Image.asset('assets/images/tab_icon_solohouse_on.png', width: 24, height: 24):Image.asset('assets/images/tab_icon_solohouse_off.png', width: 24, height: 24),
        //           text: tabName[TabItem.soloHouse]!,
        //         ),
        //         Tab(
        //           icon: tabIndex==2?Image.asset('assets/images/tab_icon_home_on.png', width: 24, height: 24):Image.asset('assets/images/tab_icon_home_off.png', width: 24, height: 24),
        //           text: tabName[TabItem.home]!,
        //         ),
        //         Tab(
        //           icon: tabIndex==3?Image.asset('assets/images/tab_icon_solostay_on.png', width: 24, height: 24):Image.asset('assets/images/tab_icon_solostay_off.png', width: 24, height: 24),
        //           text: tabName[TabItem.soloStay]!,
        //         ),
        //         Tab(
        //           icon: tabIndex==4?Image.asset('assets/images/tab_icon_my_on.png', width: 24, height: 24):Image.asset('assets/images/tab_icon_my_off.png', width: 24, height: 24),
        //           text: tabName[TabItem.my]!,
        //         )
        //       ]
        //     ),
        //   ),
        // ),
      ),
    );
  }
}