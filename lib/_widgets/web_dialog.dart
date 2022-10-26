import 'dart:async';

import 'package:flutter/material.dart';
import 'package:solohouse/_common/c_style.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebDialog extends StatefulWidget {
  WebDialog({Key? key, required this.title, required this.url, this.navigator = false, this.other = false}) : super(key: key);
  final String title;
  final String url;
  final bool navigator;
  final bool other;

  @override
  State<WebDialog> createState() => _WebDialogState();
}

class _WebDialogState extends State<WebDialog> {
  // final Completer<WebViewController> _controller = Completer<WebViewController>();

  bool navigateBefore = false;
  bool navigateNext = false;

  @override
  void initState() {
    super.initState();
    // if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppbar(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          tooltip: '닫기',
          onPressed: () {
            Navigator.pop(context);
          }
      ),
      title: Text(widget.title, style: CStyle.p14_5_4),
      actions: [
        Visibility(
          visible: widget.other,
          child: _appbarPopup()
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: WebView(
              initialUrl: widget.url,
              // javascriptMode: JavascriptMode.unrestricted,
              // onWebViewCreated: (WebViewController webViewController) {
              //   _controller.complete(webViewController);
              // },
              // javascriptChannels: <JavascriptChannel>{
              //   _toasterJavascriptChannel(context),
              // },
              // onPageStarted: (String url) {
              //   //print('Page started loading: $url');
              // },
              // onPageFinished: (String url) {
              //   //print('Page finished loading: $url');
              // },
              // gestureNavigationEnabled: true,
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.black12,
          ),
          // Visibility(
          //   visible: widget.navigator,
          //   child: NavigationControls(_controller.future),
          // )
        ],
      )
    );
  }

  Widget _appbarPopup() => PopupMenuButton<int>(
    icon: Icon(Icons.more_vert, size: 20, color: Colors.black),
    onSelected: (value) async {
      if(value == 1) {
        launchUrl(Uri.parse(widget.url));
      }
    },
    itemBuilder: (context) => [
      PopupMenuItem(
        value: 1,
        child: Text("다른 브라우저로 열기", style: CStyle.p12_4_6),
      ),
    ],
  );
}

class NavigationControls extends StatelessWidget {
  NavigationControls(this._webViewControllerFuture, {Key? key}) : super(key: key);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController? controller = snapshot.data;
        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.navigate_before),
              onPressed: !webViewReady
                  ? null
                  : () async {
                if (await controller!.canGoBack()) {
                  await controller.goBack();
                } else {

                  return;
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.navigate_next),
              onPressed: !webViewReady
                  ? null
                  : () async {
                if (await controller!.canGoForward()) {
                  await controller.goForward();
                } else {

                  return;
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: !webViewReady
                  ? null
                  : () {
                controller!.reload();
              },
            ),
          ],
        );
      },
    );
  }
}