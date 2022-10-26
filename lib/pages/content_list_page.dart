import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:solohouse/_common/util.dart';
import 'package:solohouse/pages/content_list_cell.dart';
import 'package:solohouse/pages/content_search_list_page.dart';
import 'package:solohouse/pages/magazine_view_page.dart';

import '../_common/c_style.dart';
import '../_model/content_repository.dart';
import '../_model/solohouse_model.dart';
import '../app_config.dart';
import 'content_view_page.dart';
import 'magazine_view_dialog.dart';

class ContentListPage extends StatefulWidget {
  const ContentListPage({Key? key}) : super(key: key);

  @override
  State<ContentListPage> createState() => _ContentListPageState();
}

class _ContentListPageState extends State<ContentListPage> {
  int currentTab = 0;
  ContentRepository repository = ContentRepository();
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    currentTab = AppConfig().solohouseCategories.indexOf(repository.category);

    repository.addListener(repositoryListener);

    if(repository.list.isEmpty) {
      repository.loadCategory(AppConfig().solohouseCategories[currentTab]);
    }

  }

  void repositoryListener() {
    setState((){});
  }

  @override
  void dispose() {
    repository.removeListener(repositoryListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 126,
        leadingWidth: 0,
        leading: SizedBox(width: 0, height: 0),
        automaticallyImplyLeading: false,
        elevation: 3,
        title: Column(
          children: [
            Container(
              height: 66,
              alignment: Alignment.center,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 16, top: 8, bottom: 8),
                      child: Icon(Icons.chevron_left, size: 24, color: hexColor('999999'))
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 32,
                      decoration: BoxDecoration(
                        color: hexColor('F9F9F9'),
                        borderRadius: BorderRadius.circular(16)
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onSubmitted: (text) {
                                if(text.isEmpty) {
                                  SmartDialog.showToast('검색어가 비었습니다.', displayType: SmartToastType.first);
                                  return;
                                }


                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ContentSearchListPage(searchText: text)),
                                ).then((value) {
                                  if(value == 'REFRESH') {
                                    repository.initData();
                                    repository.loadCategory(AppConfig().solohouseCategories[currentTab]);
                                  }
                                });
                              },
                              controller: textEditingController,
                              decoration: InputDecoration(
                                fillColor: Colors.green,
                                focusColor: Colors.green,
                                contentPadding: EdgeInsets.only(left: 16, bottom: 15),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: '검색어를 입력하세요.(#식물, 인테리어)',
                                hintStyle: CStyle.p14_5_B
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if(textEditingController.text.isEmpty) {
                                SmartDialog.showToast('검색어가 비었습니다.', displayType: SmartToastType.first);
                                return;
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ContentSearchListPage(searchText: textEditingController.text)),
                              ).then((value) {
                                if(value == 'REFRESH') {
                                  repository.initData();
                                  repository.loadCategory(AppConfig().solohouseCategories[currentTab]);
                                }
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Icon(Icons.search, size: 24, color: Colors.black)
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _categoryCell('전체', 0, currentTab==0),
                    _categoryCell('매거진', 1, currentTab==1),
                    _categoryCell('솔로하우스', 2, currentTab==2),
                    _categoryCell('솔로스테이', 3, currentTab==3),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SafeArea(
        child: Column(
          children: [
            //_categoryList(),
            Expanded(
                child: _grid()
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

          //마지막 페이지 인가?
          if(repository.nextPage) {
            if ((index + 1) == repository.list.length) {
              repository.loadCategory(AppConfig().solohouseCategories[currentTab]);
            }
          }

          return InkWell(
              onTap: () {

                if(data.category=='매거진') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MagazineViewPage(contentNo: data.contentNo!)),
                  ).then((value) {
                    if(value == 'REFRESH') {
                      repository.initData();
                      repository.loadCategory(AppConfig().solohouseCategories[currentTab]);
                    }
                  });
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContentViewPage(contentNo: data.contentNo!)),
                  ).then((value) {
                    if(value == 'REFRESH') {
                      repository.initData();
                      repository.loadCategory(AppConfig().solohouseCategories[currentTab]);
                    }
                  });
                }

                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => SolohouseViewPage(contentNo: data.contentNo!)),
                // ).then((value) {
                //   if(value == 'REFRESH') {
                //     repository.initData();
                //     repository.loadCategory(AppConfig().solohouseCategories[currentTab]);
                //   }
                // });
              },
              child: ContentListCell(data: data)
          );
        },

    );
  }

  Widget _categoryList() {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

        ],
      ),
    );
  }

  Widget _categoryCell(String category, int index, bool isSelect) {
    return InkWell(
      onTap: () {
        setState(() {
          currentTab = index;
        });

        repository.initData();
        repository.loadCategory(category=='전체'?'':category);
      },
      child: Container(
        height: 32,
        padding: EdgeInsets.only(left: 16, right: 16),
        margin: EdgeInsets.only(right: 6),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: currentTab==index?hexColor('FF9473'):hexColor('F9F9F9'),
            borderRadius: BorderRadius.circular(16)
        ),
        child: Text(category, style: currentTab==index?CStyle.p14_7_white:CStyle.p14_7_6),
      ),
    );
  }


}
