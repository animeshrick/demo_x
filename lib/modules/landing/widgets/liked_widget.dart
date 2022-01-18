import 'package:dualites/modules/authentication/authentication_controller.dart';
import 'package:dualites/modules/home/widgets/models/video_model.dart';
import 'package:dualites/modules/landing/getx/video_load_state.dart';
import 'package:dualites/shared/constants/routes.dart';
import 'package:dualites/shared/controller/video_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LikeWidget extends StatelessWidget{
  final VideoModel videoModel;
  LikeWidget({this.videoModel});
  final VideoListController videoListController=Get.find();
  final AuthenticationController authenticationController=Get.find();
  @override
  Widget build(BuildContext context) {
    videoListController.initializeState();
    return Obx((){
      if(videoListController.state is VideoLikedState){
        bool isLiked=(videoListController.state as VideoLikedState).isLiked;
        return IconButton(icon: isLiked? Icon(Icons.favorite):Icon(Icons.favorite_border),
            onPressed: isLiked?null:(){
              authenticationController.userProfileModel != null
                  ? videoListController.likeVideo(videoModel.id)
                  : Navigator.pushReplacementNamed(
                  context, Routes.USER_LOGIN);
            });
      }
      bool isLiked=false;
      if(authenticationController.userProfileModel!=null)
        isLiked=videoModel.liked.contains(authenticationController.userProfileModel.id);
      return authenticationController.userProfileModel!=null
      ?IconButton(icon: isLiked? Icon(Icons.favorite):Icon(Icons.favorite_border), onPressed:
          isLiked?null:(){
            authenticationController.userProfileModel != null
                ? videoListController.likeVideo(videoModel.id)
                : Navigator.pushReplacementNamed(
                context, Routes.USER_LOGIN);
      }):Container();
    });
  }
}