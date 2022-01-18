import 'package:dio/dio.dart';
import 'package:dualites/modules/landing/widgets/liked_widget.dart';
import 'package:dualites/shared/controller/video_list_controller.dart';
import 'package:dualites/shared/controller/video_list_provider.dart';
import 'package:dualites/shared/widgets/swipe_cards/tinder_swipe_cards.dart';
import 'package:dualites/shared/widgets/video_player/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class ViewReels extends StatefulWidget {
  @override
  ViewReelsState createState() => ViewReelsState();
}

class ViewReelsState extends State<ViewReels> {
  bool isActive = false;
  final VideoListController videoListController=Get.find();
  //  Use this to trigger swap. (i.e to swipe the card to left or right)
  CardController controller = CardController();
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: GetBuilder<VideoListController>(
            init: VideoListController(
                videoListProvider: VideoListProvider(dio: Dio())).getNextVideosList(),
            builder: (videoController) {
              return TinderSwapCard(
                // orientation where you want to show the stack
                orientation: AmassOrientation.RIGHT,
                // total number of cards
                totalNum: videoController.videosList.length,
                // from which index you want to show the card
                currentIndex: 0,
                // no of stacks you want to show in background
                stackNum: 0,
                // set the max and min width
                maxWidth: size.width,
                maxHeight: size.height,
                minWidth: size.width * 0.8,
                minHeight: size.height * 0.7,
                cardController: controller,
                // Restrict the stack from swiping downside if its false
                swipeDown: false,
                // Restrict the stack from swiping upside if its false
                swipeUp: true,
                swipeUpdateCallback:
                    (DragUpdateDetails details, Alignment align) {
                  if (align.x < 0) {
                    //  Card is LEFT swiping.
                  } else if (align.x > 0) {
                    //  Card is RIGHT swiping
                  }
                },
                swipeCompleteCallback:
                    (CardSwipeOrientation orientation, int index) {
                  // Get orientation & index of swiped card!
                  if ((index + 1) == videoController.videosList.length) {
                    setState(() {
                      isActive = true;
                    });
                  }
                },
                cardBuilder: (BuildContext context, int index) {
                  // Customize you card as per your need
                  return Stack(children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: PlayerWidget(
                        deviceOrientation: DeviceOrientation.portraitUp,
                        videoPlayerController: VideoPlayerController.network(
                            videoController.videosList[index].contentOne),
                        looping: false,
                        autoplay: true,
                      ),
                    ),
                    /*Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        children: [
                          LikeWidget(),
                          Text(""),
                          SizedBox(
                            height: 10.0,
                          ),
                          LikeWidget(),
                          Text(""),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ),*/
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  AssetImage("assets/images/author_image.jpg"),
                            ),
                            title: Text(
                              "JANE COOPER",
                              style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: 14.0,
                                  color: Colors.black),
                            ),
                            trailing:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              RaisedButton(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 0.0),
                                  color: Color(0xFF2D388A),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                  onPressed: () {},
                                  child: Center(
                                    child: Text(
                                      "Unsubscribe",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ))
                            ])))
                  ]);
                },
              );
            }));
  }
}
