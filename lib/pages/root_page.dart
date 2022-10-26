import 'package:flutter/material.dart';
import 'package:solohouse/_common/c_style.dart';
import 'package:solohouse/_common/user_model.dart';
import 'package:solohouse/_common/util.dart';
import 'package:solohouse/pages/content_list_page.dart';
import 'package:solohouse/pages/my/my_page.dart';
import 'package:solohouse/pages/root_magazine_view.dart';
import 'package:solohouse/pages/root_solohouse_view.dart';

import '../_model/magazine_repository.dart';
import '../_model/solohouse_repository.dart';
import '../_widgets/common_widgets.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final PageController pageController = PageController();
  int selectTap = 0;

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: hexColor('312A28'),
      ),
      backgroundColor: hexColor('312A28'),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        PageView(
          controller: pageController,
          physics:const NeverScrollableScrollPhysics(),
          children: [
            RootMagazineView(),
            RootSoloHouseView(),
          ],
        ),
        // Visibility(
        //   visible: selectTap==0,
        //   child: RootMagazineView()
        // ),
        // Visibility(
        //     visible: selectTap!=0,
        //     child: RootSoloHouseView(),
        // ),
        // Visibility(
        //   visible: selectTap==1,
        //   child: RootSoloHouseView()
        // ),
        // Visibility(
        //   visible: selectTap==0,
        //   child: RootMagazineView()
        // ),
        //상단에 고정 앱바 (메뉴 매거진/솔로하우스 My)
        Container(
          height: 66,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black38,
                  Colors.transparent,
                ],
              )
          ),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ContentListPage()),
                    );
                  },
                  icon: Icon(Icons.menu, size: 24, color: Colors.white)
              ),
              Expanded(child: SizedBox()),
              InkWell(
                  onTap: () {
                    if(selectTap != 0) {
                      MagazineRepository().initData();
                      setState(() {
                        selectTap = 0;
                      });

                      pageController.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
                    }
                  },
                  child: Container(
                    width: 70,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selectTap==0?Colors.white10:Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.white24,
                          width: 0.5
                      )
                    ),
                    child: Text('매거진', style: selectTap==0?CStyle.p12_7_white:CStyle.p12_3_a)
                  )
              ),
              SizedBox(width: 4),
              InkWell(
                  onTap: () {
                    if(selectTap != 1) {
                      SolohouseRepository().initData();
                      setState(() {
                        selectTap = 1;
                      });
                      pageController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
                    }
                  },
                  child: Container(
                    width: 70,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selectTap==1?Colors.white10:Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white24,
                        width: 0.5
                      )
                    ),
                    child: Text('솔로하우스', style: selectTap==1?CStyle.p12_7_white:CStyle.p12_3_a)
                  )
              ),
              Expanded(child: SizedBox()),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyPage()),
                    );
                  },
                  icon: userIcon()
              ),
            ],
          ),
        ),
        //매거진 목록
        //솔로하우스 목록
      ],
    );
  }

  Widget userIcon() {
    if(UserModel().isLogin) {
      return imageProfileSmall(UserModel().myInformation!.userInfo!.smallPhotoUrl!);
    } else {
      return Container(
        width: 24,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12)
        ),
        child: Text('MY', style: CStyle.p12_7_6),
      );
    }

  }

}
