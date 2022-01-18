import 'package:dualites/models/user_profile_model.dart';
import 'package:dualites/modules/landing/landing_page.dart';
import 'package:dualites/modules/widgets/widgets.dart';
import 'package:dualites/shared/constants/routes.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        centerTitle: true,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          ListTile(
            title: Text("User Home"),
            onTap: (){

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Widgets(index: 0,userProfileModel: new UserProfileModel(isCreator: false),)));
            },
          ),
          ListTile(
            title: Text("Creator Home"),
            onTap: () {

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Widgets(index: 0,userProfileModel: new UserProfileModel(isCreator: true))));
            },
          ),
          ListTile(
            title: Text("Video Details"),
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LandingPage()));
            }
          ),
          ListTile(
              title: Text("Creator Profile"),
              onTap: ()=>Navigator.pushNamed(context, Routes.CREATOR_PROFILE)
          ),
          ListTile(
              title: Text("User Profile"),
              onTap: ()=>Navigator.pushNamed(context, Routes.USER_PROFILE)
          ),
          ListTile(
              title: Text("User Signup"),
              onTap: ()=>Navigator.pushNamed(context, Routes.USER_SIGNUP)
          ),
          ListTile(
              title: Text("Creator Login Screen"),
              onTap: ()=>Navigator.pushNamed(context, Routes.LOGIN)
          ),
        ],
      ),
    );
  }
}