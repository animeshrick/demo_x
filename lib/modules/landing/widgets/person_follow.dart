import 'package:dualites/models/user_profile_model.dart';
import 'package:dualites/modules/authentication/authentication_controller.dart';
import 'package:dualites/modules/landing/getx/video_load_state.dart';
import 'package:dualites/modules/login/getx/login_controller.dart';
import 'package:dualites/modules/login/getx/login_state.dart';
import 'package:dualites/shared/constants/routes.dart';
import 'package:dualites/shared/controller/video_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonFollowWidget extends StatelessWidget{
  final UserProfileModel userProfileModel;
  PersonFollowWidget({this.userProfileModel});
  final LoginController loginController=Get.put(LoginController());
  final AuthenticationController authenticationController=Get.find();
  @override
  Widget build(BuildContext context) {

    return Obx((){
      if(loginController.state is FollowedProfileState){
      bool isFollowed=(loginController.state as FollowedProfileState).isFollowed;
        return InkWell(
          onTap: isFollowed?null:(){
            authenticationController.userProfileModel != null
                ?  loginController.followProfile(userProfileModel.id)
                : Navigator.pushReplacementNamed(
                context, Routes.USER_LOGIN);
          },
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF00AEEF),
            ),
            child: isFollowed ?Icon(Icons.person,color: Colors.white,):Icon(Icons.person_add_alt,color: Colors.white,),
              ),
        );
      }
      bool isLiked=false;
      if(authenticationController.userProfileModel!=null)
        isLiked=userProfileModel.following.contains(authenticationController.userProfileModel.id);
      return InkWell(
        onTap: isLiked ?null:(){
          authenticationController.userProfileModel != null
              ?  loginController.followProfile(userProfileModel.id)
              : Navigator.pushReplacementNamed(
              context, Routes.USER_LOGIN);
        },
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF00AEEF),
          ),
          child: isLiked ?Icon(Icons.person,color: Colors.white,):Icon(Icons.person_add_alt,color: Colors.white,),
        ),
      );
    });
  }
}