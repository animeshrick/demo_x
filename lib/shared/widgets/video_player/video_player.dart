import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  final bool autoplay;


  VideoPlayerWidget({
    @required this.videoPlayerController,
    this.looping, this.autoplay,
    Key key,
  }) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      deviceOrientationsOnEnterFullScreen: [DeviceOrientation.landscapeLeft],
      fullScreenByDefault: true,
      videoPlayerController: widget.videoPlayerController,
      aspectRatio:widget.videoPlayerController.value.aspectRatio,
      autoInitialize: true,
      looping: widget.looping,
      allowFullScreen: true,
      //autoPlay: widget.autoplay,
      /*


      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },*/
    );
  }



  @override
  void dispose() {
    super.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }

}