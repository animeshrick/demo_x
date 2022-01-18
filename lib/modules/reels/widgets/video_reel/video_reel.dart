import 'package:dualites/modules/home/widgets/models/video_model.dart';
import 'package:dualites/modules/reels/models/video_controller_model.dart';
import 'package:dualites/modules/reels/widgets/reel_liked_widget/reel_liked_widget.dart';
import 'package:dualites/modules/reels/widgets/reel_page/reel_page.dart';
import 'package:dualites/modules/reels/widgets/video/video_info.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class VideoReel extends StatefulWidget{
  VideoControllerModel videoControllerModel;
  VideoModel videoModel;
  VideoReel({this.videoControllerModel,this.videoModel});
  VideoReelState createState()=>VideoReelState();
}
class VideoReelState extends State<VideoReel>{
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ReelsSwitchPlayer(videoModel: widget.videoModel),
        Padding(padding: EdgeInsets.only(bottom: 70),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width - 100,
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 10, bottom: 10),
                    child: Text('@spook_clothing',
                      style: TextStyle(color: Colors.white),),),
                  Padding(padding: EdgeInsets.only(
                      left: 10, bottom: 10),
                      child: Text.rich(TextSpan(
                          children: <TextSpan>[
                            TextSpan(text: widget.videoModel.authorName ?? "Name"),
                            TextSpan(text: '#foot\n',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(text:widget.videoModel.description ,
                                style: TextStyle(fontSize: 12))
                          ]), style: TextStyle(
                          color: Colors.white, fontSize: 14),)),

                ],
              ),
            ),
          ),),

        Padding(padding: EdgeInsets.only(bottom: 65, right: 10),
            child: Align(alignment: Alignment.bottomRight,
              child: Container(
                width: 70,
                height: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 23),
                      width: 40,
                      height: 50,
                      child: Stack(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 19,
                              backgroundColor: Colors.black,
                              backgroundImage: AssetImage(
                                  'assets/spook.png'),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: Color(0xfd2c58)
                                  .withOpacity(1),
                              child: Center(child: Icon(
                                  Icons.add, size: 15,
                                  color: Colors.white)),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .center,
                        children: <Widget>[
                          IconButton(icon: Icon(Icons.masks), onPressed: (){
                            setState(() {
                              if(widget.videoControllerModel.active==1){
                                widget.videoControllerModel.active=2;
                                widget.videoControllerModel.controller1.setVolume(0.0);
                                widget.videoControllerModel.controller2.setVolume(1.0);
                              }
                              else{
                                widget.videoControllerModel.controller2.setVolume(0.0);
                                widget.videoControllerModel.controller1.setVolume(1.0);
                                widget.videoControllerModel.active=1;
                              }
                            });
                          })
                          //LikeWidget(videoModel: reelsListController.videosList[index],),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .center,
                        children: <Widget>[
                          ReelLikeWidget(videoModel: widget.videoModel),
                          //LikeWidget(videoModel: reelsListController.videosList[index],),
                          Text(widget.videoModel.likedCount ?? "1",
                              style: TextStyle(color: Colors.white))
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .center,
                        children: <Widget>[
                          Transform(alignment: Alignment.center,
                              transform: Matrix4.rotationY(math.pi),
                              child: Icon(Icons.sms, size: 35,
                                  color: Colors.white)),
                          Text('2051',
                              style: TextStyle(color: Colors.white))
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .center,
                        children: <Widget>[
                          Transform(alignment: Alignment.center,
                              transform: Matrix4.rotationY(math.pi),
                              child: Icon(Icons.reply, size: 35,
                                  color: Colors.white)),
                          Text('Author Name',
                              style: TextStyle(color: Colors.white))
                        ],
                      ),
                    ),
                  ],
                ),
              ),))
      ],
    );
  }
}