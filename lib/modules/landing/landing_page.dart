import 'package:dualites/modules/authentication/authentication_controller.dart';
import 'package:dualites/modules/landing/widgets/person_follow.dart';
import 'package:dualites/modules/landing/widgets/recommendation/widgets/recommendations.dart';
import 'package:dualites/shared/controller/video_list_controller.dart';
import 'package:dualites/shared/widgets/video_player/switch_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import './widgets/liked_widget.dart';
class LandingPage extends StatelessWidget {
  int id;
  LandingPage({this.id});
  final VideoListController videoListController = Get.find();
  final AuthenticationController authenticationController=Get.find();
  @override
  Widget build(BuildContext context) {
    videoListController.getVideoInfoById(id);
    return GetBuilder<VideoListController>(builder: (controller) {
      if(controller.isLoading){
        return Center(
          child: Lottie.asset('assets/lotties/video_loader.json'),
        );
      }
      return SafeArea(
        top: true,
        child: Scaffold(
          body: AnimationLimiter(
            child: Column(
                children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: [
                videoListController.videoModel.thumbnail==null ?
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SwitchVideoPlayer(videoModel: videoListController.videoModel
                                )));
                    //videoListController.startPlayingVideo(context);
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/video.jpg"))),
                  ),
                ):GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SwitchVideoPlayer(videoModel: videoListController.videoModel
                                )));
                  },
                  child:Container(
                    width: MediaQuery.of(context).size.width,
                    padding:const EdgeInsets.all(20.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                offset: Offset(5.0, 5.0),
                                blurRadius: 10.0)
                          ],
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(videoListController.videoModel.thumbnail)
                          )
                      ),
                    ),
                  )
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            videoListController.videoModel.title,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                          Expanded(child: SizedBox()),
                          IconButton(
                            icon: Icon(Icons.arrow_drop_down),
                            onPressed: () {},
                            color: Colors.black,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${videoListController.videoModel.views} views",
                            style:
                                TextStyle(color: Colors.grey, fontSize: 12.0),
                          ),
                          Text(
                            "May 16th,2020",
                            style:
                                TextStyle(color: Colors.grey, fontSize: 12.0),
                          ),

                          LikeWidget(videoModel:videoListController.videoModel)
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          videoListController.videoModel.authorAvatar != null
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      videoListController
                                          .videoModel.authorAvatar),
                                )
                              : CircleAvatar(
                                  backgroundImage: AssetImage(
                                      "assets/images/author_image.jpg"),
                                ),
                          videoListController.videoModel.authorName != null
                              ? Text(
                                  videoListController.videoModel.authorName,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                )
                              : Text(
                                  "Author Name",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                          PersonFollowWidget(userProfileModel: authenticationController.userProfileModel)
                        ],
                      ),
                    ]),
                  ),
                ),
                Container(
                    height: MediaQuery.of(context).size.height * 0.45,
                    child:
                        ListView(physics: BouncingScrollPhysics(), children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 5.0),
                            child: Text(
                              "Suggestions",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                          ),
                        ],
                      ),
                          authenticationController.userProfileModel!=null ?Recommendations():Center(
                            child: Text("Please Login to see Recommendations List"),
                          )
                    ]))
              ],
            )),
          ),
        ),
      );
    });
  }
}
