import 'package:auth_buttons/auth_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_oauth/firebase_auth_oauth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:share_plus/share_plus.dart';
import 'package:solohouse/_common/user_model.dart';
import 'package:solohouse/_common/util.dart';
import 'package:solohouse/pages/my/policy_confirm.dart';
import 'package:solohouse/pages/my/policy_page.dart';

import '../../_common/c_style.dart';
import 'demand_write_page.dart';
import 'my_edit_page.dart';
import 'my_save_page.dart';
import 'notice_list_page.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {


  @override
  void initState() {
    super.initState();
    UserModel().addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/tab_icon_my_off.png', width: 24, height: 24),
            SizedBox(width: 8),
            Text('마이', style: CStyle.appbarTitle),
          ],
        ),
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //       },
        //       icon: Image.asset('assets/images/icon_notification_off.png', width: 24, height: 24)
        //   ),
        // ],
      ),
      body: _buildBody()
    );
  }

  Widget _buildBody() {
    double backgroundHeight = MediaQuery.of(context).size.width * 0.5625;
    return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 124 + backgroundHeight,
                alignment: Alignment.center,
                child: UserModel().isLogin?_buildUserBody():_buildGuestBody()
              ),
              Divider(height: 8, thickness: 8, color: hexColor('F9F9F9')),
              InkWell(
                onTap: () {
                  Share.share('https://server/app.html', subject: '솔로하우스');
                },
                child: ListTile(
                    title: Text('솔로하우스 공유하기', style: CStyle.p15_4_7),
                    trailing: Icon(Icons.keyboard_arrow_right)
                ),
              ),
              Divider(height: 1, thickness: 1, color: hexColor('F3F3F3')),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NoticeListPage()),
                  );
                },
                child: ListTile(
                    title: Text('공지사항', style: CStyle.p15_4_7),
                    trailing: Icon(Icons.keyboard_arrow_right)
                ),
              ),
              Divider(height: 1, thickness: 1, color: hexColor('F3F3F3')),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PolicyPage()),
                  );
                },
                child: ListTile(
                    title: Text('약관 및 정책', style: CStyle.p15_4_7),
                    trailing: Icon(Icons.keyboard_arrow_right)
                ),
              ),
              Divider(height: 1, thickness: 1, color: hexColor('F3F3F3')),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DemandWritePage()),
                  );
                },
                child: ListTile(
                    title: Text('문의하기', style: CStyle.p15_4_7),
                    trailing: Icon(Icons.keyboard_arrow_right)
                ),
              ),
              Divider(height: 1, thickness: 1, color: hexColor('F3F3F3')),
              Container(
                  height: 60,
                  padding: EdgeInsets.only(left: 16, right: 16),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text('APP 버전 정보', style: CStyle.p15_4_7),
                      Expanded(child: SizedBox()),
                      Text('현재버전 1.0.0', style: CStyle.p15_4_7),
                    ],
                  )
              ),
              Divider(height: 1, thickness: 1, color: hexColor('F3F3F3')),
              Container(
                height: 60,
                alignment: Alignment.center,
                child: Text('본 서비스는 한국언론진흥재단의 지원을 받아 개발되었습니다.', style: CStyle.p12_5_3),
              ),
            ],
          ),
        )
    );
  }

  Widget _buildGuestBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width-120,
          child: GoogleAuthButton(
            style: AuthButtonStyle(
              textStyle: CStyle.p14_5_4
            ),
            onPressed: () async {
              _showPolicyConfirm(context).then((value) async {
                if(value == 'YES') {
                  await performLogin("google.com", ["email"], {"locale": "ko"}, 'g');
                }
              });

              // UserCredential user = await signInWithGoogle();
              // if(user != null) {
              //   print(user.user!.uid);
              // }
            },
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          width: MediaQuery.of(context).size.width-120,
          child: AppleAuthButton(
            style: AuthButtonStyle(
                textStyle: CStyle.p14_5_4
            ),
            onPressed: () async {
              _showPolicyConfirm(context).then((value) async {
                if(value == 'YES') {
                  await performLogin("apple.com", ["email"], {"locale": "ko"}, 'a');
                }
              });

            },
          ),
        )

      ],
    );
  }

  Future<String> _showPolicyConfirm(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return PolicyConfirm();
      }
    );
  }



  Widget _buildUserBody() {
    double backgroundHeight = MediaQuery.of(context).size.width * 0.5625;
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(bottom: 50),
              height: backgroundHeight,
              color: Colors.green,
              alignment: Alignment.topCenter,
              child: UserModel().myInformation!.userInfo!.backgroundUrl==''?
                Image.asset('assets/images/my_default.png', width: MediaQuery.of(context).size.width, height: backgroundHeight, fit: BoxFit.fitWidth)
                :Image.network(UserModel().myInformation!.userInfo!.backgroundUrl!, width: MediaQuery.of(context).size.width, height: backgroundHeight, fit: BoxFit.fitWidth),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: backgroundHeight,
              margin: EdgeInsets.only(bottom: 50),
              color: Colors.black26,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(bottom: 50),
              height: backgroundHeight,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MySavePage(index: 0)),
                      ).then((value) {
                        if(value == "REFRESH") {

                        }
                      });
                    },
                    child: SizedBox(
                      width: 66,
                      height: 66,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(UserModel().myInformation!.replaceCount.toString(), style: CStyle.p36_9_white,),
                          Text('내가쓴글', style: CStyle.p10_5_white,)
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MySavePage(index: 1)),
                      );
                    },
                    child: SizedBox(
                      width: 66,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(UserModel().myInformation!.scrapCount.toString(), style: CStyle.p36_9_white,),
                          Text('스크랩', style: CStyle.p10_5_white,)
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MySavePage(index: 2)),
                      );
                    },
                    child: SizedBox(
                      width: 66,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(UserModel().myInformation!.likeCount.toString(), style: CStyle.p36_9_white,),
                          Text('좋아요', style: CStyle.p10_5_white,)
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MySavePage(index: 3)),
                      );
                    },
                    child: SizedBox(
                      width: 66,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(UserModel().myInformation!.replyCount.toString(), style: CStyle.p36_9_white,),
                          Text('댓글단 글', style: CStyle.p10_5_white,)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            _userPicture()
          ],
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 12),
            Text(UserModel().myInformation!.userInfo!.userName!, style: CStyle.p18_7_3),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyEditPage()),
                );

              },
              child: Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                child: Icon(Icons.settings, color: hexColor('CCCCCC'), size: 24,)
              ),
            )
          ],
        ),
        // SizedBox(height: 28),
        // Container(
        //   margin: EdgeInsets.only(left: 16, right: 16),
        //   padding: EdgeInsets.only(left: 20, right: 2),
        //   height: 56,
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(6),
        //     border: Border.all(
        //       width: 3,
        //       color: hexColor('F9F9F9')
        //     )
        //   ),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [
        //       Image.asset('assets/images/icon_stay_manager.png', width: 24, height: 24),
        //       SizedBox(width: 8),
        //       Text('솔로스테이 호스트 등록하기', style: CStyle.p14_7_8),
        //       Expanded(child: SizedBox()),
        //       Container(
        //         alignment: Alignment.center,
        //         padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
        //         child: Image.asset('assets/images/icon_help.png', width: 20, height: 20),
        //       )
        //
        //
        //     ],
        //   ),
        // ),
        //SizedBox(height: 40),
      ],
    );
  }

  Future<void> performLogin(String provider, List<String> scopes, Map<String, String> parameters, String loginType) async {
    try {
      await FirebaseAuthOAuth().openSignInFlow(provider, scopes, parameters);
      User? user = FirebaseAuth.instance.currentUser;
      if(user == null) {
        SmartDialog.showToast('로그인에 실패했습니다.');
      } else {
        _login(user.uid);
      }

    } on PlatformException catch (error) {
      SmartDialog.showToast("${error.code}: ${error.message}", alignment: Alignment.center);
      debugPrint("${error.code}: ${error.message}");
    }
  }

  Future<void> _login(String uid) async {

    SmartDialog.showLoading();
    try {
      var response = await UserModel().login(uid);
      if (response['result'] == 'success') {
        setState((){});
      } else {
        SmartDialog.showToast(response['error']!);
      }
    } on Exception catch (_, e) {
      SmartDialog.showToast(e.toString());
    } finally {
      SmartDialog.dismiss();
    }
  }

  Widget _userPicture() {
    return Container(
      width: 100,
      height: 100,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: hexColor('D8D8D8'),
          borderRadius: BorderRadius.circular(50)
      ),
      child: UserModel().myInformation!.userInfo!.middlePhotoUrl==''?
          Icon(Icons.person, size: 86, color: Colors.white)
          :ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.network(UserModel().myInformation!.userInfo!.middlePhotoUrl!, width: 100, height: 100, fit: BoxFit.fill)
      ),
    );
  }


  // Future<UserCredential> signInWithGoogle() async {
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //
  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  //
  //   // Create a new credential
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );
  //
  //   // Once signed in, return the UserCredential
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }
  //
  // String generateNonce([int length = 32]) {
  //   const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  //   final random = Random.secure();
  //   return List.generate(length, (_) => charset[random.nextInt(charset.length)])
  //       .join();
  // }
  //
  // /// Returns the sha256 hash of [input] in hex notation.
  // String sha256ofString(String input) {
  //   final bytes = utf8.encode(input);
  //   final digest = sha256.convert(bytes);
  //   return digest.toString();
  // }
  //
  // Future<UserCredential> signInWithApple() async {
  //   // To prevent replay attacks with the credential returned from Apple, we
  //   // include a nonce in the credential request. When signing in with
  //   // Firebase, the nonce in the id token returned by Apple, is expected to
  //   // match the sha256 hash of `rawNonce`.
  //   final rawNonce = generateNonce();
  //   final nonce = sha256ofString(rawNonce);
  //
  //   // Request credential for the currently signed in Apple account.
  //   final appleCredential = await SignInWithApple.getAppleIDCredential(
  //     scopes: [
  //       AppleIDAuthorizationScopes.email,
  //       AppleIDAuthorizationScopes.fullName,
  //     ],
  //     nonce: nonce,
  //   );
  //
  //   // Create an `OAuthCredential` from the credential returned by Apple.
  //   final oauthCredential = OAuthProvider("apple.com").credential(
  //     idToken: appleCredential.identityToken,
  //     rawNonce: rawNonce,
  //   );
  //
  //   // Sign in the user with Firebase. If the nonce we generated earlier does
  //   // not match the nonce in `appleCredential.identityToken`, sign in will fail.
  //   return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  // }
}
