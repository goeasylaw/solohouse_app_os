import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_tags_x/flutter_tags_x.dart';

import '../_common/c_style.dart';
import '../_model/magazine_repository.dart';
import '../_model/solohouse_model.dart';

class MagazineView extends StatefulWidget {
  const MagazineView({Key? key, required this.contentNo}) : super(key: key);
  final int contentNo;
  @override
  State<MagazineView> createState() => _MagazineViewState();
}

class _MagazineViewState extends State<MagazineView> {
  SolohouseModel? data;
  MagazineRepository repository = MagazineRepository();
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
        color: Colors.white,
        padding: EdgeInsets.all(20),
        child: _body()
    );
  }

  Widget _body() {
    return data==null?Center(child: CircularProgressIndicator()):Column(
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
        // ViewBottom(
        //   isSave: data!.myScrap==1,
        //   isLike: data!.myLike==1,
        //   saveCount: data!.scrapCount!,
        //   likeCount: data!.likeCount!,
        //   replyCount: data!.replyCount!,
        //   onClickSave: () {
        //     repository.scrap(data!.myScrap==0, data!.contentNo!);
        //   },
        //   onClickLike: () {
        //     repository.like(data!.myLike==0, data!.contentNo!);
        //   },
        //   onClickReply: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => ReplyPage(contentNo: data!.contentNo!)),
        //     );
        //   },
        //   onClickShare: () {
        //
        //   },
        // )
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
          Text(data!.title!, style: CStyle.p18_7_3),
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
                    child: Text('#${tags[index]}', style: CStyle.p14_5_4),
                  );
                }
            ),
          ),
        ],
      ),
    );
  }

  Widget _content() {
    final doc = Document.fromJson(jsonDecode(data!.magazine!));
    QuillController controller = QuillController(document: doc, selection: const TextSelection.collapsed(offset: 0));

    return Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: QuillEditor(
          controller: controller,
          scrollController: ScrollController(),
          scrollable: true,
          focusNode: FocusNode(),
          autoFocus: false,
          readOnly: true,
          expands: false,
          padding: EdgeInsets.zero,
        )
    );
  }
}
