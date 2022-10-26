import 'package:flutter/material.dart';
import 'package:solohouse/_common/c_style.dart';
import 'package:solohouse/_model/solohouse_model.dart';

import '../_common/util.dart';
import '../_model/search_repository.dart';
import 'content_list_cell.dart';
import 'content_view_page.dart';
import 'magazine_view_page.dart';

class ContentSearchListPage extends StatefulWidget {
  const ContentSearchListPage({Key? key, required this.searchText}) : super(key: key);
  final String searchText;

  @override
  State<ContentSearchListPage> createState() => _ContentSearchListPageState();
}

class _ContentSearchListPageState extends State<ContentSearchListPage> {
  late SearchRepository repository;

  @override
  void initState() {
    super.initState();

    repository = SearchRepository(widget.searchText);
    repository.addListener(repositoryListener);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
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
        title: Text(widget.searchText, style: CStyle.appbarTitle),
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
        return InkWell(
            onTap: () {

              if(data.category=='매거진') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MagazineViewPage(contentNo: data.contentNo!)),
                ).then((value) {

                });
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContentViewPage(contentNo: data.contentNo!)),
                ).then((value) {

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
}
