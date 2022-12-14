// import 'package:flutter/material.dart';
// import 'package:solohouse/_common/c_style.dart';
// import 'package:solohouse/_common/util.dart';
// import 'package:solohouse/pages/qna_view_page.dart';
// import 'package:solohouse/pages/solohouse_view_page.dart';
// import 'package:solohouse/pages/solostay_view_page.dart';
//
// import 'magazine_view_page.dart';
//
//
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   final ScrollController scrollController = ScrollController();
//
//   bool showAppbarLogo = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     scrollController.addListener(listenerScroll);
//   }
//
//   void listenerScroll() {
//     if(scrollController.offset > 0) {
//       if(!showAppbarLogo) {
//         setState(() {
//           showAppbarLogo = true;
//         });
//       }
//
//     } else {
//       if(showAppbarLogo) {
//         setState(() {
//           showAppbarLogo = false;
//         });
//       }
//     }
//   }
//
//
//   @override
//   void dispose() {
//     scrollController.removeListener(listenerScroll);
//
//     super.dispose();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: showAppbarLogo?3:0,
//         title: Row(
//           children: [
//             Visibility(
//               visible: showAppbarLogo,
//               child: Image.asset('assets/images/logo.png', width: 70, height: 20)
//             ),
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
//       body: _buildBody()
//     );
//   }
//
//   Widget _buildBody() {
//     return SafeArea(
//         child: SingleChildScrollView(
//           controller: scrollController,
//           child: Column(
//             children: [
//               Image.asset('assets/images/home_title.png', width: MediaQuery.of(context).size.width, fit: BoxFit.fitWidth),
//               Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: 46,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     fit: BoxFit.fill,
//                     image: AssetImage('assets/images/home_titie_bg.png')
//                   )
//                 ),
//                 child: Container(
//                   width: MediaQuery.of(context).size.width,
//                   height: 46,
//                   decoration: BoxDecoration(
//                     color: CStyle.colorPri,
//                     borderRadius: BorderRadius.only(topLeft: Radius.circular(46))
//                   ),
//                 ),
//               ),
//               //????????? ?????????
//               Container(
//                 color: CStyle.colorPri,
//                 alignment: Alignment.topLeft,
//                 padding: EdgeInsets.only(left: 16, right: 16, bottom: 50),
//                 width: MediaQuery.of(context).size.width,
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Text('????????? ?????????', style: CStyle.p18_7_white),
//                         Icon(Icons.keyboard_arrow_right, size: 24, color: Colors.white)
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     InkWell(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => MagazineViewPage()),
//                         );
//                       },
//                       child: _magazineCell()
//                     ),
//                     SizedBox(height: 20),
//                     InkWell(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => MagazineViewPage()),
//                         );
//                       },
//                       child: _magazineCell()
//                     ),
//                     SizedBox(height: 20),
//                     InkWell(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => MagazineViewPage()),
//                         );
//                       },
//                       child: _magazineCell()
//                     ),
//
//                   ],
//                 ),
//               ),
//               //?????????
//               InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => MagazineViewPage()),
//                   );
//                 },
//                 child: _interview()
//               ),
//               SizedBox(height: 30),
//               _themeList(
//                 title: '???? ????????? ?????????,',
//                 subTitle: '???????????? ????????????'
//               ),
//               _themeList(
//                   title: '???? ???????????? ??????! ',
//                   subTitle: '??????????????????'
//               ),
//               _themeList(
//                   title: '???? ????????? ?????????! ',
//                   subTitle: '????????????'
//               ),
//               _themeList(
//                   title: '???? ????????????, ',
//                   subTitle: 'DIY/??????????????????'
//               ),
//               SizedBox(height: 30),
//               Divider(
//                 height: 8,
//                 thickness: 8,
//                 color: hexColor('F9F9F9'),
//               ),
//               SizedBox(height: 30),
//               _solostayList(),
//               SizedBox(height: 30),
//               Divider(
//                 height: 8,
//                 thickness: 8,
//                 color: hexColor('F9F9F9'),
//               ),
//               SizedBox(height: 30),
//               _qnaList(),
//               SizedBox(height: 30),
//               //????????? ??????
//               Text('??? ???????????? ??????????????????????????? ????????? ?????? ?????????????????????.', style: CStyle.p12_5_3),
//               SizedBox(height: 20),
//
//             ],
//           ),
//         )
//     );
//   }
//
//
//   Widget _magazineCell() {
//     return Row(
//       children: [
//         Container(
//           width: 160,
//           height: 89,
//           decoration: BoxDecoration(
//             color: Colors.green,
//             borderRadius: BorderRadius.all(Radius.circular(6))
//           ),
//         ),
//         SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.fromLTRB(4, 2, 4,2),
//                     child: Text('??????', style: CStyle.p10_5_white),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(6)),
//                       border: Border.all(
//                         color: Colors.white,
//                         width: 1
//                       )
//                     ),
//                   ),
//                   SizedBox(width: 8),
//                   Text('2022.05.10', style: CStyle.p12_3_white)
//                 ],
//               ),
//               SizedBox(height: 12),
//               Text('????????? ?????? ????????? ?????? ??????????_??? ?????? ??? 1???_4KUHD', maxLines: 3, style: CStyle.p14_7_white,)
//             ],
//           ),
//         )
//       ],
//     );
//   }
//
//   Widget _interview() {
//     double cellWidth = (MediaQuery.of(context).size.width - 16 - 20 - 20) / 2;
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       alignment: Alignment.topLeft,
//       padding: EdgeInsets.fromLTRB(0, 50, 0, 60),
//       color: hexColor('F9F9F9'),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.only(left: 16),
//             child: Container(
//               padding: EdgeInsets.fromLTRB(4, 2, 4,2),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.all(Radius.circular(6)),
//                   border: Border.all(
//                       color: hexColor('DDDDDD'),
//                       width: 1
//                   )
//               ),
//               child: Text('?????????', style: CStyle.p10_5_9),
//             ),
//           ),
//           SizedBox(height: 10),
//           Padding(
//             padding: EdgeInsets.only(left: 16, right: 16),
//             child: Text('"????????? ?????? ??? ??? ?????? ?????? ???????????? ????????? ?????????" ????????? ?????? ??? ????????? ??? ???! ???', maxLines: 2, style: CStyle.p18_7_3)
//           ),
//           SizedBox(height: 20),
//           SingleChildScrollView(
//             padding: EdgeInsets.only(left: 16, right: 16),
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: [
//                 Container(
//                   width: cellWidth,
//                   height: cellWidth,
//                   decoration: BoxDecoration(
//                       color: Colors.green,
//                       borderRadius: BorderRadius.all(Radius.circular(6))
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 Container(
//                   width: cellWidth,
//                   height: cellWidth,
//                   decoration: BoxDecoration(
//                       color: Colors.green,
//                       borderRadius: BorderRadius.all(Radius.circular(6))
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 Container(
//                   width: cellWidth,
//                   height: cellWidth,
//                   decoration: BoxDecoration(
//                       color: Colors.green,
//                       borderRadius: BorderRadius.all(Radius.circular(6))
//                   ),
//                 ),
//
//               ],
//             ),
//           ),
//           SizedBox(height: 20),
//           Padding(
//             padding: EdgeInsets.only(left: 16, right: 16),
//             child: Text(
//               '"??????, ??? ???????????? ????????? ????????? ?????? ?????? ??????????????? ?????? ?????? ???????????? ??? ????????? ????????? ??? ?????? ?????? ????????? ????????????." ??????, ???????????? ?????????(?!) ???????????? ????????? ???????????? ??????...',
//               style: CStyle.p14_3_6,
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _themeList({required String title, subTitle}) {
//     return Container(
//       padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
//       child: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.only(left: 16),
//             child: Row(
//               children: [
//                 Text(title, style: CStyle.p18_7_3),
//                 SizedBox(width: 4),
//                 Text(subTitle, style: CStyle.p18_7_pri),
//                 Icon(Icons.keyboard_arrow_right, size: 24, color: Colors.black,)
//
//               ],
//             ),
//           ),
//           SizedBox(height: 20),
//           SingleChildScrollView(
//             padding: EdgeInsets.only(left: 16, right: 16),
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: [
//                 _themeCell(),
//                 SizedBox(width: 10),
//                 _themeCell(),
//                 SizedBox(width: 10),
//                 _themeCell(),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _themeCell() {
//     double cellWidth = (MediaQuery.of(context).size.width - 16 - 20 - 20) / 2;
//     return InkWell(
//       onTap: () {
//         // Navigator.push(
//         //   context,
//         //   MaterialPageRoute(builder: (context) => SolohouseViewPage()),
//         // );
//       },
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: cellWidth,
//             height: cellWidth,
//             decoration: BoxDecoration(
//                 color: Colors.green,
//                 borderRadius: BorderRadius.circular(6)
//             ),
//           ),
//           SizedBox(height: 10),
//           Text('15?????? ????????? ?????? ??? ???', maxLines: 1, overflow: TextOverflow.ellipsis, style: CStyle.p14_5_4)
//         ],
//       ),
//     );
//   }
//
//   Widget _solostayList() {
//     return Container(
//       padding: EdgeInsets.fromLTRB(16, 30, 16, 30),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Text('???? ?????? ????????????? ', style: CStyle.p18_7_3),
//               SizedBox(width: 4),
//               Text('???????????????', style: CStyle.p18_7_pri),
//               Icon(Icons.keyboard_arrow_right, size: 24, color: Colors.black,)
//             ],
//           ),
//           SizedBox(height: 20),
//           _solostayCell(),
//           SizedBox(height: 30),
//           _solostayCell(),
//           SizedBox(height: 30),
//           _solostayCell(),
//         ],
//       ),
//     );
//   }
//
//   Widget _solostayCell() {
//     return InkWell(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => SolostayViewPage()),
//         );
//       },
//       child: Row(
//         children: [
//           Container(
//             width: 110,
//             height: 110,
//
//             decoration: BoxDecoration(
//               color: Colors.green,
//               borderRadius: BorderRadius.circular(6)
//             ),
//           ),
//           SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('????????? ?????????', style: CStyle.p12_4_6,),
//                 Text('22.03.01 ~ 22.03.02', style: CStyle.p12_4_6,),
//                 SizedBox(height: 10),
//                 Text('????????? ?????? 5?????????, ???????????? ????????? ?????? ?????? ??????????????????.\n??????????????? ???????????????.', maxLines: 3, style: CStyle.p14_5_4),
//               ],
//             )
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _qnaList() {
//     return Container(
//       padding: EdgeInsets.fromLTRB(16, 30, 16, 30),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Text('???? ???????????????! ', style: CStyle.p18_7_3),
//               SizedBox(width: 4),
//               Text('????????????', style: CStyle.p18_7_pri),
//               Icon(Icons.keyboard_arrow_right, size: 24, color: Colors.black,)
//             ],
//           ),
//           SizedBox(height: 20),
//           _qnaCell(),
//           SizedBox(height: 12),
//           _qnaCell(),
//           SizedBox(height: 12),
//           _qnaCell(),
//         ],
//       ),
//     );
//   }
//
//   Widget _qnaCell() {
//     return InkWell(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => QnaViewPage()),
//         );
//       },
//       child: Container(
//         padding: EdgeInsets.fromLTRB(16, 22, 16, 22),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(6),
//           border: Border.all(
//             color: hexColor('CCCCCC'),
//             width: 1
//           )
//         ),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Text('Q', style: CStyle.p18_7_sec),
//                 SizedBox(width: 4),
//                 Expanded(
//                   child: Text('Diy ????????? ????????? ???????????? ?????? ??????????', maxLines: 1, overflow: TextOverflow.ellipsis, style: CStyle.p16_7_3)
//                 )
//               ],
//             ),
//             SizedBox(height: 14),
//             Text('????????? ???????????? ????????? ?????? ????????? ???????????? ????????? ??????????????? ????????? ????????? ???????????? diy ????????? ???...', style: CStyle.p14_3_6),
//             SizedBox(height: 14),
//             Row(
//               children: [
//                 Expanded(child: SizedBox()),
//                 Icon(Icons.chat_bubble_outline, size: 16, color: hexColor('CCCCCC')),
//                 SizedBox(width: 6),
//                 Text('?????? 1???', style: CStyle.p12_4_6)
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
