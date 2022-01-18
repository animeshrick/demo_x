import 'package:dualites/models/user_profile_model.dart';
import 'package:dualites/modules/authentication/authentication_controller.dart';
import 'package:dualites/modules/landing/widgets/person_follow.dart';
import 'package:dualites/modules/profiles/creator/sub_pages/creator_profile_settings.dart';
import 'package:dualites/modules/profiles/creator/sub_pages/invite_page/invite_page.dart';
import 'package:dualites/modules/profiles/widgets/user_info_widget.dart';
import 'package:dualites/modules/profiles/creator/sub_pages/videos_list_user.dart';
import 'package:dualites/modules/upload/pages/double_selection.dart';
import 'package:dualites/modules/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreatorProfilePage extends StatelessWidget {
  final AuthenticationController authenticationController = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthenticationController>(
        builder: (AuthenticationController authenticationController) {
      return SafeArea(
        top: false,
        child: Scaffold(
          body: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: authenticationController
                                          .userProfileModel.avatar ==
                                      null
                                  ? AssetImage("assets/images/author_image.jpg")
                                  : NetworkImage(authenticationController
                                      .userProfileModel.avatar))),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.07,
                      left: MediaQuery.of(context).size.width * 0.01,
                      right: MediaQuery.of(context).size.width * 0.01,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    // ### Add the next 2 lines ###
                                    final permitted =
                                        await PhotoManager.requestPermission();
                                    if (!permitted) return;
                                    // ######
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              DoubleSelectionPage()),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF00AEEF),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CreatorProfileSettingsPage()));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF00AEEF),
                                    ),
                                    child: Icon(
                                      Icons.settings,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          UserInfoWidget(),
                          Expanded(
                            child: Column(
                              children:[ PersonFollowWidget(userProfileModel: authenticationController.userProfileModel),

                                SizedBox(
                                  height: 20.0,
                                ),
                                InkWell(
                                  onTap: ()async{
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                InvitePage()));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF00AEEF),
                                    ),
                                    child: Icon(
                                      Icons.mail,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                InkWell(
                                  onTap: ()async{
                                    authenticationController.userProfileModel=null;
                                    SharedPreferences preferences=await SharedPreferences.getInstance();
                                    preferences.remove("key");
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Widgets(
                                                  userProfileModel: new UserProfileModel(isCreator: false),
                                                  index: 0,
                                                )));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF00AEEF),
                                    ),
                                    child: Icon(
                                      Icons.logout,
                                      color: Colors.white,
                                    ),
                                  ),
                                )]
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.01,
                color: Color(0xFF00AEEF),
              ),
              Expanded(child: VideosList())
            ],
          ),
        ),
      );
    });
  }
}
