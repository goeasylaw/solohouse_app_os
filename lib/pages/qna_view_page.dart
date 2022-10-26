import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:solohouse/pages/reply_page.dart';

import '../_common/c_style.dart';
import '../_common/util.dart';
import '../_widgets/view_bottom.dart';

class QnaViewPage extends StatefulWidget {
  const QnaViewPage({Key? key}) : super(key: key);

  @override
  State<QnaViewPage> createState() => _QnaViewPageState();
}

class _QnaViewPageState extends State<QnaViewPage> {
  List<String> tags = [
    '화이트인테리어',
    '우드',
    '내추럴',
    '조명',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10)
              ),
            ),
            SizedBox(width: 6),
            Text('UserName', style: CStyle.p12_5_3),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {

              },
              icon: Icon(Icons.more_vert)
          )
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return SafeArea(
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _head(),
                      _content()
                    ],
                  ),
                )
            ),
            ViewBottom(
              isSave: true,
              isLike: true,
              saveCount: 1,
              likeCount: 2,
              replyCount: 3,
              onClickSave: () {

              },
              onClickLike: () {

              },
              onClickReply: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReplyPage(contentNo: 1,)),
                );
              },
              onClickShare: () {

              },
            )
          ],
        )
    );
  }

  Widget _head() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 50, 16, 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //켄텐츠가 나온다
          Row(
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
                child: Text('질문답변', style: CStyle.p10_5_9),
              ),
              SizedBox(width: 6),
              Text('22.09.12', style: CStyle.p12_3_9,)

            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text('Q', style: CStyle.p18_7_sec),
              SizedBox(width: 4),
              Expanded(
                  child: Text('Diy 아크릴 무드등 어디에서 사야 하나요?', maxLines: 1, overflow: TextOverflow.ellipsis, style: CStyle.p16_7_3)
              )
            ],
          ),
          SizedBox(height: 40),
          Tags(
              itemCount: tags.length,
              spacing: 12,
              runSpacing: 4,
              alignment: WrapAlignment.start,
              itemBuilder: (int index) {
                return Container(
                  padding: EdgeInsets.all(1),
                  child: Text('#${tags[index]}', style: CStyle.p14_3_pri),
                );
              }
          ),
        ],
      ),
    );
  }

  Widget _content() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('아크릴 무드등을 만들어 보고 싶은데 다이소에 없으면 인터넷으로 사려고 하는데 다이소에 diy 아크릴 무드등을 만들어 보고 싶은데 다이소에 없으면 인터넷으로 사려고 하는데 다이소에 diy', style: CStyle.p16_3_6_16),
          SizedBox(height: 40),
          Container(
            height: 200,
            color: Colors.green,
          )
        ],
      ),
    );
  }
}
