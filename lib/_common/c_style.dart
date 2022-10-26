import 'package:flutter/material.dart';
import 'package:solohouse/_common/util.dart';

class CStyle {
  static Color colorPri = Color(0xFF18B5C0);
  static Color colorSec = Color(0xFFFF7B7B);
  static Color colorGrey7 = Color(0xFF777777);
  static Color colorGreyC = Color(0xFFCCCCCC);
  static Color colorGreyFA = Color(0xFFFAFAFA);

  static TextStyle appbarTitle = TextStyle(fontFamily: 'Pretendard', fontSize: 14, fontWeight: FontWeight.w700, color: hexColor('444444'));


  static TextStyle p36_9_white = TextStyle(fontFamily: 'Pretendard', fontSize: 36, fontWeight: FontWeight.w900, color: Colors.white);

  static TextStyle p18_7_3 = TextStyle(fontFamily: 'Pretendard', fontSize: 18, fontWeight: FontWeight.w700, color: hexColor('333333'));
  static TextStyle p18_7_white = TextStyle(fontFamily: 'Pretendard', fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white);
  static TextStyle p18_7_pri = TextStyle(fontFamily: 'Pretendard', fontSize: 18, fontWeight: FontWeight.w700, color: colorPri);
  static TextStyle p18_7_sec = TextStyle(fontFamily: 'Pretendard', fontSize: 18, fontWeight: FontWeight.w700, color: colorSec);

  static TextStyle p16_7_3 = TextStyle(fontFamily: 'Pretendard', fontSize: 16, fontWeight: FontWeight.w700, color: hexColor('333333'));
  static TextStyle p16_7_white = TextStyle(fontFamily: 'Pretendard', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white);
  static TextStyle p16_7_B = TextStyle(fontFamily: 'Pretendard', fontSize: 16, fontWeight: FontWeight.w700, color: hexColor('BBBBBB'));
  static TextStyle p16_3_6 = TextStyle(fontFamily: 'Pretendard', fontSize: 16, fontWeight: FontWeight.w300, color: hexColor('666666'));
  static TextStyle p16_3_6_16 = TextStyle(fontFamily: 'Pretendard', fontSize: 16, fontWeight: FontWeight.w300, color: hexColor('666666'), height: 1.6);

  static TextStyle p15_7_pri = TextStyle(fontFamily: 'Pretendard', fontSize: 15, fontWeight: FontWeight.w700, color: colorPri);
  static TextStyle p15_7_sec = TextStyle(fontFamily: 'Pretendard', fontSize: 15, fontWeight: FontWeight.w700, color: colorSec);
  static TextStyle p15_4_6 = TextStyle(fontFamily: 'Pretendard', fontSize: 15, fontWeight: FontWeight.w400, color: hexColor('666666'));
  static TextStyle p15_4_7 = TextStyle(fontFamily: 'Pretendard', fontSize: 15, fontWeight: FontWeight.w400, color: hexColor('777777'));

  static TextStyle p14_7_8 = TextStyle(fontFamily: 'Pretendard', fontSize: 14, fontWeight: FontWeight.w700, color: hexColor('888888'));
  static TextStyle p14_7_6 = TextStyle(fontFamily: 'Pretendard', fontSize: 14, fontWeight: FontWeight.w700, color: hexColor('666666'));
  static TextStyle p14_7_4 = TextStyle(fontFamily: 'Pretendard', fontSize: 14, fontWeight: FontWeight.w700, color: hexColor('444444'));
  static TextStyle p14_7_white = TextStyle(fontFamily: 'Pretendard', fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white);
  static TextStyle p14_5_B = TextStyle(fontFamily: 'Pretendard', fontSize: 15, fontWeight: FontWeight.w500, color: hexColor('BBBBBB'));
  static TextStyle p14_5_4 = TextStyle(fontFamily: 'Pretendard', fontSize: 14, fontWeight: FontWeight.w500, color: hexColor('444444'));
  static TextStyle p14_3_6 = TextStyle(fontFamily: 'Pretendard', fontSize: 14, fontWeight: FontWeight.w300, color: hexColor('666666'));
  static TextStyle p14_3_6_16 = TextStyle(fontFamily: 'Pretendard', fontSize: 14, fontWeight: FontWeight.w300, color: hexColor('666666'), height: 1.6);
  static TextStyle p14_3_white_16 = TextStyle(fontFamily: 'Pretendard', fontSize: 14, fontWeight: FontWeight.w300, color: Colors.white, height: 1.6);
  static TextStyle p14_3_pri = TextStyle(fontFamily: 'Pretendard', fontSize: 14, fontWeight: FontWeight.w300, color: colorPri);
  static TextStyle p14_7_pri = TextStyle(fontFamily: 'Pretendard', fontSize: 14, fontWeight: FontWeight.w700, color: colorPri);
  static TextStyle p14_3_sec = TextStyle(fontFamily: 'Pretendard', fontSize: 14, fontWeight: FontWeight.w300, color: colorSec);

