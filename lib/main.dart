import 'package:dio/dio.dart';
import 'package:dualites/modules/authentication/authentication_controller.dart';
import 'package:dualites/modules/dashboard/dashboard.dart';
import 'package:dualites/modules/login/login.dart';
import 'package:dualites/modules/login/profile_updation.dart';
import 'package:dualites/modules/login/user/signin/sign_in.dart';
import 'package:dualites/modules/login/user/signup/sign_up.dart';
import 'package:dualites/modules/login/user/welcome_home/welcome_home.dart';
import 'package:dualites/modules/login/user/welcome_next/welcome_next.dart';
import 'package:dualites/modules/profiles/user/pages/notifications/notifications.dart';
import 'package:dualites/modules/profiles/user/pages/subscriptions/liked_videos.dart';
import 'package:dualites/modules/profiles/user/pages/subscriptions/subscriptions.dart';
import 'package:dualites/modules/splash/index.dart';
import 'package:dualites/modules/widgets/widgets.dart';
import 'package:dualites/shared/constants/constants.dart';
import 'package:dualites/shared/constants/routes.dart';
import 'package:dualites/shared/controller/video_list_controller.dart';
import 'package:dualites/shared/controller/video_list_provider.dart';
import 'package:dualites/shared/services/reels_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Dio dio=Dio();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFF2D388A), statusBarBrightness: Brightness.light));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());

}

class MyApp extends GetWidget<AuthenticationController> {
  // This widget is the root of your application.
  final ReelsModel reelsModel=Get.put(ReelsModel());
  final VideoListController videoListController=Get.put(VideoListController(videoListProvider: new VideoListProvider(dio: Dio())));
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.APP_NAME,
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        Routes.HOME:(context)=>Widgets(index: 0,),
        Routes.USER_HOME:(context)=>Widgets(index: 0,),
        Routes.SPLASH_HOME:(context)=>SplashPage(),
        Routes.CREATOR_PROFILE:(context)=>Widgets(index: 3),
        Routes.USER_PROFILE:(context)=>Widgets(index: 2),
        Routes.USER_LOGIN:(context)=>UserSignInPage(),
        Routes.USER_SIGNUP:(context)=>UserSignUpPage(),
        Routes.USER_WELCOME_NEXT:(context)=>WelcomeNextPage(),
        Routes.USER_WELCOME_HOME:(context)=>WelcomeHomePage(),
        Routes.DASHBOARD:(context)=>DashboardPage(),
        Routes.LOGIN:(context)=>LoginPage(),
        Routes.PROFILE_UPDATION:(context)=>ProfileUpdationPage(),
        Routes.LIKED_VIDEOS:(context)=>LikedVideos(),
        Routes.SUBSCRIPTIONS_LIST:(context)=>Subscriptions(),
        Routes.NOTIFICATIONS_LIST:(context)=>Notifications()
      },
      initialRoute: Routes.SPLASH_HOME,
    );
  }
}