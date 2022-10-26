import 'dart:convert';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:solohouse/_common/c_style.dart';
import 'package:video_player/video_player.dart';

import '../_common/api.dart';
import '../_model/video_model.dart';


class VideoWidget extends StatefulWidget {
  VideoWidget({super.key, required this.url, required this.width, required this.height});
  final String url;
  final double width;
  final double height;

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late double _width;
  late double _height;

  bool hasUrlLoading = true;
  bool hasUrl = false;
  bool isPlaying = false;

  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    _width = widget.width;
    _height = widget.height;

    //비디오 컨트롤러 모델이 입력한다.

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {

      var res = await Api().get(Uri.parse(widget.url));

      if(res.statusCode == 200) {
        hasUrl = true;
      }

      if(hasUrl) {
        videoPlayerController = VideoPlayerController.network(widget.url);
        VideoModel().videoControllers.add(videoPlayerController);

        await videoPlayerController.initialize();

        chewieController = ChewieController(
          videoPlayerController: videoPlayerController,
          aspectRatio: videoPlayerController.value.aspectRatio,
          autoPlay: false,
          fullScreenByDefault: false,
          autoInitialize: true,
          looping: true,
          showControls: false,
          allowPlaybackSpeedChanging: false,
        );

        videoPlayerController.addListener(() {
          if(isPlaying != chewieController.isPlaying ) {
            isPlaying = chewieController.isPlaying;
            setState(() {
            });
          }
        });
      }

      setState(() {
        hasUrlLoading = false;
      });
    });
  }

  @override
  void dispose() {
    VideoModel().videoControllers.remove(videoPlayerController);
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return hasUrlLoading?Container(
      width: _width,
      height: _height,
      color: Colors.grey,
      alignment: Alignment.center,
      child: Text('로딩중..',
        style:  CStyle.p16_7_white, textAlign: TextAlign.center,
      ),
    ):Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: hasUrl?videoPlay():Container(
          width: _width,
          height: _height,
          color: Colors.black,
          alignment: Alignment.center,
          child: Text(hasUrlLoading?'로딩중..':'동영상 변환중 입니다.\n잠시후에 다시 로드해 주세요.',
            style:  CStyle.p16_7_white, textAlign: TextAlign.center,
          ),
        )
    );
  }

  Widget videoPlay() {
    print(MediaQuery.of(context).size.width / chewieController.aspectRatio!);
    return Stack(
      alignment: Alignment.center,
      children: [
        Chewie(controller: chewieController),
        chewieController.isPlaying?InkWell(
          onTap: () {
            chewieController.pause();
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width / chewieController.aspectRatio!,
          ),
        ):IconButton(
          onPressed: () {
            chewieController.play();
          },
          icon: Icon(Icons.play_circle, size: 64, color: Colors.white70)
        )
      ],
    );
  }


}