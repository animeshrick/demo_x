import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dualites/models/user_profile_model.dart';
import 'package:dualites/modules/authentication/authentication_controller.dart';
import 'package:dualites/modules/authentication/authentication_service.dart';
import 'package:dualites/modules/landing/landing_page.dart';
import 'package:dualites/modules/widgets/widgets.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    //handleDynamicLinks();
    Timer(Duration(seconds: 2), () async {
      AuthenticationController authenticationController = Get.put(
          AuthenticationController(new AuthenticationService(Dio())));
      SharedPreferences preferences=await SharedPreferences.getInstance();
      if(preferences.containsKey("key")){
        final dynamic response =
        await authenticationController.getUserProfile(preferences.getString("key"));
        if (response is UserProfileModel) {
          authenticationController.userProfileModel=response;
          Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Widgets(
                      userProfileModel: response,
                      index: 0,
                    )));

        }
      }else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Widgets(
                      userProfileModel: new UserProfileModel(isCreator: false),
                      index: 0,
                    )));
      }
    });
  }

  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Expanded(flex:2,child: SizedBox(),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(flex: 2,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text("Dualite"),
                    ),),

                  ],
                ),
                Expanded(
                  child: Text(
                    "DUALITE is a platform  to create interactive  content",
                    style: TextStyle(color: Colors.black, fontSize: 18.0),
                  ),
                ),
                SizedBox(height: 10.0,),
                Expanded(child: Text("What do you mean by  Interactive content?",style: TextStyle(color: Colors.black, fontSize: 18.0))),
                SizedBox(height: 10.0,),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width,
                      child:Image.asset("assets/images/home_girl.jpg"),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Expanded(flex:2,child: SizedBox(),),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future handleDynamicLinks() async {
    // 1. Get the initial dynamic link if the app is opened with a dynamic link
    final PendingDynamicLinkData data =
    await FirebaseDynamicLinks.instance.getInitialLink();

    // 3. Register a link callback to fire if the app is opened up from the background
    // using a dynamic link.
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          // 3a. handle link that has been retrieved
          _handleDeepLink(dynamicLink);
        }, onError: (OnLinkErrorException e) async {
      print('Link Failed: ${e.message}');
    });
  }

  void _handleDeepLink(PendingDynamicLinkData data) {
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      print('_handleDeepLink | deeplink: $deepLink');

      // Check if we want to make a post
      var isPost = deepLink.pathSegments.contains('video');

      if (isPost) {
        // get the title of the post
        var videoId = deepLink.queryParameters['id'];

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LandingPage(id: int.parse(videoId))),
        );
      }
    }
  }
}
