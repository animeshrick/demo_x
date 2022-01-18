import 'package:dualites/modules/authentication/authentication_controller.dart';
import 'package:dualites/modules/upload/pages/double_selection.dart';
import 'package:dualites/shared/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class UserInfoWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthenticationController>(
      builder: (AuthenticationController authenticationController) {
        return Column(
          children: [
            authenticationController.userProfileModel.avatar==null ?CircleAvatar(
              backgroundImage: AssetImage("assets/images/author_image.jpg"),
              radius: 70,
            ):
            CircleAvatar(
              backgroundImage: NetworkImage(authenticationController.userProfileModel.avatar),
              radius: 70,
            ),
            SizedBox(height: 10.0,),
            Text(authenticationController.userProfileModel.name,
              style: TextStyle(fontFamily: "Montserrat",
                  letterSpacing: 3.0,
                  fontSize: 26.0,
                  color: Colors.white),),
            SizedBox(
              height: 10.0,
            ),
            InkWell(
              onTap: ()=>Navigator.pushReplacementNamed(context, Routes.PROFILE_UPDATION),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xFF00AEEF)
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 50.0, vertical: 5.0),
                child: Center(
                  child: Text("Edit Profile", style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),),
                ),
              ),
            )
          ],
        );
      }
    );
  }
}