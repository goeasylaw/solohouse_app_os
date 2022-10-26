import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solohouse/_common/c_style.dart';
import 'package:solohouse/_common/util.dart';
import 'package:solohouse/pages/my/notice_view_page.dart';

import '../../_model/notice_api.dart';
import '../../_model/notice_model.dart';


class NoticeListPage extends StatefulWidget {
  const NoticeListPage({Key? key}) : super(key: key);

  @override
  State<NoticeListPage> createState() => _NoticeListPageState();
}

class _NoticeListPageState extends State<NoticeListPage> {
  late NoticeApi provider;

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
          ChangeNotifierProvider(create: (_) => NoticeApi())
        ],
        child: Consumer<NoticeApi> (
          builder: (context, noticeModel, _) {
            provider = noticeModel;
            return Stack(
              children: <Widget>[
                Scaffold(
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                      title: Text('공지사항')
                    ),
                    body: _buildList(context)
                ),
              ],
            );
          },
        )
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView.separated(
        padding: EdgeInsets.zero,
        separatorBuilder: (context, index) => Divider(
          color: hexColor('F3F3F3'),
          height: 1,
          thickness: 1,
        ),
        itemCount: provider.list.length,
        itemBuilder: (BuildContext _context, int i) {
          if(provider.nextpage) {
            if ((i + 1) == provider.list.length) {
              provider.loadNextPage();
            }
          }
          return _buildCell(provider.list[i]);
        }
    );
  }

  Widget _buildCell(NoticeListItem item) {
    DateTime parsedDate = DateTime.parse(item.createdAt!);
    DateTime now = DateTime.now();
    bool isNew = false;
    String dateStr = '${parsedDate.year}.${parsedDate.month}.${parsedDate.day}';
    if(now.year==parsedDate.year && now.month==parsedDate.month && now.day==parsedDate.day) {
      isNew = true;
    }

    return InkWell(
        onTap: () {
          //상세보기로 이동한다.
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NoticeViewPage(item.noticeNo!)),
          );
          //Navigator.pushNamed(context, MainRoutes.notice_view + '?noticeNo=${item.noticeNo}');
        },
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Visibility(
                  visible: isNew,
                  child: Text('NEW', style: CStyle.p10_7_pri)
              ),
              Text(item.title!, style: CStyle.p14_7_4),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
                decoration: BoxDecoration(
                  color: hexColor('F3F3F3'),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(dateStr, style: CStyle.p12_7_6),
              ),
            ],
          ),
        )
    );
  }
}
