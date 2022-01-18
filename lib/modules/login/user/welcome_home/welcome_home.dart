import 'package:dualites/modules/authentication/authentication_controller.dart';
import 'package:dualites/modules/widgets/widgets.dart';
import 'package:dualites/shared/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeHomePage extends StatelessWidget{
  final bool isCreator;
  WelcomeHomePage({this.isCreator=true});
  AuthenticationController controller=Get.find();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 50.0,),
                Image.asset("assets/images/logo.png"),
                Expanded(child: SizedBox()),
                Text("Welcome",style: TextStyle(fontStyle: FontStyle.italic,color: Colors.white,fontSize: 26.0),),
                Text("Rohan",style: TextStyle(fontStyle: FontStyle.italic,color: Colors.white,fontSize: 26.0),),
                Expanded(child: SizedBox()),
                Container(
                  width: MediaQuery.of(context).size.width*0.9,
                  child: RaisedButton(onPressed: (){
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>Widgets(
                              userProfileModel:
                              controller.userProfileModel,
                              index: 0,
                            )));
                    isCreator ? Navigator.pushReplacementNamed(context, Routes.HOME):Navigator.pushReplacementNamed(context, Routes.USER_HOME);
                  },shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),color:Colors.white,child: Center(child: Text("HOME SCREEN",style: TextStyle(color: Colors.red),),),),
                ),
                Expanded(child: SizedBox()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}