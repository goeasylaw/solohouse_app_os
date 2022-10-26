import 'package:flutter/material.dart';

import 'magazine_view.dart';

class MagazineViewDialog extends StatefulWidget {
  const MagazineViewDialog({Key? key, required this.contentNo}) : super(key: key);
  final int contentNo;
  @override
  State<MagazineViewDialog> createState() => _MagazineViewDialogState();
}

class _MagazineViewDialogState extends State<MagazineViewDialog> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        MagazineView(contentNo: widget.contentNo),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: 48,
            height: 48,
            margin: EdgeInsets.only(right: 24, bottom: 24),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(24)
            ),
            child: Icon(Icons.close, size: 32, color: Colors.white),
          ),
        )
      ],
    );
  }

}
