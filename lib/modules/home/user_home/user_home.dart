import 'package:dualites/modules/authentication/authentication_controller.dart';
import 'package:dualites/modules/home/widgets/category_list.dart';
import 'package:dualites/modules/home/widgets/videos_list.dart';
import 'package:dualites/modules/profiles/user/user_profile.dart';
import 'package:dualites/modules/widgets/widgets.dart';
import 'package:dualites/shared/constants/routes.dart';
import 'package:dualites/shared/controller/video_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserHomePage extends StatefulWidget {
  UserHomePageState createState() => UserHomePageState();
}

class UserHomePageState extends State<UserHomePage> {
  ScrollController _scrollController = new ScrollController();
  AuthenticationController authenticationController = Get.find();
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        VideoListController controller = Get.find();
        if (controller.nextUrl != null) controller.getNextVideosList();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
          body: Column(children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.1140,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage("assets/images/user_bg.jpg"))),
              ),
              Positioned(
                  left: 10,
                  right: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/images/logo.png",
                        width: 100.0,
                        height: 100.0,
                      ),
                      InkWell(
                          onTap: () async {
                            authenticationController.userProfileModel != null
                                ? Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserProfilePage()))
                                : Navigator.pushReplacementNamed(
                                    context, Routes.USER_LOGIN);
                          },
                          child: CircleAvatar(
                            backgroundImage:
                                AssetImage (authenticationController.userProfileModel==null || authenticationController.userProfileModel.avatar==null ||
                                    authenticationController.userProfileModel.avatar=="" ?
                                    "assets/images/avatar_image.jpg":authenticationController.userProfileModel.avatar),
                            radius: 30.0,
                          )),
                    ],
                  ))
            ],
          ),
        ),
        CategoryListWidget(scrollController: _scrollController,),
        VideosListWidget(
          scrollController: _scrollController,
        )
      ])),
    );
  }
}
