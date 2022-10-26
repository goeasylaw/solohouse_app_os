import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
class VideoModel with ChangeNotifier{
  static final VideoModel _singleton = VideoModel._internal();

  factory VideoModel() { return _singleton; }

  VideoModel._internal();

  List<VideoPlayerController> videoControllers = [];

  void allPause() {
    for(VideoPlayerController controller in videoControllers) {
      controller.pause();
    }
  }
}