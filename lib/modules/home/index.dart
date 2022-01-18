import 'package:dualites/modules/authentication/authentication_controller.dart';
import 'package:dualites/modules/home/widgets/category_list.dart';
import 'package:dualites/modules/home/widgets/videos_list.dart';
import 'package:dualites/modules/profiles/creator/creator_profile.dart';
import 'package:dualites/shared/constants/routes.dart';
import 'package:dualites/shared/controller/video_list_controller.dart';
import 'package:dualites/shared/widgets/clipper/clipper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
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
    return WillPopScope(

      child: SafeArea(
        top: true,
        child: Scaffold(
            body: Column(children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Stack(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white),
                ClipPath(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.3,
                    color: Colors.black,
                  ),
                  clipper: CustomClipPath(),
                ),
                /*Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/home_bg.jpg"))),
                ),

                */Positioned(
                  top: MediaQuery.of(context).size.height * 0.10,
                  left: MediaQuery.of(context).size.width * 0.20,
                  right: MediaQuery.of(context).size.width * 0.20,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          authenticationController.userProfileModel != null
                              ? Navigator.push(
                              context, MaterialPageRoute(
                              builder: (context) =>
                                  CreatorProfilePage()))
                              : Navigator.pushReplacementNamed(
                              context, Routes.USER_LOGIN);
                        },
                        child: CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/avatar_image.jpg"),
                          radius: 30.0,
                        ),
                      ),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            authenticationController.userProfileModel.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.white,fontSize: 20.0),
                          ),
                          Text(
                            "Creator",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      )),
                    ],
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.20,
                  left: MediaQuery.of(context).size.width * 0.20,
                  right: MediaQuery.of(context).size.width * 0.20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "199",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          Text(
                            "followers",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      )),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "199",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          Text(
                            "following",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      )),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "199",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          Text(
                            "posts",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      )),
                    ],
                  ),
                )
              ],
            ),
          ),
          CategoryListWidget(),
              VideosListWidget(scrollController: _scrollController,)
        ])),
      ),
    );
  }
}
