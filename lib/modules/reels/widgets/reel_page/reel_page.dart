import 'package:date_format/date_format.dart';
import 'package:dualites/modules/home/widgets/models/video_model.dart';
import 'package:dualites/modules/reels/models/video_controller_model.dart';
import 'package:dualites/modules/reels/widgets/video/video_info.dart';
import 'package:dualites/shared/widgets/loading/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
class ReelsSwitchPlayer extends StatefulWidget {
  VideoModel videoModel;
  VideoPlayerController videoPlayerController1,videoPlayerController2;
  ReelsSwitchPlayer({this.videoModel,this.videoPlayerController1,this.videoPlayerController2});
  ReelsSwitchPlayerState createState()=>ReelsSwitchPlayerState();
}

class ReelsSwitchPlayerState extends State<ReelsSwitchPlayer> with SingleTickerProviderStateMixin  {
  bool abo = false;
  bool foryou = true;
  bool play = true;
  bool _isLoading=true;
  int activeVideoControllerModel=0;

  VideoControllerModel videoControllerModel=new VideoControllerModel(active: 1);
  Duration _currentDuration=Duration(seconds: 0);

  bool isPaused=false;
  Widget iconWidget;

  @override
  Widget build(BuildContext context){
    iconWidget=IconButton(icon: Icon(Icons.pause), onPressed: (){
      widget.videoPlayerController1.pause();
    },color: Colors.white,);
    return Scaffold(
        body: LoadingOverlay(
            isLoading: false,
            isFormSaveOverlay: false,
            child:Stack(
              children: [
                VideoInfo(videoPlayerController: videoControllerModel.active==1?
                widget.videoPlayerController1:widget.videoPlayerController2,
                callback: (){
                  setState(() {
                    if(videoControllerModel.active==1) {
                      _currentDuration = widget.videoPlayerController1.value.position;
                      widget.videoPlayerController1.setVolume(0.0);
                      widget.videoPlayerController2.setVolume(1.0);
                      videoControllerModel.active = 2;
                    }
                    else{
                      videoControllerModel.active=1;
                      widget.videoPlayerController2.setVolume(0.0);
                      widget.videoPlayerController1.setVolume(1.0);
                    }
                  });
                },
                  longPressCallback: (){
                  setState(() {
                    if(isPaused) {
                      widget.videoPlayerController1.play();
                      widget.videoPlayerController2.play();
                      isPaused = false;

                    }else{
                      widget.videoPlayerController1.pause();
                      widget.videoPlayerController2.pause();
                      isPaused = true;
                    }
                  });
                },)
              ],
            )
        ));
  }
}