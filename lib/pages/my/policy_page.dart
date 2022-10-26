import 'package:flutter/material.dart';
import 'package:solohouse/_common/c_style.dart';
import 'package:solohouse/_common/util.dart';

import '../../_widgets/common_widgets.dart';

class PolicyPage extends StatefulWidget {
  const PolicyPage({Key? key}) : super(key: key);

  @override
  State<PolicyPage> createState() => _PolicyPageState();
}

class _PolicyPageState extends State<PolicyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('약관 및 정책')
      ),
      body: _buildBody(context)
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              onTap: () {
                showWebDialog(context, '서비스 이용약관', 'https://server/policy/term.html');
              },
              leading: Icon(Icons.text_snippet_outlined, size: 24, color: Colors.black),
              minLeadingWidth: 0,
              contentPadding: EdgeInsets.fromLTRB(16, 4, 8, 4),
              title: Text('서비스 이용약관', style: CStyle.p14_5_4),
              trailing: Icon(Icons.keyboard_arrow_right, size: 24, color: CStyle.colorGrey7),
            ),
            Divider(height: 1, thickness: 1, color: hexColor('F5F5F5')),
            ListTile(
              onTap: () {
                showWebDialog(context, '개인정보 취급방침', 'https://server/policy/privacy.html');
              },
              leading: Icon(Icons.supervised_user_circle_outlined, size: 24, color: Colors.black),
              minLeadingWidth: 0,
              contentPadding: EdgeInsets.fromLTRB(16, 4, 8, 4),
              title: Text('개인정보 취급방침', style: CStyle.p14_5_4),
              trailing: Icon(Icons.keyboard_arrow_right, size: 24, color: CStyle.colorGrey7),
            ),
            Divider(height: 1, thickness: 1, color: hexColor('F5F5F5')),
            ListTile(
              onTap: () {
                showWebDialog(context, '개인정보 이용/수집', 'https://server/policy/privacy_use.html');
              },
              leading: Icon(Icons.person_search_outlined, size: 24, color: Colors.black),
              minLeadingWidth: 0,
              contentPadding: EdgeInsets.fromLTRB(16, 4, 8, 4),
              title: Text('개인정보 이용/수집', style: CStyle.p14_5_4),
              trailing: Icon(Icons.keyboard_arrow_right, size: 24, color: CStyle.colorGrey7),
            ),
            Divider(height: 1, thickness: 1, color: hexColor('F5F5F5')),
          ],
        ),
      ),
    );
  }
}
