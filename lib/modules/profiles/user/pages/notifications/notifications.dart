import 'package:dualites/modules/authentication/authentication_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Notifications extends StatelessWidget {
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
                        "Notifications",
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
                    title: Text("JANE COOPER followed you",style: TextStyle(fontFamily: "Montserrat",
                        fontSize: 14.0,
                        color: Colors.black),),

                    ),

                );
              },itemCount: 4,)
            ])),
      ),
    );
  }
}