  static TextStyle p14_5_pri = TextStyle(fontFamily: 'Pretendard', fontSize: 14, fontWeight: FontWeight.w500, color: colorPri, decoration: TextDecoration.underline);

  static TextStyle p12_7_6 = TextStyle(fontFamily: 'Pretendard', fontSize: 12, fontWeight: FontWeight.w700, color: hexColor('666666'));
  static TextStyle p12_7_a = TextStyle(fontFamily: 'Pretendard', fontSize: 12, fontWeight: FontWeight.w700, color: hexColor('aaaaaa'));
  static TextStyle p12_3_a = TextStyle(fontFamily: 'Pretendard', fontSize: 12, fontWeight: FontWeight.w300, color: hexColor('aaaaaa'));
  static TextStyle p12_7_white = TextStyle(fontFamily: 'Pretendard', fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white);
  static TextStyle p12_3_white_under = TextStyle(fontFamily: 'Pretendard', fontSize: 12, fontWeight: FontWeight.w300, color: Colors.white, decoration: TextDecoration.underline);
  static TextStyle p12_5_black = TextStyle(fontFamily: 'Pretendard', fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black);
  static TextStyle p12_5_7 = TextStyle(fontFamily: 'Pretendard', fontSize: 12, fontWeight: FontWeight.w500, color: hexColor('777777'));
  static TextStyle p12_5_3 = TextStyle(fontFamily: 'Pretendard', fontSize: 12, fontWeight: FontWeight.w500, color: hexColor('333333'));
  static TextStyle p12_5_2 = TextStyle(fontFamily: 'Pretendard', fontSize: 14, fontWeight: FontWeight.w500, color: hexColor('222222'));
  static TextStyle p12_4_sec = TextStyle(fontFamily: 'Pretendard', fontSize: 12, fontWeight: FontWeight.w400, color: colorPri);
  static TextStyle p12_4_6 = TextStyle(fontFamily: 'Pretendard', fontSize: 12, fontWeight: FontWeight.w400, color: hexColor('666666'));
  static TextStyle p12_3_white = TextStyle(fontFamily: 'Pretendard', fontSize: 14, fontWeight: FontWeight.w300, color: Colors.white);
  static TextStyle p12_3_9 = TextStyle(fontFamily: 'Pretendard', fontSize: 12, fontWeight: FontWeight.w300, color: hexColor('999999'));

  static TextStyle p11_3_B = TextStyle(fontFamily: 'Pretendard', fontSize: 11, fontWeight: FontWeight.w300, color: hexColor('BBBBBB'));
  static TextStyle p12_3_D = TextStyle(fontFamily: 'Pretendard', fontSize: 12, fontWeight: FontWeight.w300, color: hexColor('DDDDDD'));

  static TextStyle p10_7_white = TextStyle(fontFamily: 'Pretendard', fontSize: 10, fontWeight: FontWeight.w500, color: Colors.white);
  static TextStyle p10_7_pri = TextStyle(fontFamily: 'Pretendard', fontSize: 10, fontWeight: FontWeight.w500, color: colorPri);
  static TextStyle p10_5_9 = TextStyle(fontFamily: 'Pretendard', fontSize: 10, fontWeight: FontWeight.w500, color: hexColor('999999'));
  static TextStyle p10_5_white = TextStyle(fontFamily: 'Pretendard', fontSize: 10, fontWeight: FontWeight.w500, color: Colors.white);

}
