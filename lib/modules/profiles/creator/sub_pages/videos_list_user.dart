import 'package:dualites/modules/authentication/authentication_controller.dart';
import 'package:dualites/modules/home/widgets/models/video_model.dart';
import 'package:dualites/modules/landing/landing_page.dart';
import 'package:dualites/modules/profiles/creator/widgets/confirm_widget.dart';
import 'package:dualites/shared/controller/video_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class VideosList extends StatelessWidget {
  final VideoListController videoListController = Get.find();
  final AuthenticationController authenticationController=Get.find();
  @override
  Widget build(BuildContext context) {
    videoListController.getVideosModel();
    return GetBuilder<VideoListController>(
    builder:(controller) {
      if (controller.isLoading) {
        return Center(
            child: Lottie.asset('assets/lotties/video_loader.json')
        );
      }
      else {
        if(controller.errorMessage!=""){
          return Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(controller.errorMessage),
            ],
          ),);
        }
        List<VideoModel> videos =
            videoListController.usersVideos;
        if (videos.isEmpty) {
          return Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("No Videos Found"),
            ],
          ),);
        }
        return ListView.builder(
          padding: const EdgeInsets.all(10.0),
          itemBuilder: (context, int index) {
            return Dismissible(
              key: Key(index.toString()),
              confirmDismiss: (DismissDirection dismissDirection) async {
                bool isDeleted = await showDialog(
                    context: context, builder: (context) {
                  return ConfirmWidget(
                    callBack: () {
                      videoListController.deleteVideoById(
                          videos[index].id, context);
                    },
                  );
                });
                return isDeleted;
              },
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              LandingPage(id: videos[index].id)));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                padding:const EdgeInsets.all(10.0),
                        child: Container(

                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.2,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.4,
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
                                  image:videos[index].thumbnail!=null && videos[index].thumbnail!=""
                                  ? NetworkImage(videos[index].thumbnail):
                                  AssetImage("assets/images/profile_video.jpg"))),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            videos[index].title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.0),
                          ),
                          Text(
                            "24-Aug-2021",
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            "Views Count : ${videos[index].views}",
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          itemCount: videos.length,
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
        );
      }
    });
  }
}
