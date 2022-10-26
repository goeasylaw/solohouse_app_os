
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:solohouse/_common/c_style.dart';

class PhotoDialog extends StatefulWidget {
  PhotoDialog(this.photos, {Key? key, this.initPage = 0}) : super(key: key);
  final List photos;
  final int initPage;

  @override
  State<PhotoDialog> createState() => _PhotoDialogState();
}

class _PhotoDialogState extends State<PhotoDialog> {

  int currentPage = 1;


  @override
  void initState() {
    super.initState();

    if(widget.initPage > 0) {
      currentPage = widget.initPage + 1;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      //   systemNavigationBarColor: RpStyle.c_black,
      //   statusBarColor: RpStyle.c_black,
      // ));
    });
  }

  @override
  void dispose() {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   systemNavigationBarColor: Colors.white,
    //   statusBarColor: Colors.white,
    // ));

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppbar(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    String title = '사진 보기 ( ${currentPage.toString()} / ${widget.photos.length.toString()})';
    if(widget.photos.length <= 1) {
      title = '사진 보기';
    }

    return AppBar(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.black,
      automaticallyImplyLeading: false,
      leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          tooltip: '닫기',
          onPressed: () {
            Navigator.pop(context);
          }
      ),
      title: Text(title, style: CStyle.p14_7_white),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
              child: Container(
                child: _buildPhotos(),
              )
          ),
        ],
      ),
    );
  }

  Widget _buildPhotos() {
    return PhotoViewGallery.builder(
      onPageChanged: (int index) {
        setState(() {
          currentPage = index+1;
        });

      },
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: NetworkImage(widget.photos[index]),
          // imageProvider: widget.photos[index].toLowerCase().startsWith('http')?
          // NetworkImage(widget.photos[index]):
          // AssetImage(widget.photos[index]),
          initialScale: PhotoViewComputedScale.contained,
          maxScale: 10.0,
          minScale: 0.1
        );
      },
      gaplessPlayback: true,
      itemCount: widget.photos.length,
      pageController: PageController(initialPage: widget.initPage),
      loadingBuilder: (context, event) => Center(
        child: Container(
          width: 30.0,
          height: 30.0,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(CStyle.colorPri), backgroundColor: Colors.black, strokeWidth: 8, semanticsLabel:'잠시 기다려 주세요.',
            value: event == null ? 0 : event.cumulativeBytesLoaded / event.expectedTotalBytes!.toInt(),
          ),
        ),
      ),
    );
  }
}
