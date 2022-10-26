import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart';
import 'package:solohouse/_common/user_model.dart';

import '../app_config.dart';

class Api extends http.BaseClient {
  bool forceGuest;

  final Map<String, String> _defaultHeaders = {
    // 'Content-Type': 'application/json'
  };

  Api({this.forceGuest = false}) {
    if (!forceGuest) {
      if (UserModel().isLogin) {
        _defaultHeaders[HttpHeaders.authorizationHeader] =
            'Bearer ${UserModel().getUserToken()}';
      }
    }
  }

  final http.Client _httpClient = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _httpClient.send(request);
  }

  @override
  Future<Response> get(Uri url, {Map<String, String>? headers}) {
    if (kDebugMode) {
      print('[GET] $url');
    }
    return _httpClient.get(url, headers: _mergedHeaders(headers));
  }

  @override
  Future<Response> post(url,
      {Map<String, String>? headers, dynamic body, Encoding? encoding}) {
    if (kDebugMode) {
      print('[POST] $url');
    }
    return _httpClient.post(url,
        headers: _mergedHeaders(headers), body: body, encoding: encoding);
  }

  @override
  Future<Response> put(url,
      {Map<String, String>? headers, dynamic body, Encoding? encoding}) {
    if (kDebugMode) {
      print('[PUT] $url');
    }
    return _httpClient.put(url,
        headers: _mergedHeaders(headers), body: body, encoding: encoding);
  }

  Future<Response> delete2(url, {Map<String, String>? headers}) {
    if (kDebugMode) {
      print('[DELETE] $url');
    }
    return _httpClient.delete(url, headers: _mergedHeaders(headers));
  }

  Future<Response> uploadBytes(String fileName, Uint8List bytes, {Map<String, String>? headers, String fileType = ''}) async {
    ByteStream stream = http.ByteStream(Stream.value(
      List<int>.from(bytes),
    ));

    var uri = Uri.parse('${AppConfig().baseUrl()}/user/upload');

    var request = http.MultipartRequest("POST", uri);

    request.headers.addAll(_mergedHeaders(headers));

    var mimeType = 'application';
    var mimeSubType = 'octet-stream';

    if (mime(fileName) != null) {
      var mimeSplit = mime(fileName)!.split('/');
      if (mimeSplit.length > 1) {
        mimeType = mime(fileName)!.split('/')[0];
        mimeSubType = mime(fileName)!.split('/')[1];
      }
    } else {
      //구분하지 못한 파일에 대한 처리를 한다.
      if (extension(fileName.toLowerCase()) == '.hwp') {
        mimeSubType = 'x-hwp';
      }
    }

    var multipartFile = http.MultipartFile('file', stream, bytes.length,
        filename: fileName,
        contentType: MediaType(mimeType, mimeSubType));

    request.files.add(multipartFile);
    if (fileType != '') {
      request.fields['fileType'] = fileType;
    }
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    return response;
  }

  Future<Response> uploadFile(String filePath,
      {Map<String, String>? headers, String fileType = ''}) async {
    File imageFile = File(filePath);
    ByteStream stream = http.ByteStream(imageFile.openRead());
    var length = await imageFile.length();

    var uri = Uri.parse('${AppConfig().baseUrl()}/user/upload');

    var request = http.MultipartRequest("POST", uri);

    request.headers.addAll(_mergedHeaders(headers));

    var mimeType = 'application';
    var mimeSubType = 'octet-stream';

    if (mime(imageFile.path) != null) {
      var mimeSplit = mime(imageFile.path)!.split('/');
      if (mimeSplit.length > 1) {
        mimeType = mime(imageFile.path)!.split('/')[0];
        mimeSubType = mime(imageFile.path)!.split('/')[1];
      }
    } else {
      //구분하지 못한 파일에 대한 처리를 한다.
      if (extension(imageFile.path.toLowerCase()) == '.hwp') {
        mimeSubType = 'x-hwp';
      }
    }

    var multipartFile = http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path),
        contentType: MediaType(mimeType, mimeSubType));

    request.files.add(multipartFile);
    if (fileType != '') {
      request.fields['fileType'] = fileType;
    }
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    return response;
  }

  Map<String, String> _mergedHeaders(Map<String, String>? headers) {
    Map<String, String> res = {};

    res.addAll(_defaultHeaders);
    if (headers != null) {
      res.addAll(headers);
    }

    return res;
  }
}
