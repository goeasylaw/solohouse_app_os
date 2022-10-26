import 'package:flutter/material.dart';
import 'package:solohouse/_common/c_style.dart';
import 'package:solohouse/_common/util.dart';

class ViewBottom extends StatefulWidget {
  const ViewBottom({Key? key, required this.isSave, required this.isLike, required this.saveCount, required this.likeCount, required this.replyCount, required this.onClickSave, required this.onClickLike, required this.onClickReply, required this.onClickShare}) : super(key: key);

  final bool isSave;
  final bool isLike;
  final int saveCount;
  final int likeCount;
  final int replyCount;
  final Function onClickSave;
  final Function onClickLike;
  final Function onClickReply;
  final Function onClickShare;

  @override
  State<ViewBottom> createState() => _ViewBottomState();
}

class _ViewBottomState extends State<ViewBottom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.only(left: 16, right: 16),
      color: hexColor('F6F6F6'),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              widget.onClickSave();
            },
            child: iconCountButton(
              icon:Icons.bookmark_border,
              selectIcon: Icons.bookmark_outlined,
              isSelect: widget.isSave,
              count: widget.saveCount
            ),
          ),
          SizedBox(width: 16),
          InkWell(
            onTap: () {
              widget.onClickLike();
            },
            child: iconCountButton(
                icon:Icons.favorite_border,
                selectIcon: Icons.favorite_outlined,
                isSelect: widget.isLike,
                count: widget.likeCount
            ),
          ),
          SizedBox(width: 16),
          Visibility(
            visible: widget.replyCount > -1,
            child: InkWell(
              onTap: () {
                widget.onClickReply();
              },
              child: iconCountButton(
                  icon:Icons.mode_comment_outlined,
                  selectIcon: Icons.mode_comment_outlined,
                  isSelect: false,
                  count: widget.replyCount
              ),
            ),
          ),
          Expanded(child: SizedBox()),
          Icon(Icons.share, color: CStyle.colorGrey7, size: 20)
        ],
      ),
    );
  }


  Widget iconCountButton({required IconData icon, required IconData selectIcon, required bool isSelect, required int count}) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Icon(isSelect?selectIcon:icon, color: isSelect?CStyle.colorSec:CStyle.colorGrey7, size: 20),
          SizedBox(width: 3),
          Text(count.toString(), style: CStyle.p12_5_7),
        ],
      ),
    );
  }
}
