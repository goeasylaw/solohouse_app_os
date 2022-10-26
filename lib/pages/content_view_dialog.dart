import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:url_launcher/url_launcher.dart';

import '../_common/c_style.dart';
import '../_common/util.dart';
import '../_model/solohouse_model.dart';
import '../_model/solohouse_repository.dart';

class ContentViewDialog extends StatefulWidget {
  const ContentViewDialog({Key? key, required this.contentNo}) : super(key: key);
  final int contentNo;

  @override
  State<ContentViewDialog> createState() => _ContentViewDialogState();
}

class _ContentViewDialogState extends State<ContentViewDialog> {

  SolohouseModel? data;
  SolohouseRepository repository = SolohouseRepository();
  @override
  void initState() {
    super.initState();

    repository.addListener(repositoryListener);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      data = await repository.getOne(widget.contentNo);
      setState(() {
      });
    });
  }

  void repositoryListener() {
    setState(() {
    });
  }


  @override
  void dispose() {
    repository.removeListener(repositoryListener);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: hexColor('312A28'),
      padding: EdgeInsets.all(20),
      child: _body()
    );
  }

  Widget _body() {
    return data==null?Container():Column(
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
      ],
    );
  }

  Widget _head() {
    List<String> tags = [];
    if(data!.keyword!.isNotEmpty) {
      tags = data!.keyword!.split(',');
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data!.title!, style: CStyle.p18_7_white),
          SizedBox(height: 30),
          Visibility(
            visible: tags.isNotEmpty,
            child: Tags(
                itemCount: tags.length,
                spacing: 12,
                runSpacing: 4,
                alignment: WrapAlignment.start,
                itemBuilder: (int index) {
                  return Container(
                    padding: EdgeInsets.all(1),
                    child: Text('#${tags[index]}', style: CStyle.p14_5_B),
                  );
                }
            ),
          ),
        ],
      ),
    );
  }

  Widget _content() {
    List<Widget> solostay = [];
    if(data!.category == '솔로스테이') {
      solostay.add(
          InkWell(
            onTap: () {
              String link = data!.magazine!.replaceAll('[{"link","', '').replaceAll('"}]', '');
              launchUrl(Uri.parse(link));
              //launchUrl(Uri.parse());
            },
            child: Center(
              child: Container(
                margin: EdgeInsets.only(bottom: 20, top: 20),
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                width: 120,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: CStyle.colorPri,
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Text('예약하러 가기', style: CStyle.p14_7_white),
              ),
            ),
          )
      );
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: MediaQuery.of(context).size.width),
          Text(data!.message!, style: CStyle.p14_3_white_16),
          ...solostay
        ],
      ),
    );
  }
}
