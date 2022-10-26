import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:solohouse/_widgets/video_widget.dart';

import '../_common/c_style.dart';
import '../_common/user_model.dart';
import '../_common/util.dart';
import '../_model/solohouse_model.dart';
import '../_widgets/common_widgets.dart';
import 'content_search_list_page.dart';
import 'content_view_dialog.dart';

class RootSolohouseCell extends StatefulWidget {
  const RootSolohouseCell({Key? key, required this.data, required this.onClickSave, required this.onClickLike, required this.onClickReply, required this.onClickUser, required this.onClickReport, required this.onClickBlockUser}) : super(key: key);
  final SolohouseModel data;
  final Function onClickSave;
  final Function onClickLike;
  final Function onClickReply;
  final Function onClickUser;
  final Function onClickBlockUser;
  final Function onClickReport;

  @override
  State<RootSolohouseCell> createState() => _RootSolohouseCellState();
}

class _RootSolohouseCellState extends State<RootSolohouseCell> {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return UserModel().blockUsers.contains(widget.data.userInfo!.userNo!)?blockContent():content(context);
  }

  Widget blockContent() {
    return InkWell(
      onTap: () {

      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('차단된 사용자의 포스트입니다.', style: CStyle.p16_7_white),

            TextButton(
              onPressed: () {
                setState(() {
                  UserModel().blockUsers.remove(widget.data.userInfo!.userNo!);
                });
              },
              child: Text('차단 해제', style: CStyle.p14_3_pri)
            )
          ],
        ),
      ),
    );
  }


  Widget content(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double imageWidth = screenWidth;
    double imageHeight = screenHeight;
    double pageViewRate = imageWidth / screenWidth;

    List<Widget> widgets = [];
    List<String> images = widget.data.images!.split(',');

    List<String> imageUrls = [];
    for(String url in images) {
      if(url.isEmpty) {
        continue;
      }

      if(!url.toLowerCase().startsWith('http')) {
        url = 'https://server/$url';
      }

      imageUrls.add(url);
    }


    for(String url in imageUrls) {
      if(url.endsWith('.m3u8')) {
        url = url.replaceAll('https://server', 'https://server');
        widgets.add(
          Container(
            margin: EdgeInsets.only(left: 0, right: 0),
            width: imageWidth,
            height: imageHeight,
            child: VideoWidget(
              url: url,
              width: imageWidth,
              height: imageHeight,
            ),
          )
        );
      } else {
        widgets.add(
            Container(
              margin: EdgeInsets.only(left: 3, right: 3),
              width: imageWidth,
              height: imageHeight,
              child: Image.network(url, width: imageWidth, height: imageHeight, fit: BoxFit.cover),
            )
        );
      }
    }

    PageController pageController = PageController(initialPage: widget.data.imageIndex, viewportFraction: pageViewRate);

    List<String> tags = [];
    if(widget.data.keyword!.isNotEmpty) {
      tags = widget.data.keyword!.split(',');
    }

    return Stack(
      key: widget.data.key,
      alignment: Alignment.bottomRight,
      children: [
        PageView(
            restorationId: widget.data.contentNo.toString(),
            controller: pageController,
            onPageChanged: (index) {
              widget.data.imageIndex = index;
            },
            clipBehavior: Clip.antiAlias,
            children: widgets
        ),
        Container(
          width: screenWidth,
          height: 200,
          padding: EdgeInsets.only(left: 30, right: 30),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black26,
                  Colors.black38,
                ],
              )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _userPopup(),
              // InkWell(
              //   onTap: () {
              //     widget.onClickUser();
              //   },
              //   child: Row(
              //     children: [
              //       imageProfileSmall(widget.data.userInfo!.smallPhotoUrl!),
              //       SizedBox(width: 6),
              //       Text(widget.data.userInfo!.userName!, style: CStyle.p14_7_white),
              //     ],
              //   ),
              // ),
              SizedBox(height: 20),
              Text(widget.data.title!, style: CStyle.p18_7_white),
              SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Tags(
                    itemCount: tags.length,
                    spacing: 12,
                    runSpacing: 4,
                    alignment: WrapAlignment.start,
                    itemBuilder: (int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ContentSearchListPage(searchText: '#${tags[index]}')),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(1),
                          child: Text('#${tags[index]}', style: CStyle.p12_3_D),
                        ),
                      );
                    }
                ),
              ),
              Text(widget.data.message!, style: CStyle.p14_3_white_16, maxLines: 2,),
              SizedBox(height: 10),
              InkWell(
                  onTap: () {
                    showBarModalBottomSheet(
                      context: context,
                      bounce: false,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)
                      ),
                      backgroundColor: hexColor('312A28'),
                      barrierColor: Colors.black45,
                      elevation: 0,
                      builder: (context) => ContentViewDialog(contentNo: widget.data.contentNo!),
                    );
                  },
                  child: Container(
                    height: 48,
                    child: Text('더보기', style: CStyle.p12_3_white_under)
                  )
              ),
            ],
          ),
        ),
        widgets.isEmpty?SizedBox():SmoothPageIndicator(
            controller: pageController,
            count: widgets.length,
            effect: WormEffect(
                dotHeight: 2,
                dotWidth: screenWidth / widgets.length,
                type: WormType.normal,
                spacing: 0,
                radius:0,
                dotColor: Colors.black12,
                activeDotColor: Colors.white
            ),
            onDotClicked: (index){
            }
        ),
        tools(),
      ],
    );
  }

  Widget tools() {
    return Container(
      width: 80,
      padding: EdgeInsets.only(bottom: 32),
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              if(!UserModel().isLogin) {
                SmartDialog.showToast('로그인이 필요합니다.');
                return;
              }
              widget.onClickSave();
            },
            child: toolButton(
                icon:Icons.bookmark,
                selectIcon: Icons.bookmark,
                isSelect: widget.data.myScrap==1,
                count: widget.data.scrapCount!
            ),
          ),
          SizedBox(width: 16),
          InkWell(
            onTap: () {
              if(!UserModel().isLogin) {
                SmartDialog.showToast('로그인이 필요합니다.');
                return;
              }
              widget.onClickLike();
            },
            child: toolButton(
                icon:Icons.favorite,
                selectIcon: Icons.favorite,
                isSelect: widget.data.myLike==1,
                count: widget.data.likeCount!
            ),
          ),
          SizedBox(width: 16),
          InkWell(
            onTap: () {
              widget.onClickReply();
            },
            child: toolButton(
                icon:Icons.mode_comment,
                selectIcon: Icons.mode_comment,
                isSelect: false,
                count: widget.data.replyCount!
            ),
          ),
          SizedBox(width: 16),
          InkWell(
            onTap: () {
              widget.onClickReport();
            },
            child: Container(
              margin: EdgeInsets.only(top: 8, bottom: 8),
              width: 32,
              height: 28,
              alignment: Alignment.center,
              child: Icon(Icons.block, color: hexColor('DDDDDD'), size: 24),
            ),
          ),
          SizedBox(height: 64)
        ],
      ),

    );
  }

  Widget toolButton({required IconData icon, required IconData selectIcon, required bool isSelect, required int count}) {
    return Container(
      margin: EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        children: [
          Container(
            width: 32,
            height: 28,
            alignment: Alignment.center,
            child: Opacity(
              opacity: isSelect?1.0:0.8,
              child: Icon(isSelect?selectIcon:icon, color: isSelect?CStyle.colorSec:hexColor('DDDDDD'), size: 24)
            ),
          ),
          Text(count.toString(), style: CStyle.p12_7_white),
        ],
      ),
    );
  }

  Widget _userPopup() => PopupMenuButton<int>(
    child: Row(
      children: [
        imageProfileSmall(widget.data.userInfo!.smallPhotoUrl!),
        SizedBox(width: 6),
        Text(widget.data.userInfo!.userName!, style: CStyle.p14_7_white),
      ],
    ),
    onSelected: (value) {
      if(value == 1) {
        widget.onClickUser();
      } else if(value == 2) {
        widget.onClickBlockUser();
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
    ],
  );
}


