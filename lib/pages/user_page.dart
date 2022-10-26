import 'package:flutter/material.dart';
import 'package:solohouse/pages/report_dialog.dart';

import '../_common/c_style.dart';
import '../_common/user_model.dart';
import '../_common/util.dart';
import '../_model/solohouse_model.dart';
import '../_model/user_repository.dart';
import 'content_list_cell.dart';
import 'content_view_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key, required this.userInfo}) : super(key: key);

  final UserInfo userInfo;

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late UserRepository repository;

  bool loaded = false;

  @override
  void initState() {
    super.initState();
    repository = UserRepository(userNo: widget.userInfo.userNo!);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      repository.load().then((value) {
        setState(() {
          loaded = true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/tab_icon_my_off.png', width: 24, height: 24),
            SizedBox(width: 8),
            Text(widget.userInfo.userName!, style: CStyle.appbarTitle),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => ReportDialog('user', widget.userInfo.userNo!)
              ).then((value) {
                if(value == 'REFRESH') {
                  Navigator.pop(context);
                }
              });
            },
            child: Text('신고하기')
          )
        ],
      ),
      body: _buildBody() ,
    );
  }

  Widget _buildBody() {
    double backgroundHeight = MediaQuery.of(context).size.width * 0.5625;
    return SafeArea(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: backgroundHeight,
            color: Colors.green,
            alignment: Alignment.topCenter,
            child: Stack(
              alignment: Alignment.center,
              children: [
                widget.userInfo.backgroundUrl==''?
                Image.asset('assets/images/my_default.png', width: MediaQuery.of(context).size.width, height: backgroundHeight, fit: BoxFit.fitWidth)
                    :Image.network(widget.userInfo.backgroundUrl!, width: MediaQuery.of(context).size.width, height: backgroundHeight, fit: BoxFit.fitWidth),
                widget.userInfo.middlePhotoUrl==''?
                Icon(Icons.person, size: 86, color: Colors.white)
                    :ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(widget.userInfo.middlePhotoUrl!, width: 100, height: 100, fit: BoxFit.fill)
                )
              ],
            )
          ),
          SizedBox(height: 2),
          Expanded(
            child: loaded==false?Center(child: CircularProgressIndicator()):_grid()
          )
        ],
      )
    );
  }

  Widget _grid() {
    return ListView.separated (
      itemCount: repository.list.length,
      padding: EdgeInsets.zero,
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: 2,
          thickness: 2,
          color: hexColor('FAFAFA'),
        );
      },
      itemBuilder: (BuildContext context, int index) {
        SolohouseModel data = repository.list[index];
        return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContentViewPage(contentNo: data.contentNo!)),
              ).then((value) {

              });
            },
            child: ContentListCell(data: data)
        );
      },

    );
  }
}
