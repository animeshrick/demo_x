import 'package:dio/dio.dart';
import 'package:dualites/models/user_profile_model.dart';
import 'package:dualites/modules/reels/getx/reels_list_controller.dart';
import 'package:dualites/modules/reels/getx/reels_list_provider.dart';
import 'package:dualites/modules/reels/widgets/video_reels_list/video_reels_list.dart';
import 'package:dualites/modules/widgets/widgets.dart';
import 'package:dualites/shared/services/reels_model.dart';
import 'package:dualites/shared/widgets/loading/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ViewNewReels extends StatefulWidget {
  ViewNewReelsState createState()=>ViewNewReelsState();
}

class ViewNewReelsState extends State<ViewNewReels> with SingleTickerProviderStateMixin  {
  bool abo = false;
  bool foryou = true;
  bool play = true;

  @override
  void initState(){
    super.initState();
  }


  @override
  void dispose(){
    ReelsModel reelsModel=Get.find();
    reelsModel.disposeResources();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return SafeArea(
      top: true,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            homescreen(),
            footer(),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(onPressed: (){
                  setState(() {
                    abo = true;
                    foryou = false;
                  });
                }, child: Text('Abonnements', style:abo?TextStyle(color:Colors.white, fontWeight: FontWeight.bold, fontSize:18)
                    :TextStyle(color:Colors.white, fontSize:16))),
                Text('|', style:TextStyle(color:Colors.white, fontSize:5)),
                FlatButton(onPressed: (){
                  setState(() {
                    abo = false;
                    foryou = true;
                  });
                },child: Text('Pour Toi', style:foryou?TextStyle(color:Colors.white, fontWeight: FontWeight.bold, fontSize:18)
                    :TextStyle(color:Colors.white, fontSize:16))),
              ],)
          ],
        ),
      ),
    );
  }

  homescreen(){
    return GetBuilder<ReelsModel>(
        builder: (ReelsModel reelsListController) {
          return LoadingOverlay(
            isFormSaveOverlay: false,
            isLoading: reelsListController.isLoading ? true:false,
            child: VideoReelsList()
          );
        }
      );/*
    }else{
      _controller.play();
      return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(padding: EdgeInsets.only(bottom:14),
                      child:Text('Créateurs tendances', style: TextStyle(color:Colors.white, fontSize:20),))
                ],),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(child: Container(
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Text('Abonne-toi à un compte pour découvrir ses', style:TextStyle(color: Colors.white.withOpacity(0.8))),
                        ),
                        Center(
                          child: Text('dernières vidéos ici.', style:TextStyle(color: Colors.white.withOpacity(0.8))),
                        )
                      ],
                    ),
                  ),)
                ],),
              Container(
                height: 372,
                margin: EdgeInsets.only(top:25),
                child: PageView.builder(
                    dragStartBehavior: DragStartBehavior.down,
                    controller: pageController,
                    itemCount: 5,
                    itemBuilder: (context, position){
                      return videoSlider(position);
                    }),
              )
            ],)
      );
    }*/

  }

  footer(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Divider(
            color: Colors.white.withOpacity(0.5)
        ),
        Padding(padding: EdgeInsets.only(bottom:7),
            child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) =>
                            Widgets(index: 0,userProfileModel: new UserProfileModel(isCreator: true))));
                  },
                  child: Padding(padding: EdgeInsets.only(left:20, right:11),
                      child:Column(mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.home, color:Colors.white, size:30),
                          Text('Home', style:TextStyle(color: Colors.white, fontSize:10))
                        ],)),
                ),
                Padding(padding: EdgeInsets.only(left:20, right:3),
                    child:buttonplus()),
                InkWell(
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) =>
                            Widgets(index: 1,userProfileModel: new UserProfileModel(isCreator: true))));
                  },
                  child: Padding(padding: EdgeInsets.only(left:10, right:8),
                      child:Column(mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.search, color:Colors.white.withOpacity(0.8), size:30),
                          Text('Search', style:TextStyle(color: Colors.white.withOpacity(0.8), fontSize:10))
                        ],)),
                ),

              ],))
      ],
    );
  }

  buttonplus(){
    return Container(
      width: 46,
      height: 30,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.transparent
      ),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 28,
              height: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color(0x2dd3e7).withOpacity(1)
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 28,
              height: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color(0xed316a).withOpacity(1)
              ),
            ),
          ),
          Center(
            child: Container(
              width: 28,
              height: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white
              ),
              child: Center(child:Icon(Icons.add, color:Colors.black)),
            ),
          )
        ],
      ),
    );
  }
}