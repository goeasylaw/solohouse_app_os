// import 'package:flutter/material.dart';
// import 'package:solohouse/_common/c_style.dart';
// import 'package:solohouse/_common/util.dart';
// import 'package:solohouse/pages/magazine_view_page.dart';
//
// class MagazinePage extends StatefulWidget {
//   const MagazinePage({Key? key}) : super(key: key);
//
//   @override
//   State<MagazinePage> createState() => _MagazinePageState();
// }
//
// class _MagazinePageState extends State<MagazinePage> {
//   int currentTab = 0;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Row(
//           children: [
//             Image.asset('assets/images/tab_icon_magazine_off.png', width: 24, height: 24),
//             SizedBox(width: 8),
//             Text('매거진', style: CStyle.appbarTitle),
//           ],
//         ),
//         actions: [
//           IconButton(
//               onPressed: () {
//               },
//               icon: Image.asset('assets/images/icon_search.png', width: 24, height: 24)
//           )
//         ],
//       ),
//       body: _buildBody(),
//     );
//   }
//
//   Widget _buildBody() {
//     return SafeArea(
//       child: Column(
//         children: [
//           _categoryList(),
//           Expanded(
//             child: ListView.separated (
//               itemCount: 5,
//               itemBuilder: (BuildContext context, int index) {
//                 return InkWell(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => MagazineViewPage()),
//                     );
//                   },
//                   child: magazineCell()
//                 );
//               },
//               separatorBuilder: (BuildContext context, int index) {
//                 return Divider(height: 1, thickness: 1, color: hexColor('F3F3F3'));
//               },
//             )
//           )
//         ],
//       )
//     );
//   }
//
//   Widget _categoryList() {
//     return SizedBox(
//       height: 50,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           _categoryCell('전체', 0, currentTab==0),
//           _categoryCell('다큐', 1, currentTab==1),
//           _categoryCell('로컬', 2, currentTab==2),
//           _categoryCell('피플', 3, currentTab==3),
//           _categoryCell('VR', 4, currentTab==4),
//           _categoryCell('인터뷰', 5, currentTab==5),
//         ],
//       ),
//     );
//   }
//
//   Widget _categoryCell(String category, int index, bool isSelect) {
//     return InkWell(
//       onTap: () {
//         setState(() {
//           currentTab = index;
//         });
//       },
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//             height: 3,
//           ),
//           Expanded(
//             child: Container(
//               alignment: Alignment.center,
//               child: Text(category, style: isSelect?CStyle.p15_7_pri:CStyle.p15_4_7),
//             )
//           ),
//           Container(
//             width: MediaQuery.of(context).size.width/6,
//             height: 3,
//             color: isSelect?CStyle.colorPri:Colors.transparent,
//           )
//         ],
//       ),
//     );
//   }
//
//
//   Widget magazineCell() {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(16, 34, 16, 40),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Stack(
//             alignment: Alignment.bottomRight,
//             children: [
//               Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: MediaQuery.of(context).size.width * 0.5625,
//                 decoration: BoxDecoration(
//                   color: Colors.green,
//                   borderRadius: BorderRadius.circular(6)
//                 ),
//               ),
//               Padding(
//                   padding: EdgeInsets.only(right: 6, bottom: 6),
//                   child: Image.asset('assets/images/icon_play.png', width: 50, height: 50)
//               ),
//             ],
//           ),
//           SizedBox(height: 20),
//           Text('서울역 인근 도보 5분거리 옥탑방 요즘 다들 거리두기를 하니까 혼자 즐길수 있는 여러 공간들을 모아봤어요', style: CStyle.p14_5_4),
//           SizedBox(height: 20),
//           Text('22.02.01 10:23', style: CStyle.p12_4_6)
//
//         ],
//       ),
//     );
//   }
// }