import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:solohouse/_common/c_style.dart';
import 'package:solohouse/_common/user_model.dart';
import 'package:solohouse/_common/util.dart';


import '../_common/api.dart';
import '../_model/content_repository.dart';
import '../_model/solohouse_repository.dart';
import '../app_config.dart';

class ReportDialog extends StatefulWidget {
  ReportDialog(this.type, this.no, {super.key});
  final String type;
  final int no;

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  final TextEditingController _tecReport = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppbar(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          tooltip: '닫기',
          onPressed: () {
            Navigator.pop(context);
          }
      ),
      title: Text('신고하기',style: CStyle.appbarTitle),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus!.unfocus();
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 150,
                padding: EdgeInsets.only(left: 16, right: 0),
                decoration: BoxDecoration(
                  color: hexColor('F9F9F9'),
                  border: Border.all(
                    color: hexColor('E5E5E5'),
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                    controller: _tecReport,
                    maxLines: 20,
                    style: CStyle.p14_5_4,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: "신고 내용을 입력해 주세요.",
                      hintStyle: CStyle.p14_5_B,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    )
                ),
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: () {
                  if(_tecReport.text == '') {
                     SmartDialog.showToast('신고 내용을 입력해 주세요.');
                    return;
                  }

                  print(widget.type);

                  if(widget.type == 'post') {
                    savePostReport();
                  } else if(widget.type == 'reply') {
                    saveReplyReport();
                  } else if(widget.type == 'user') {
                    saveUserReport();
                  }

                },
                child: Container(
                  alignment: Alignment.center,
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: CStyle.colorPri,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text('보내기',style: CStyle.p16_7_white),
                ),
              ),

            ],
          ),
        ),
      )
    );
  }

  Future<void> savePostReport() async {
    var url = '${AppConfig().baseUrl()}/guest/contentReport';

    var body = {
      'contentNo': widget.no.toString(),
      'message': _tecReport.text
    };

    SmartDialog.showLoading();
    var response = await Api().post(Uri.parse(url), body: body);
    print(response.body);
    SmartDialog.dismiss();

    if(checkApiError(response)) {
      return;
    }

    if(response.statusCode == 200) {

      //차단 콘텐츠
      UserModel().blockContent.add(widget.no);
      ContentRepository().deleteOne(widget.no);
      SolohouseRepository().deleteOne(widget.no);

      CoolAlert.show(
          context: context,
          type: CoolAlertType.info,
          title: '신고되었습니다.',
          text: '운영자가 해당 내용을 확인 후 처리됩니다.',
          confirmBtnText: '확인',
          onConfirmBtnTap: () {
            Navigator.pop(context);
          }
      ).then((value) {
        Navigator.pop(context, 'REFRESH');
      });
    }
  }

  Future<void> saveReplyReport() async {
    var url = '${AppConfig().baseUrl()}/guest/contentReplyReport';

    var body = {
      'replyNo': widget.no.toString(),
      'message': _tecReport.text
    };


    SmartDialog.showLoading();
    var response = await Api().post(Uri.parse(url), body: body);
    SmartDialog.dismiss();



    if(checkApiError(response)) {
      return;
    }

    if(response.statusCode == 200) {
      //차단 댓글
      UserModel().blockReply.add(widget.no);

      CoolAlert.show(
          context: context,
          type: CoolAlertType.info,
          title: '신고되었습니다.',
          text: '운영자가 해당 내용을 확인 후 처리됩니다.',
          confirmBtnText: '확인',
          onConfirmBtnTap: () {
            Navigator.pop(context);
          }
      ).then((value) {
        Navigator.pop(context, 'REFRESH');
      });
    }
  }

  Future<void> saveUserReport() async {
    var url = '${AppConfig().baseUrl()}/guest/userReport';

    var body = {
      'targetUserNo': widget.no.toString(),
      'message': _tecReport.text
    };

    SmartDialog.showLoading();
    var response = await Api().post(Uri.parse(url), body: body);
    SmartDialog.dismiss();

    if(checkApiError(response)) {
      return;
    }

    if(response.statusCode == 200) {
      CoolAlert.show(
          context: context,
          type: CoolAlertType.info,
          title: '신고되었습니다.',
          text: '운영자가 해당 내용을 확인 후 처리됩니다.',
          confirmBtnText: '확인',
          onConfirmBtnTap: () {
            Navigator.pop(context);
          }
      ).then((value) {
        Navigator.pop(context, 'REFRESH');
      });
    }
  }


}
