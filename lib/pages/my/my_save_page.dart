import 'package:flutter/material.dart';

import '../../_common/c_style.dart';
import '../../_common/util.dart';
import '../../_model/my_content_repository.dart';
import '../../_model/solohouse_model.dart';
import '../../app_config.dart';
import '../content_list_cell.dart';
import '../content_view_page.dart';
import '../magazine_view_page.dart';

class MySavePage extends StatefulWidget {
  const MySavePage({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  State<MySavePage> createState() => _MySavePageState();
}

class _MySavePageState extends State<MySavePage> {
  int currentTab = 0;
  late MyContentRepository repository;
  String mode = 'my';

  @override
  void initState() {
    super.initState();
    currentTab = widget.index;
    repository = MyContentRepository();
    repository.addListener(repositoryListener);

    currentTab = widget.index;
    if(currentTab == 0) {
      mode = 'my';
    } else if(currentTab == 1) {
      mode = 'scrap';
    } else if(currentTab == 2) {
      mode = 'like';
    } else if(currentTab == 3) {
      mode = 'reply';
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //카테고리 목록을 가져온다.
      repository.initData(mode);
      repository.load();
    });
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
        title: Text('보관함'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: Column(
        children: [
          _categoryList(),
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
        return InkWell(
            onTap: () {

              if(data.category=='매거진') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MagazineViewPage(contentNo: data.contentNo!)),
                ).then((value) {
                  if(value == "REFRESH") {
                    repository.initData(mode);
                    repository.load();
                  }
                });
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContentViewPage(contentNo: data.contentNo!)),
                ).then((value) {
                  if(value == "REFRESH") {
                    repository.initData(mode);
                    repository.load();
                  }
                });
              }
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
          _categoryCell('내가쓴글', 0, currentTab==0),
          _categoryCell('스크랩', 1, currentTab==1),
          _categoryCell('좋아요', 2, currentTab==2),
          _categoryCell('댓글단 글', 3, currentTab==3),
        ],
      ),
    );
  }

  Widget _categoryCell(String category, int index, bool isSelect) {
    return InkWell(
      onTap: () {
        setState(() {
          currentTab = index;
          if(currentTab == 0) {
            mode = 'my';
            repository.initData(mode);
            repository.load();
          } else if(currentTab == 1) {
            mode = 'scrap';
            repository.initData(mode);
            repository.load();
          } else if(currentTab == 2) {
            mode = 'like';
            repository.initData(mode);
            repository.load();
          } else if(currentTab == 3) {
            mode = 'reply';
            repository.initData(mode);
            repository.load();
          }
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 3,
          ),
          Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text(category, style: isSelect?CStyle.p15_7_pri:CStyle.p15_4_7),
              )
          ),
          Container(
            width: MediaQuery.of(context).size.width/4,
            height: 3,
            color: isSelect?CStyle.colorPri:Colors.transparent,
          )
        ],
      ),
    );
  }
}
