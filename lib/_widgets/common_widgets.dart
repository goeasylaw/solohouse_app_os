import 'package:flutter/material.dart';
import 'package:solohouse/_common/util.dart';
import 'package:solohouse/_widgets/web_dialog.dart';


void showWebDialog(BuildContext context, title, url, {bool navigator = false, bool other = false}) {
  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: WebDialog(title: title,url: url,navigator: navigator, other: other),
        );
      }
  );
}


Widget listImageView(String url) {
  if(url.endsWith('.m3u8')) {
    String imageUrl = url.replaceAll('https://server/hls/', 'https://server/capture/').replaceAll('HLS.m3u8', '.0000000.jpg');
    return Container(
      width: 120,
      height: 120,
      color: hexColor('FEFEFE'),
      child: url.isEmpty?Icon(Icons.image, size: 100, color: Colors.grey[200]):
      Image.network(imageUrl, width: 120, height: 120, fit: BoxFit.cover),
    );
  } else {
    return Container(
      width: 120,
      height: 120,
      color: hexColor('FEFEFE'),
      child: url.isEmpty?Icon(Icons.image, size: 100, color: Colors.grey[200]):
      Image.network(url, width: 120, height: 120, fit: BoxFit.cover),
    );
  }

}

Widget imageProfileSmall(String url) {
  return Row(
    children: [
      url.isEmpty?
      Icon(Icons.person, size: 24, color: Colors.black)
          :ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(url, width: 24, height: 24),
      ),
    ],
  );
}