import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:solohouse/_common/c_style.dart';
import 'package:solohouse/_common/user_model.dart';
import 'package:solohouse/_model/solohouse_model.dart';
import 'package:solohouse/_model/solohouse_repository.dart';
import 'package:solohouse/_model/video_model.dart';
import 'package:solohouse/pages/content_write_page.dart';
import 'package:solohouse/pages/reply_page.dart';
import 'package:solohouse/pages/report_dialog.dart';
import 'package:solohouse/pages/root_solohouse_cell.dart';
import 'package:solohouse/pages/user_page.dart';
import 'package:tiktoklikescroller/controller.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';

import '../_common/util.dart';

class RootSoloHouseView extends StatefulWidget {
  const RootSoloHouseView({Key? key}) : super(key: key);

  @override
  State<RootSoloHouseView> createState() => _RootSoloHouseViewState();
}

class _RootSoloHouseViewState extends State<RootSoloHouseView> {
  SolohouseRepository repository = SolohouseRepository();
  final Controller controller = Controller();
  bool loaded = false;


  @override
  void initState() {
    super.initState();

    controller.addListener((event) {
      VideoModel().allPause();
      if(repository.list.length-1 == event.pageNo) {
        if(repository.nextPage) {
          repository.load();
        }
      }
    });

    repository.addListener(() {
      setState(() {
      });
    });


    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      repository.load().then((value) {
        setState(() {
          loaded = true;
        });
      });
    });

  }

  @override
  void dispose() {
    //controller.disposeListeners();
    super.dispose();
  }


  Widget noData() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Center(child: Text('데이타가 없습니다.', style: CStyle.p16_7_white)),
        Container(
            width: 80,
            height: 80,
            margin: EdgeInsets.only(bottom: 16),
            alignment: Alignment.center,
            child: InkWell(
                onTap: () {
                  if(!UserModel().isLogin) {
                    SmartDialog.showToast ('로그인이 필요합니다.');
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContentWritePage()),
                  );
                },
                child: Icon(Icons.add_circle, size: 46, color: hexColor('FF9473'))
            )
        )
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return loaded==false?Container():SafeArea(
      child: repository.list.isEmpty?noData():Stack(
        alignment: Alignment.bottomRight,
        children: [
          TikTokStyleFullPageScroller(
            controller: controller,
            contentSize: repository.list.length,
            swipePositionThreshold: 0.2,
            swipeVelocityThreshold: 2000,
            animationDuration: const Duration(milliseconds: 400),
            //controller: controller,
            builder: (BuildContext context, int index) {
              SolohouseModel data = repository.list[index];
              if(repository.list.length-1 == index) {
                if(repository.nextPage) {
                  repository.loadNext();
                }
              }

              return RootSolohouseCell(
                data: data,
                onClickSave: () {
                  repository.scrap(data.myScrap==0, data.contentNo!).then((value) {
                    setState(() {
                    });
                  });
                },
                onClickLike: () {
                  repository.like(data.myLike==0, data.contentNo!).then((value) {
                    setState(() {

                    });
                  });
                },
                onClickReply: () {
                  showBarModalBottomSheet(
                    context: context,
                    bounce: false,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)
                    ),
                    backgroundColor: Colors.white,
                    barrierColor: Colors.black45,
                    elevation: 0,
                    builder: (context) => ReplyPage(contentNo: data.contentNo!),
                  );

                },
                onClickUser: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserPage(userInfo: data.userInfo!)),
                  );

                },
                onClickReport: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => ReportDialog('post', data.contentNo!)
                  ).then((value) {
                    if(value == 'REFRESH') {
                      setState(() {
                      });
                    }
                  });
                }, onClickBlockUser: () {
                  //정말 차단하시겠습니까?
                  CoolAlert.show(
                      context: context,
                      type: CoolAlertType.confirm,
                      title: '사용자 차단',
                      text: '${data.userInfo!.userName}님의 글을 차단하시겠습니까?',
                      confirmBtnText: '확인',
                      cancelBtnText: '닫기',
                      onConfirmBtnTap: () {
                        setState(() {
                          UserModel().blockUsers.add(data.userInfo!.userNo!);
                        });
                        Navigator.pop(context);
                      }
                  );
                },
              );
            },
          ),
          Container(
            width: 80,
            height: 80,
            margin: EdgeInsets.only(bottom: 16),
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                if(!UserModel().isLogin) {
                  SmartDialog.showToast ('로그인이 필요합니다.');
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContentWritePage()),
                );
              },
              child: Icon(Icons.add_circle, size: 46, color: hexColor('FF9473'))
            )
          )

        ],
      ),
    );
  }
}
