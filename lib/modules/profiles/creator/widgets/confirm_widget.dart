import 'package:dualites/modules/landing/getx/video_load_state.dart';
import 'package:dualites/shared/controller/video_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmWidget extends StatelessWidget{
  Function callBack;
  ConfirmWidget({this.callBack});
  @override
  Widget build(BuildContext context) {
    final VideoListController videoListController=Get.find();
    videoListController.updateState();
    return Obx(() {
      if(videoListController.state is VideoDeletedInProgressState){
        return AlertDialog(
          title: Text("Confirmation"),
          content: Container(
            height: MediaQuery.of(context).size.height*0.1,
            child: Center(
              child: Text("Are You Sure You want to delete the Video"),),
          ),
          actions: [
            FlatButton(onPressed:null, child: Center(child: Text("Processing"),)),

          ],
        );
      }
      return AlertDialog(
        title: Text("Confirmation"),
        content: Container(
          height: MediaQuery.of(context).size.height*0.1,
          child: Center(
            child: Text("Are You Sure You want to delete the Video"),),
        ),
        actions: [
          FlatButton(onPressed: () {
            callBack();
          }, child: Center(child: Text("Yes"),)),
          FlatButton(onPressed: () {
            Navigator.pop(context);
          }, child: Center(child: Text("No"),))
        ],
      );
    });
  }
}