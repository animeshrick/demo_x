import 'package:dualites/modules/reels/widgets/reel_page/reel_page.dart';
import 'package:dualites/shared/services/reels_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class VideoReelsList extends StatefulWidget {
  VideoReelsListState createState()=>VideoReelsListState();
}
class VideoReelsListState extends State<VideoReelsList>  with SingleTickerProviderStateMixin {
  PageController foryouController = new PageController();
  AnimationController animationController;
  bool _isFirstLoad=true;

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final ReelsModel reelsListController=Get.find();
    if(_isFirstLoad) {
     setState(() {
       reelsListController.playControllerAtIndex(reelsListController.currentPlatingVideoIndex);
       _isFirstLoad=false;
     });
    }
    return Obx((){
      return PageView.builder(
          controller: foryouController,
          onPageChanged: (index) {
            setState(() {
              reelsListController.onVideoIndexChanged(index);
            });
          },
          scrollDirection: Axis.vertical,
          itemCount: reelsListController.videosList.length,
          itemBuilder: (context, index) {
            if(reelsListController.controllers[reelsListController.currentPlatingVideoIndex].isEmpty){
              return Center(
                child: Text(reelsListController.controllersErrorMessages[reelsListController.currentPlatingVideoIndex]),
              );
            }return ReelsSwitchPlayer(
                videoModel: reelsListController.videosList[reelsListController
                    .currentPlatingVideoIndex],
                videoPlayerController1: reelsListController
                    .controllers[reelsListController
                    .currentPlatingVideoIndex][0],
                videoPlayerController2: reelsListController
                    .controllers[reelsListController
                    .currentPlatingVideoIndex][1],);

          });
    });
  }
}