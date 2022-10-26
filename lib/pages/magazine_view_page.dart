import 'package:flutter/material.dart';

import 'magazine_view.dart';

class MagazineViewPage extends StatefulWidget {
  const MagazineViewPage({Key? key, required this.contentNo}) : super(key: key);
  final int contentNo;
  @override
  State<MagazineViewPage> createState() => _MagazineViewPageState();
}

class _MagazineViewPageState extends State<MagazineViewPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('매거진 보기'),
      ),
      body: MagazineView(contentNo: widget.contentNo),
    );
  }
}
