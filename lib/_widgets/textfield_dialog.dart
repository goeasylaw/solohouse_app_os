
import 'package:flutter/material.dart';
import 'package:solohouse/_common/c_style.dart';
import 'package:solohouse/_common/util.dart';
class TextFieldDialog extends StatefulWidget {
  TextFieldDialog({Key? key, required this.text, this.hintText, this.length = 20}) : super(key: key);
  final String text;
  final String? hintText;
  final int length;

  @override
  State<TextFieldDialog> createState() => _TextFieldDialogState();
}

class _TextFieldDialogState extends State<TextFieldDialog> {
  final TextEditingController _contentTextController = TextEditingController();

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _contentTextController.text = widget.text;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(0),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
          )),
          Container(
            padding: EdgeInsets.only(left: 8, right: 8),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.pop(context, _contentTextController.text);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 16, right: 16),
                    height: 40,
                    child: Text('완료', style: CStyle.p14_7_pri),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: hexColor('E5E5E5'),
          ),
          Container(
              padding: EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: SizedBox(
                height: 60,
                child: TextField(
                  scrollPadding: EdgeInsets.all(0),
                  controller: _contentTextController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 1,
                  maxLength: widget.length,
                  autofocus: true,
                  style: CStyle.p14_5_4,
                  decoration: InputDecoration(
                    hintText: widget.hintText ?? "내용을 입력하세요.",
                    hintStyle: CStyle.p14_5_B,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding:
                    EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 0),
                  ),
                ),
              )
          )
        ],
      ),
    );
  }
}
