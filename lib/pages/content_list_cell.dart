import 'package:flutter/material.dart';

import '../_common/c_style.dart';
import '../_common/user_model.dart';
import '../_common/util.dart';
import '../_model/solohouse_model.dart';
import '../_widgets/common_widgets.dart';

class ContentListCell extends StatefulWidget {
  const ContentListCell({Key? key, required this.data}) : super(key: key);
  final SolohouseModel data;

  @override
  State<ContentListCell> createState() => _ContentListCellState();
}

class _ContentListCellState extends State<ContentListCell> {
  @override
  Widget build(BuildContext context) {
    return UserModel().blockUsers.contains(widget.data.userInfo!.userNo)?_buildBlockCell():_buildCell();
  }

  Widget _buildBlockCell() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        listImageView(""),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("차단된 사용자의 포스트입니다.", style: CStyle.p14_5_4),
            ],
          ),
        ),
        SizedBox(width: 16)
      ],
    );
  }

  Widget _buildCell() {
    return UserModel().blockContent.contains(widget.data.contentNo)?SizedBox():Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        listImageView(widget.data.cover!),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                child: Text(widget.data.category!, style: CStyle.p10_5_9),
              ),
              SizedBox(height: 14),
              Text(widget.data.title!, style: CStyle.p14_5_4, maxLines: 2),
              SizedBox(height: 14),
              widget.data.category=='매거진'?SizedBox():Row(
                children: [
                  imageProfileSmall(widget.data.userInfo!.smallPhotoUrl!),
                  SizedBox(width: 6),
                  Text(widget.data.userInfo!.userName!, style: CStyle.p14_5_4),
                ],
              )
            ],
          ),
        ),
        SizedBox(width: 16)
      ],
    );
  }



}
