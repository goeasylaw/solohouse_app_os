import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:solohouse/_common/user_model.dart';
import 'package:solohouse/_model/solohouse_model.dart';
import 'package:solohouse/_model/solohouse_repository.dart';
import 'package:solohouse/_widgets/video_widget.dart';
import 'package:solohouse/pages/reply_page.dart';
import 'package:solohouse/pages/report_dialog.dart';
import 'package:solohouse/pages/user_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../_common/c_style.dart';
import '../_common/util.dart';
import '../_widgets/common_widgets.dart';
import '../_widgets/photo_dialog.dart';
import '../_widgets/view_bottom.dart';
import '../app_config.dart';
import 'content_edit_page.dart';

class ContentViewPage extends StatefulWidget {
  const ContentViewPage({Key? key, required this.contentNo}) : super(key: key);
  final int contentNo;

  @override
  State<ContentViewPage> createState() => _ContentViewPageState();
}

class _ContentViewPageState extends State<ContentViewPage> {

  SolohouseModel? data;
  List<String> images = [];
  SolohouseRepository repository = SolohouseRepository();

  List<Widget> actions = [];

  @override
  void initState() {
    super.initState();

    repository.addListener(repositoryListener);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      data = await repository.getOne(widget.contentNo);
      images = data!.images!.split(',');
      if(UserModel().isMy(data!.userInfo!.userNo!)) {
        actions.add(
            TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size(50, 30),
                ),
                onPressed: () {
                  //수정 페이지로 이동한다.
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContentEditPage(contentNo: data!.contentNo!)),
                  ).then((value) async {
                    data = await repository.getOneReload(widget.contentNo);
                    setState(() {
                    });
                  });
                },
                child: Text('수정')
            )
        );

        actions.add(
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(50, 30),
              ),
              onPressed: () {
                CoolAlert.show(
                  context: context,
                  type: CoolAlertType.confirm,
                  title: '삭제 확인',
                  text: '삭제하시겠습니까?',
                  confirmBtnText: '삭제하기',
                  cancelBtnText: '닫기',
                  onConfirmBtnTap: () {
                    repository.delete(widget.contentNo).then((value) {
                      Navigator.pop(context, 'BACK');
                    });
                  }
                ).then((value) {
                  if(value == 'BACK') {
                    Navigator.pop(context, 'REFRESH');
                  }
                });
              },
              child: Text('삭제')
            )
        );


      } else {
        actions.add(
            _morePopup()
            // TextButton(
            //     onPressed: () {
            //       showDialog(
            //           context: context,
            //           builder: (BuildContext context) => ReportDialog('post', data!.contentNo!)
            //       ).then((value) {
            //         Navigator.pop(context, "REFRESH");
            //       });
            //     },
            //     child: Text('신고하기')
            // )
        );
      }
      setState((){});
    });
  }

  void repositoryListener() {
    setState(() {
    });
  }


  @override
  void dispose() {
    repository.removeListener(repositoryListener);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: data==null?Text(''):Row(
          children: [
            imageProfileSmall(data!.userInfo!.smallPhotoUrl!),
            SizedBox(width: 6),
            Text(data!.userInfo!.userName!, style: CStyle.p14_7_4),
          ],
        ),
        actions: actions,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return data==null?Container():SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Visibility(
                        visible: images.isNotEmpty,
                        child: _videoView()
                      ),
                      SizedBox(height: 16),
                      _head(),
                      _content()
                    ],
                  ),
                )
            ),
            ViewBottom(
              isSave: data!.myScrap==1,
              isLike: data!.myLike==1,
              saveCount: data!.scrapCount!,
              likeCount: data!.likeCount!,
              replyCount: data!.replyCount!,
              onClickSave: () {
                repository.scrap(data!.myScrap==0, data!.contentNo!).then((value) {
                  setState(() {

                  });


                });


              },
              onClickLike: () {
                repository.like(data!.myLike==0, data!.contentNo!).then((value) {
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
                  builder: (context) => ReplyPage(contentNo: data!.contentNo!),
                );
              },
              onClickShare: () {

              },
            )
          ],
        )
    );
  }

  Widget _videoView() {
    double cellWidth = (MediaQuery.of(context).size.width - 32);
    double cellHeight = cellWidth * 0.5625;
    if(images.length == 1) {
    } else if(images.length == 2) {
      cellWidth = ((MediaQuery.of(context).size.width - 32) / 2) - 10;
      cellHeight = cellWidth * 1.77;
    } else {
      cellWidth = (MediaQuery.of(context).size.width - 16 - 20 - 20) / 2;
      cellHeight = cellWidth * 1.77;
    }

    List<Widget> imageWidgets = [];
    for(String path in images) {

      if(path.endsWith('.m3u8')) {
        String url = 'https://server/$path';
        imageWidgets.add(
          Container(
            width: cellWidth,
            height: cellHeight,
            child: VideoWidget(
              url: url,
              width: cellWidth,
              height: cellHeight,
            ),
          )
        );

      } else {
        if(!path.toLowerCase().startsWith('http')) {
          path = 'https://server/$path';
        }

        imageWidgets.add(

          InkWell(
              onTap: () {
                showPhoto(images.indexOf(path));
              },
              child: Image.network(path, width: cellWidth, height: cellHeight, fit: BoxFit.cover)
          ),
        );
      }


      imageWidgets.add(
        SizedBox(width: 10)
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 16, right: 16),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...imageWidgets
        ],
      ),
    );
  }

  Widget _head() {
    List<String> tags = [];
    if(data!.keyword!.isNotEmpty) {
      tags = data!.keyword!.split(',');
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //켄텐츠가 나온다
          Row(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(4, 2, 4,2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    border: Border.all(
                        color: hexColor('DDDDDD'),
                        width: 1
                    )
                ),
                child: Text(data!.category!, style: CStyle.p10_5_9),
              ),
              SizedBox(width: 6),
              Text(createdAtDateOrTimeChat(data!.createdAt!), style: CStyle.p12_3_9,)

            ],
          ),
          SizedBox(height: 20),
          Text(data!.title!, style: CStyle.p18_7_3,),
          Visibility(
            visible: tags.isNotEmpty,
            child: Container(
              margin: EdgeInsets.only(top: 40),
              child: Tags(
                  itemCount: tags.length,
                  spacing: 12,
                  runSpacing: 4,
                  alignment: WrapAlignment.start,
                  itemBuilder: (int index) {
                    return Container(
                      padding: EdgeInsets.all(1),
                      child: Text('#${tags[index]}', style: CStyle.p14_3_pri),
                    );
                  }
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _content() {
    double cellWidth = MediaQuery.of(context).size.width - 32;
    List<Widget> imageWidgets = [];
    // for(String path in images) {
    //   imageWidgets.add(
    //     Image.network('${AppConfig().fileServerUrl}$path?w=400', width: cellWidth, fit: BoxFit.fitWidth),
    //   );
    // }


    List<Widget> solostay = [];
    print(data!.category);
    if(data!.category == '솔로스테이') {
      solostay.add(
          InkWell(
            onTap: () {
              String link = data!.magazine!.replaceAll('[{"link","', '').replaceAll('"}]', '');
              launchUrl(Uri.parse(link));
              //launchUrl(Uri.parse());
            },
            child: Center(
              child: Container(
                margin: EdgeInsets.only(bottom: 20),
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                width: 120,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: CStyle.colorPri,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Text('예약하러 가기', style: CStyle.p14_7_white),
              ),
            ),
          )
      );
    }


    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: MediaQuery.of(context).size.width),
          Text(data!.message!, style: CStyle.p16_3_6_16),
          SizedBox(height: 40),
          ...imageWidgets,
          SizedBox(height: 20),
          ...solostay

        ],
      ),
    );
  }

  void showPhoto(int initPage) {
    List<String> photos = [];

    for(String path in images) {
      if(!path.toLowerCase().startsWith('http')) {
        path = 'https://server/$path';
      }

      photos.add(path);
    }


    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(true);
            },
            child: PhotoDialog(photos, initPage: initPage),
          );
        }
    );
  }

  Widget _morePopup() => PopupMenuButton<int>(
    child: Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Icon(Icons.more_horiz, size: 24, color: Colors.grey)
    ),
    onSelected: (value) {
      if(value == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserPage(userInfo: data!.userInfo!)),
        );
      } else if(value == 2) {
        CoolAlert.show(
            context: context,
            type: CoolAlertType.confirm,
            title: '사용자 차단',
            text: '${data!.userInfo!.userName}님의 글을 차단하시겠습니까?',
            confirmBtnText: '확인',
            cancelBtnText: '닫기',
            onConfirmBtnTap: () {
              setState(() {
                UserModel().blockUsers.add(data!.userInfo!.userNo!);
              });
              Navigator.pop(context);
            }
        ).then((value) {
          Navigator.pop(context, "REFRESH");
        });
      } else if(value == 3) {
        showDialog(
            context: context,
            builder: (BuildContext context) => ReportDialog('post', data!.contentNo!)
        ).then((value) {
          if(value == 'REFRESH') {
            Navigator.pop(context, "REFRESH");
          }
        });
      }
    },
    itemBuilder: (context) => [
      PopupMenuItem(
        value: 1,
        child: Text("사용자의 게시글 보기", style: CStyle.p12_5_3),
      ),
      PopupMenuItem(
        value: 2,
        child: Text("차단하기", style: CStyle.p12_5_3),
      ),
      PopupMenuItem(
        value: 3,
        child: Text("신고하기", style: CStyle.p12_5_3),
      ),
    ],
  );
}
