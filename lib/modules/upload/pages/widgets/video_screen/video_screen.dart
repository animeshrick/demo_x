
import 'package:dualites/modules/upload/getx/gallery_controller.dart';
import 'package:dualites/shared/widgets/video_player/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {


  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  bool initialized = false;
  GalleryController galleryController=Get.find();

  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if(galleryController.selectedAssetEntity.value.path==null)
          return Center(child: Text("Select Any Video to play"),);
        return Scaffold(
          body: Center(
            child: PlayerWidget(
              deviceOrientation: DeviceOrientation.portraitUp,
              videoPlayerController: VideoPlayerController.file(
                  galleryController.selectedAssetEntity.value),
              looping: false,
              autoplay: true,
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Wrap the play or pause in a call to `setState`. This ensures the
              // correct icon is shown.
              setState(() {
                // If the video is playing, pause it.
                if (galleryController.controller.value.isPlaying) {
                  galleryController.controller.pause();
                } else {
                  // If the video is paused, play it.
                  galleryController.controller.play();
                }
              });
            }
          ),
        );

      })
    );
  }
}