import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:solohouse/_common/c_style.dart';

import '../../_common/api.dart';
import '../../_common/util.dart';
import '../../app_config.dart';

class DemandWritePage extends StatefulWidget {
  const DemandWritePage({Key? key}) : super(key: key);

  @override
  State<DemandWritePage> createState() => _DemandWritePageState();
}

class _DemandWritePageState extends State<DemandWritePage> {
  final TextEditingController _tecEmail = TextEditingController();
  final TextEditingController _tecDemand = TextEditingController();

  final FocusNode _focusEmail = FocusNode();
  final FocusNode _focusDemand = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('문의하기'),
        ),
        body: _buildBody(context)
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus!.unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: TextField(
                    onSubmitted: (_) {
                      _focusDemand.requestFocus();
                    },
                    controller: _tecEmail,
                    focusNode: _focusEmail,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    style: CStyle.p16_7_3,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        contentPadding: EdgeInsets.only(left: 2, bottom: 13),
                        hintText: "이메일을 입력하세요.",
                        hintStyle: CStyle.p16_7_B,
                        counterText: ""
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: TextField(
                    controller: _tecDemand,
                    focusNode: _focusDemand,
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    maxLines: 6,
                    style: CStyle.p14_5_4,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        contentPadding: EdgeInsets.only(left: 2, bottom: 13),
                        hintText: "문의 내용을 입력해주세요.",
                        hintStyle: CStyle.p14_5_B,
                        counterText: ""
                    ),
                  ),
                ),
                SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    if (_tecDemand.text == '') {
                      SmartDialog.showToast('문의 내용을 작성해 주세요.');
                      return;
                    }

                    saveDemand(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 60,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    decoration: BoxDecoration(
                      color: CStyle.colorPri,
                    ),
                    child: Text('보내기', style: CStyle.p14_7_white),
                  ),
                ),

              ],
            ),
          ),
        )
    );
  }

  Future<void> saveDemand(BuildContext context) async {
    var url = '${AppConfig().baseUrl()}/guest/demand';
    var body = {
      'email': _tecEmail.text,
      'content': _tecDemand.text
    };


    SmartDialog.showLoading();
    var response = await Api().post(Uri.parse(url), body: body);
    SmartDialog.dismiss();

    if (checkApiError(response)) {
      return;
    }

    if (response.statusCode == 200) {
      SmartDialog.showToast('전송되었습니다.');
      if (!mounted) return;
      Navigator.pop(context, 'success');
    }
  }
}