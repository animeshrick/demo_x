import 'package:dualites/models/user_profile_model.dart';
import 'package:dualites/modules/authentication/authentication_controller.dart';
import 'package:dualites/modules/home/index.dart';
import 'package:dualites/modules/home/user_home/user_home.dart';
import 'package:dualites/modules/reels/view/view_reels_new.dart';
import 'package:dualites/modules/search/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class Widgets extends StatefulWidget {
  int index;
  final UserProfileModel userProfileModel;
  Widgets({this.index = 0,this.userProfileModel});
  _widgetsPageState createState() => _widgetsPageState();
}

class _widgetsPageState extends State<Widgets> {
  bool userPageDragging = false;
  int curIndex = 0;
  AuthenticationController authenticationController=Get.find();
  void initState() {
    super.initState();
    if (widget.index != 0) curIndex = widget.index;

  }
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      widget.userProfileModel.isCreator ? HomePage():UserHomePage(),
      SearchPage(),
      ViewNewReels()
    ];
    return WillPopScope(

      onWillPop: ()async=>false,
      child: Scaffold(
        body: widgets[curIndex],

        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          onTap: (int index) {
            if(index==2){

              Navigator.push(
                    context,  MaterialPageRoute(
                  builder: (context) =>
                      ViewNewReels()));

            }else{
              setState(() {
                curIndex = index;
              });
            }

          },
          currentIndex: curIndex, // this will be set when a new tab is tapped
          items: [
            bottomItemOlder("Home", 0,
                Icons.home_outlined),
            bottomItemOlder("Search", 1,
                Icons.search),
            bottomItemOlder("Reels", 2,
                Icons.video_collection)
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem bottomItemOlder(
      String title, int index, IconData icon) {
    return BottomNavigationBarItem(
        icon:
        Icon(icon, color: curIndex == index ? Color(0xFF2D388A) : Colors.black),
        title: Text(title,
            style: TextStyle(
                color: curIndex == index ? Color(0xFF2D388A) : Colors.black54,
                fontSize: 16.0)));
  }
}
