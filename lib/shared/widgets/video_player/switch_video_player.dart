import 'package:dualites/modules/home/widgets/models/video_model.dart';
import 'package:dualites/modules/reels/models/video_controller_model.dart';
import 'package:dualites/modules/reels/widgets/video/video_info.dart';
import 'package:dualites/shared/widgets/loading/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
class SwitchVideoPlayer extends StatefulWidget {
  VideoModel videoModel;
  SwitchVideoPlayer({this.videoModel});
  SwitchVideoPlayerState createState()=>SwitchVideoPlayerState();
}

class SwitchVideoPlayerState extends State<SwitchVideoPlayer> with SingleTickerProviderStateMixin  {
  bool abo = false;
  bool foryou = true;
  bool play = true;
  bool _isLoading=true;
  VideoPlayerController _videoPlayerController1,_videoPlayerController2;
  int activeVideoControllerModel=0;
  String videosErrorMessage="";
  VideoControllerModel videoControllerModel=new VideoControllerModel(active: 1);
  Duration _currentDuration=Duration(seconds: 0);
  @override
  void initState(){

    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    _initializePlayer();
  }

  _initializePlayer(){
    _videoPlayerController1 = widget.videoModel.contentOne == null ?
    VideoPlayerController.asset("assets/vod.mp4") :
    VideoPlayerController.network(widget.videoModel.contentOne,videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: true
    ));

      _videoPlayerController1.initialize().then((value) {
      if (_videoPlayerController1.value.duration == null ||
          _videoPlayerController1.value.duration == Duration(
              seconds: 0
          )) {
        _isLoading = false;
        videosErrorMessage = "First Video is either not available or blank.";
      }
      else{
        _videoPlayerController2 = widget.videoModel.contentTwo == null ?
        VideoPlayerController.asset("assets/vod.mp4") :
        VideoPlayerController.network(widget.videoModel.contentTwo,
            videoPlayerOptions: VideoPlayerOptions(
              mixWithOthers: true,
            ));


        _videoPlayerController2.initialize().then((value) {
          if (_videoPlayerController1.value.duration == null &&
              _videoPlayerController1.value.duration == Duration(
                  seconds: 0
              )) {
            _isLoading = false;
            videosErrorMessage = "Second Video is either not available or blank.";
          }
          else{
            setState(() {

              videoControllerModel.controller1 = _videoPlayerController1;
              videoControllerModel.controller2 = _videoPlayerController2;
              _videoPlayerController2.setVolume(0.0);
              _videoPlayerController2.seekTo(Duration(seconds: 0));
              _videoPlayerController1.play();
              _videoPlayerController2.play();
              _videoPlayerController1.setLooping(true);
              _videoPlayerController2.setLooping(true);
              activeVideoControllerModel = 1;
              _isLoading = false;
            });
          }
        });
      }
    });

  }

  @override
  void dispose(){
    if(_videoPlayerController1.value.isPlaying)
      _videoPlayerController1.pause();
    if(_videoPlayerController2.value.isPlaying)
      _videoPlayerController2.pause();
    _videoPlayerController1.dispose();
    _videoPlayerController2.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
  bool isPaused=false;
  Widget iconWidget;

  @override
  Widget build(BuildContext context){
    iconWidget=IconButton(icon: Icon(Icons.pause), onPressed: (){
      _videoPlayerController1.pause();
    },color: Colors.white,);
    return SafeArea(
      top: true,
      child: Scaffold(
          body: LoadingOverlay(
              isLoading: _isLoading,
              isFormSaveOverlay: false,
              child:videosErrorMessage!=""?
              Center(child: Text(videosErrorMessage,style: TextStyle(color: Colors.black),),):Stack(
                children: [

                  VideoInfo(videoPlayerController: videoControllerModel.active==1?
                  _videoPlayerController1:_videoPlayerController2,callback: (){
                    setState(() {
                      if(videoControllerModel.active==1) {
                        _currentDuration = _videoPlayerController1.value.position;
                        //_videoPlayerController2.play();
                        //_videoPlayerController2.seekTo(_currentDuration);
                        _videoPlayerController1.setVolume(0.0);
                        _videoPlayerController2.setVolume(1.0);
                        videoControllerModel.active = 2;
                      }
                      else{
                        videoControllerModel.active=1;
                        //_videoPlayerController1.seekTo(_currentDuration);
                        //_videoPlayerController1.play();
                        _videoPlayerController2.setVolume(0.0);
                        _videoPlayerController1.setVolume(1.0);
                      }
                    });
                  },),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: IconButton(icon: isPaused ?Icon(Icons.play_arrow):Icon(Icons.pause), onPressed: (){
                      setState(() {
                        if(isPaused) {
                          _videoPlayerController1.play();
                          _videoPlayerController2.play();
                          isPaused = false;

                        }else{
                          _videoPlayerController1.pause();
                          _videoPlayerController2.pause();
                          isPaused = true;
                        }

                      });

                    },color: Colors.white,),
                  ),
                  isPaused ? Opacity(
                    opacity: 0.3,
                    child: Container(
                      color: Colors.blue,
                    ),
                  ):Container(),
                  isPaused ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.3,
                        child: Column(
                          crossAxisAlignment:  CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.videoModel.title,style: TextStyle(color: Colors.white,fontSize: 20.0),),
                                IconButton(
                                  onPressed: (){
                                    setState(() {
                                      _videoPlayerController1.play();
                                      _videoPlayerController2.play();
                                      isPaused = false;
                                    });
                                  },
                                  icon: Icon(Icons.close),
                                )
                              ],
                            ),
                            InkWell(
                              onTap: (){
                                setState(() {
                                  isPaused=false;
                                  _videoPlayerController1.seekTo(Duration(
                                      seconds: 0
                                  ));
                                  _videoPlayerController2.seekTo(Duration(seconds: 0));
                                  _videoPlayerController1.play();
                                  _videoPlayerController2.play();
                                });
                              },child: Text("Start Over",style: TextStyle(color: Colors.white,fontSize: 20.0),),)
                          ],
                        ),
                      ),
                    ),
                  ):Container()
                ],
              )
          )),
    );
  }
}