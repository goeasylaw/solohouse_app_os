import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:solohouse/_common/c_style.dart';

import '../../_widgets/common_widgets.dart';

class PolicyConfirm extends StatefulWidget {
  const PolicyConfirm({Key? key}) : super(key: key);

  @override
  State<PolicyConfirm> createState() => _PolicyConfirmState();
}

class _PolicyConfirmState extends State<PolicyConfirm> {
  bool check1 = false;
  bool check2 = false;
  bool check3 = false;


  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: EdgeInsets.all(0),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          margin: EdgeInsets.only(top: 32),
          width: MediaQuery.of(context).size.width-64,

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32)
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 32),
              Text('약관 동의', style: CStyle.p18_7_sec),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  children: [
                    InkWell(
                        onTap: () {
                          showWebDialog(context, '서비스 이용약관', 'https://server/policy/term.html');
                        },
                        child: Text('서비스 이용약관', style: CStyle.p14_5_pri)
                    ),
                    Expanded(child: SizedBox()),
                    Checkbox(
                        value: check1,
                        onChanged: (value) {
                          setState(() {
                            check1 = value as bool;
                          });
                        }
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  children: [
                    InkWell(
                        onTap: () {
                          showWebDialog(context, '개인정보 취급방침', 'https://server/policy/privacy.html');
                        },
                        child: Text('개인정보 취급방침', style: CStyle.p14_5_pri)
                    ),
                    Expanded(child: SizedBox()),
                    Checkbox(
                        value: check2,
                        onChanged: (value) {
                          setState(() {
                            check2 = value as bool;
                          });
                        }
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  children: [
                    InkWell(
                        onTap: () {
                          showWebDialog(context, '개인정보 이용/수집', 'https://server/policy/privacy_use.html');
                        },
                        child: Text('개인정보 이용/수집', style: CStyle.p14_5_pri)
                    ),
                    Expanded(child: SizedBox()),
                    Checkbox(
                        value: check3,
                        onChanged: (value) {
                          setState(() {
                            check3 = value as bool;
                          });
                        }
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, "NO");
                    },
                    child: Text('취소')
                  ),
                  TextButton(
                      onPressed: () {
                        if(check1 && check2 && check3) {
                          Navigator.pop(context, "YES");
                        } else {
                          SmartDialog.showToast('약관에 동의해 주세요.');
                        }

                      },
                      child: Text('진행')
                  ),
                  SizedBox(width: 16),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        )
    );
  }
}
