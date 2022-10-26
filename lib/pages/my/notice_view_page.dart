import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solohouse/_common/c_style.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../_common/util.dart';
import '../../_model/notice_api.dart';
import '../../_widgets/Loading.dart';

class NoticeViewPage extends StatefulWidget {
  NoticeViewPage(this.noticeNo, {Key? key}) : super(key: key);
  final int noticeNo;

  @override
  State<NoticeViewPage> createState() => _NoticeViewPageState();
}

class _NoticeViewPageState extends State<NoticeViewPage> {
  late NoticeViewModel provider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.loadPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => NoticeViewModel(widget.noticeNo))
        ],
        child: Consumer<NoticeViewModel> (
          builder: (context, noticeModel, _) {
            provider = noticeModel;
            return Stack(
              children: <Widget>[
                Scaffold(
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                        title: Text('공지사항 상세보기')
                    ),
                    body: provider.loading?Loading():_buildBody(context)
                ),
              ],
            );
          },
        )
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 30, 16, 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
              decoration: BoxDecoration(
                color: hexColor('F3F3F3'),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(createdAtDateOrTimeChat(provider.detail.createdAt!), style: CStyle.p12_7_6),

            ),
            SizedBox(height: 14),
            Text(provider.detail.title!, style: CStyle.p16_7_3),
            SizedBox(height: 26),
            Text(provider.detail.content!, style: CStyle.p14_3_6_16),
            SizedBox(height: 16),
            //링크가 있으면 링크를 건다.
            Visibility(
              visible: provider.detail.url==''?false:true,
              child: InkWell(
                onTap: () {
                  launchUrl(Uri.parse(provider.detail.url!));
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width-32,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: CStyle.colorPri,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text('링크 열기', style: CStyle.p14_7_white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
