import 'package:dualites/modules/authentication/authentication_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Subscriptions extends StatelessWidget {
  final AuthenticationController authenticationController=Get.find();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top:true,
      child: Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(children: [
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF2D388A),
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        "Subscriptions",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                      SizedBox(),
                    ],
                  )),
              ListView.builder(physics: BouncingScrollPhysics(),shrinkWrap:true,itemBuilder: (context,int index){
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListTile(
                    
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(
                          "assets/images/author_image.jpg"
                      ),
                    ),
                    title: Text(authenticationController.userProfileModel.name,style: TextStyle(fontFamily: "Montserrat",
                        letterSpacing: 3.0,
                        fontSize: 16.0,
                        color: Colors.black),),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RaisedButton(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 0.0),
                          color:  Color(0xFF2D388A),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                          onPressed: (){},
                          child: Center(child: Text("Unsubscribe",style: TextStyle(color: Colors.white),),),
                        ),
                      ],
                    ),
                  ),
                );
              },itemCount: 4,)
            ])),
      ),
    );
  }
}
