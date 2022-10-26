import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../_common/c_style.dart';
import '../_common/user_model.dart';
import '../_common/util.dart';
import '../_model/solohouse_model.dart';
import 'content_search_list_page.dart';
import 'magazine_view_dialog.dart';

class RootMagazineCell extends StatefulWidget {
  const RootMagazineCell({Key? key, required this.data, required this.onClickSave, required this.onClickLike, required this.onClickReply, required this.onClickShare}) : super(key: key);
  final SolohouseModel data;
  final Function onClickSave;
  final Function onClickLike;
  final Function onClickReply;
  final Function onClickShare;

  @override
  State<RootMagazineCell> createState() => _RootMagazineCellState();
}

class _RootMagazineCellState extends State<RootMagazineCell> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }


  @override
  void didUpdateWidget(covariant RootMagazineCell oldWidget) {
    super.didUpdateWidget(oldWidget);

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        InkWell(
          onTap: () {},
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        ),
        content(),
        tools(),
      ],
    );
  }

  Widget content() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double imageWidth = screenWidth - 60;
    double imageHeight = screenHeight - 80 - 180;
    double pageViewRate = imageWidth / screenWidth;

    List<Widget> widgets = [];
    List<String> images = widget.data.images!.split(',');
    images.insert(0, widget.data.cover!);

    List<String> imageUrls = [];
    for(String url in images) {
      if(url.isEmpty) {
        continue;
      }

      if(!url.toLowerCase().startsWith('http')) {
        url = 'https://server/$url';
      }

      imageUrls.add(url);

      //url = '$url?w=${imageWidth*2}&h=${imageHeight*2}';
    }


    for(String url in imageUrls) {
      widgets.add(
          Container(
            margin: EdgeInsets.only(left: 3, right: 3),
            width: imageWidth,
            height: imageHeight,
            child: Image.network(url, width: imageWidth, height: imageHeight, fit: BoxFit.cover),
          )
      );
    }

    List<String> tags = [];
    if(widget.data.keyword!.isNotEmpty) {
      tags = widget.data.keyword!.split(',');
    }

    String message = widget.data.message!;
    if(message.length > 80) {
      message = widget.data.message!.substring(0, 80);
    }



    return Container(

      margin: EdgeInsets.only(top: 80, bottom: 40),
      child: Column(
        children: [
          Expanded(
              child: PageView(
                  key: widget.data.key,
                  restorationId: widget.data.contentNo.toString(),
                  controller: PageController(initialPage: widget.data.imageIndex, viewportFraction: pageViewRate),
                  onPageChanged: (index) {
                    widget.data.imageIndex = index;
                  },
                  clipBehavior: Clip.antiAlias,
                  children: widgets
              )
          ),
          Container(
            padding: EdgeInsets.only(left: 30),
            width: screenWidth,
            height: 180,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
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
                      builder: (context) => MagazineViewDialog(contentNo: widget.data.contentNo!),
                    );
                  },
                  child: Text('"${widget.data.title!}"', style: CStyle.p14_7_white)
                ),
                SizedBox(height: 16),
                Text(message, style: CStyle.p12_3_D, maxLines: 4, overflow: TextOverflow.ellipsis),
              ],
            )
          ),
        ],
      ),
    );
  }

  Widget tools() {
    return Container(
      padding: EdgeInsets.only(right: 30),
      height: 100,
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
                builder: (context) => MagazineViewDialog(contentNo: widget.data.contentNo!),
              );
            },
            child: Container(
              padding: EdgeInsets.only(left: 30, bottom: 32, right: 30),
              child: Text('더보기', style: CStyle.p12_3_white_under)
            )
          ),
          Expanded(child: SizedBox()),
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
}
