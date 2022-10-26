import 'dart:io';

class AppConfig  {

  static final AppConfig _singleton = AppConfig._internal();

  factory AppConfig() { return _singleton; }

  AppConfig._internal();

  static const String env = String.fromEnvironment('ENV', defaultValue: 'LIVE');
  bool mainLoadComplete = false;

  List<String> solohouseCategories = [
    '',
    '매거진',
    '솔로하우스',
    '솔로스테이'
  ];


  //TODO: 파일 서버 주소를 입력하세요.
  String fileServerUrl = 'https://fileServer';

  String baseUrl() {
    //TODO: API 서버 주소를 입력하세요.
    return 'https://apiServer';    
}