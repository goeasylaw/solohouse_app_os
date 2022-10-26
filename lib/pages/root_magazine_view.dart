import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:solohouse/pages/reply_page.dart';
import 'package:solohouse/pages/root_magazine_cell.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';

import '../_model/magazine_repository.dart';
import '../_model/solohouse_model.dart';

class RootMagazineView extends StatefulWidget {
  const RootMagazineView({Key? key}) : super(key: key);

  @override
  State<RootMagazineView> createState() => _RootMagazineViewState();
}

class _RootMagazineViewState extends State<RootMagazineView> {

  MagazineRepository repository = MagazineRepository();

  final Controller controller = Controller();

  bool loaded = false;

  void _handleCallbackEvent(ScrollDirection direction, ScrollSuccess success, {int? currentIndex}) {
    print("Scroll callback received with data: {direction: $direction, success: $success and index: ${currentIndex ?? 'not given'}}");
  }


  @override
  void initState() {
    print('RootMagazineView initState');
    super.initState();
    controller.addListener((event) {
      if(repository.list.length-1 == event.pageNo) {
        if(repository.nextPage) {
          repository.load();
        }
      }
    });

    repository.addListener(() {
      setState(() {
      });
    });


    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      repository.load().then((value) {
        setState(() {
          loaded = true;
        });
      });
    });

  }

  @override
  void dispose() {
    //controller.disposeListeners();
    super.dispose();
  }

  Future<void> _onRefresh() async{
    //provider.reload();
  }


  @override
  Widget build(BuildContext context) {

    print(repository.list.length);

    return loaded==false?Container():TikTokStyleFullPageScroller(
      contentSize: repository.list.length,
      swipePositionThreshold: 0.2,
      swipeVelocityThreshold: 2000,
      animationDuration: const Duration(milliseconds: 400),
      controller: controller,
      builder: (BuildContext context, int index) {
        SolohouseModel data = repository.list[index];
        return RootMagazineCell(
          data: data,
          onClickReply: () {
            showBarModalBottomSheet(
              context: context,
              bounce: false,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)
              ),
              backgroundColor: Colors.white,
              barrierColor: Colors.black45,
              elevation: 0,
              builder: (context) => ReplyPage(contentNo: data.contentNo!),
            );

          },
          onClickShare: () {

          },
          onClickSave: () {
            print('onClickSave');
            repository.scrap(data.myScrap==0, data.contentNo!).then((value) {
              setState(() {
              });
            });
          },
          onClickLike: () {
            repository.like(data.myLike==0, data.contentNo!).then((value) {
              setState(() {

              });
            });
          },
        );
      },
    );
  }
}
