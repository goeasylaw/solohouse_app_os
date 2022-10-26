import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:solohouse/_common/c_style.dart';
import 'package:solohouse/_common/user_model.dart';
import 'package:solohouse/_common/util.dart';
import 'package:solohouse/_model/reply_model.dart';
import 'package:solohouse/_model/reply_repository.dart';
import 'package:solohouse/pages/report_dialog.dart';

import '../_widgets/common_widgets.dart';

class ReplyPage extends StatefulWidget {
  const ReplyPage({Key? key, required this.contentNo}) : super(key: key);
  final int contentNo;

  @override
  State<ReplyPage> createState() => _ReplyPageState();
}

class _ReplyPageState extends State<ReplyPage> {
  late ReplyRepository repository;
  bool load = false;
  final TextEditingController replyTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    repository = ReplyRepository(widget.contentNo);

    repository.addListener(repositoryListener);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      repository.load().then((value) {
        setState(() {
          load = true;
        });
      });
    });
  }

  void repositoryListener() {
    setState(() {});
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
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 32),
          //댓글 쓰기
          UserModel().isLogin?replyWrite():Container(),
          Expanded(
            child: !load?Center(child: CircularProgressIndicator()):replyList ()
          )
        ],
      )
    );
  }

  Widget replyWrite() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16),
          child: Row(
            children: [
              imageProfileSmall(UserModel().myInformation!.userInfo!.smallPhotoUrl!),
              SizedBox(width: 6),
              Text(UserModel().myInformation!.userInfo!.userName!, style: CStyle.p12_5_3),
              Expanded(child: SizedBox()),
              InkWell(
                onTap: () {
                  //댓글을 저장한다.
                  if(replyTextController.text.isEmpty) {
                    SmartDialog.showToast('댓글이 비었습니다.');
                    return;
                  }

                  repository.replyWrite(widget.contentNo, replyTextController.text).then((value) {
                    replyTextController.text = '';
                  });
                },
                child: Padding(
                  padding: EdgeInsets.all(4),
                  child: Text('댓글쓰기', style: CStyle.p14_3_pri,)
                ),
              ),
              SizedBox(width: 16)
            ],
          ),
        ),
        SizedBox(height: 16),
        Container(
          margin: EdgeInsets.only(left: 16, right: 16),
          decoration: BoxDecoration(
          ),
          child: TextField(
              controller: replyTextController,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              autofocus: true,
              maxLines: null,
              maxLength: 1000,
              style: CStyle.p14_5_4,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16, bottom: 0, top: 0),
                border: InputBorder.none,
                hintText: '댓글쓰기',
                hintStyle: CStyle.p14_3_6,
                counterText: ''
              )
          ),
        ),
        SizedBox(height: 8),
        SizedBox(
          width: MediaQuery.of(context).size.width-32,
          child: TextHighlight(
              text: "* 댓글작성시 서비스 이용약관 동의로 간주됩니다.",
              textStyle: CStyle.p12_4_6,
              words: {
                "서비스 이용약관": HighlightedWord(
                  onTap: () {
                    showWebDialog(context, '서비스 이용약관', 'https://server/policy/term.html');
                  },
                  textStyle: CStyle.p12_4_sec,
                )
              },
              matchCase: true // will highlight only exactly the same string
          ),
        ),
        SizedBox(height: 8),
        Divider(
          height: 1,
          thickness: 1,
          color: hexColor('F3F3F3'),
        ),
      ],
    );
  }

  Widget replyList() {
    return repository.list.isEmpty?Center(child: Text('댓글이 없습니다.')):ListView.separated(
        padding: EdgeInsets.zero,
        separatorBuilder: (context, index) => Divider(
          color: hexColor('F3F3F3'),
          height: 1,
          thickness: 1,
        ),
        itemCount: repository.list.length,
        itemBuilder: (BuildContext context, int i) {
          if(repository.nextPage) {
            if ((i + 1) == repository.list.length) {
              repository.loadNextPage();
            }
          }
          return  UserModel().blockUsers.contains(repository.list[i].userInfo!.userNo!)?blockReplyCell(repository.list[i]):replyCell(repository.list[i]);
        }
    );
  }

  Widget blockReplyCell(ReplyItemModel item) {
    return Container(
      padding: EdgeInsets.only(left: 16, top: 20, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('차단된 사용자의 댓글입니다.', style: CStyle.p14_5_B)
        ],
      ),
    );
  }

  Widget replyCell(ReplyItemModel item) {
    return Container(
      padding: EdgeInsets.only(left: 16, top: 20, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              imageProfileSmall(item.userInfo!.smallPhotoUrl!),
              SizedBox(width: 6),
              Text(item.userInfo!.userName!, style: CStyle.p12_5_3),
              SizedBox(width: 6),
              Text(createdAtDateOrTimeChat(item.createdAt!), style: CStyle.p12_3_9),
              Expanded(child: SizedBox()),
              Visibility(
                visible: UserModel().isMy(item.userInfo!.userNo!),
                child: InkWell(
                  onTap: () {
                    CoolAlert.show(
                        context: context,
                        type: CoolAlertType.confirm,
                        title: '삭제 확인',
                        text: '댓글을 삭제하시겠습니까?',
                        confirmBtnText: '삭제하기',
                        cancelBtnText: '닫기',
                        onConfirmBtnTap: () {
                          repository.replyDelete(item.replyNo!).then((value) {
                            Navigator.pop(context);
                          });
                        }
                    );
                    //CoolAlertType.confirm

                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                    child: Text('삭제', style: CStyle.p12_4_sec)
                  ),
                ),
              ),
              Visibility(
                visible: !UserModel().isMy(item.userInfo!.userNo!),
                child: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => ReportDialog('reply', item.replyNo!)
                    ).then((value) {
                      if(value == 'REFRESH') {
                        setState(() {
                        });
                      }
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                    child: Text('신고하기', style: CStyle.p12_4_sec)
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Text(UserModel().blockReply.contains(item.replyNo)?"임시로 차단되었습니다.":item.message!, style: CStyle.p14_3_6_16)
          ),
        ],
      ),
    );
  }
}
