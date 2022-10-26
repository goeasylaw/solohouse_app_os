import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:image_cropping/image_cropping.dart';
import 'package:image_picker/image_picker.dart';

import '../../_common/api.dart';
import '../../_common/c_style.dart';
import '../../_common/user_model.dart';
import '../../_common/util.dart';
import '../../_widgets/textfield_dialog.dart';
import '../../app_config.dart';
import 'my_push_setting_page.dart';


class MyEditPage extends StatefulWidget {
  const MyEditPage({Key? key}) : super(key: key);

  @override
  State<MyEditPage> createState() => _MyEditPageState();
}

class _MyEditPageState extends State<MyEditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('개인/설정', style: CStyle.appbarTitle),
        ),
        body: _buildBody()
    );
  }

  Widget _buildBody() {
    double backgroundHeight = MediaQuery.of(context).size.width * 0.5625;
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
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
                              margin: EdgeInsets.only(bottom: 66, right: 16),
                              child: _picturePopup(isBackground: true)
                          )
                        ],
                      ),
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            _userPicture(),
                            _picturePopup()
                          ],
                        ),
                      )
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
                          showDialog(
                              context: context,
                              barrierDismissible: true, // user must tap button!
                              builder: (BuildContext context) {
                                return TextFieldDialog(
                                  text: UserModel().myInformation!.userInfo!.userName!,
                                  length: 15,
                                );
                              }
                          ).then((value) {
                            if(value != null) {
                              //저장한다.
                              saveNickName(value);
                            }
                          });
                        },
                        child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(Icons.edit, color: hexColor('777777'), size: 18,)
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 28),
                  Divider(height: 8, thickness: 8, color: hexColor('F9F9F9')),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PushSettingPage()),
                      );
                    },
                    child: ListTile(
                        title: Text('알림설정', style: CStyle.p15_4_7),
                        trailing: Icon(Icons.keyboard_arrow_right)
                    ),
                  ),
                  Divider(height: 1, thickness: 1, color: hexColor('F3F3F3')),
                  InkWell(
                    onTap: () {
                      logout();
                    },
                    child: ListTile(
                      title: Text('로그아웃', style: CStyle.p15_4_7),
                    ),
                  ),
                  Divider(height: 1, thickness: 1, color: hexColor('F3F3F3')),
                ],
              ),
            )
          ),
          InkWell(
            onTap: () {
              leave();
            },
            child: Container(
              height: 46,
              alignment: Alignment.center,
              child: Text('탈퇴하기', style: CStyle.p14_3_6),
            ),
          )
        ],
      ),
    );
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

  void saveNickName(String nickName) async {
    if(UserModel().isLogin) {
      String url = '${AppConfig().baseUrl()}/user/information';

      SmartDialog.showLoading();
      var response = await Api().put(Uri.parse(url), body: {'nickName': nickName});
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


  Widget _picturePopup({bool isBackground = false}) => PopupMenuButton<int>(
    child: Image.asset('assets/images/icon_photo.png', width: 36, height: 36,),
    onSelected: (value) {
      if(value == 1) {
        userPicture(isBackground: isBackground);
      } else if(value == 2) {
        userPictureDefault(isBackground: isBackground);
      }
    },
    itemBuilder: (context) => [
      PopupMenuItem(
        value: 1,
        child: Text("앨범에서 사진 선택", style: CStyle.p12_5_3),
      ),
      PopupMenuItem(
        value: 2,
        child: Text("기본 이미지로 변경", style: CStyle.p12_5_3),
      ),
    ],
  );

  Future<void> userPicture({bool isBackground = false}) async {
    var res = await checkGrantPhoto(context);
    if(res) {
      XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(pickedFile == null) {
        return;
      }

      ImageCropping.cropImage(
        context: context,
        imageBytes: await pickedFile.readAsBytes(),
        selectedImageRatio: isBackground?CropAspectRatio(ratioX: 16, ratioY: 9):CropAspectRatio(ratioX: 1, ratioY: 1),
        visibleOtherAspectRatios: false,
        customAspectRatios: null,
        onImageDoneListener: (data) async {
          SmartDialog.showLoading();
          var response = await Api().uploadBytes(pickedFile.name, data);
          SmartDialog.dismiss();

          if(checkApiError(response)) {
            return;
          }

          if (response.statusCode == 200) {
            await uploadPicture(response.body, isBackground: isBackground);
          }
        }
      );
    }
  }

  Future<void> uploadPicture(String uploadInfo, {bool isBackground = false}) async {
    var body = {
      'uploadFiles': uploadInfo
    };

    var url = '${AppConfig().baseUrl()}/user/picture';
    if(isBackground) {
      url = '${AppConfig().baseUrl()}/user/background';
    }

    SmartDialog.showLoading();
    var response = await Api().put(Uri.parse(url), body: body);
    SmartDialog.dismiss();

    if(checkApiError(response)) {
      return;
    }

    await UserModel().getMyInformation();

    setState(() {});
  }

  Future<void> userPictureDefault({bool isBackground = false}) async {
    //서버로 이미지 삭제 API를 전달하고 이미지를 지운다.
    String url = '${AppConfig().baseUrl()}/user/picture';
    if(isBackground) {
      url = '${AppConfig().baseUrl()}/user/background';
    }

    SmartDialog.showLoading();
    var response = await Api().delete2(Uri.parse(url));
    SmartDialog.dismiss();

    if(checkApiError(response)) {
      return;
    }

    await UserModel().getMyInformation();

    setState(() {});
  }

  void logout() {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.confirm,
        title: '로그아웃 하시겠습니까?',
        text: '',
        confirmBtnText: '로그아웃',
        cancelBtnText: '닫기',
        onConfirmBtnTap: () {
          UserModel().logout().then((value) {
            Navigator.pop(context, 'logout');
          });
        }
    ).then((value) {
      if(value == 'logout') {
        Navigator.pop(context, 'logout');
      }
    });
  }


  void leave() {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.confirm,
        title: '정말로 탈퇴 하시겠습니까?',
        text: '',
        confirmBtnText: '탈퇴하기',
        cancelBtnText: '닫기',
        onConfirmBtnTap: () async {
          var url = '${AppConfig().baseUrl()}/user/leave';
          Api().put(Uri.parse(url)).then((value) {
            print(value.body);
            UserModel().logout().then((value) {
              Navigator.pop(context, 'logout');
            });
          });

        }
    ).then((value) {
      if(value == 'logout') {
        Navigator.pop(context, 'logout');
      }
    });
  }
}
