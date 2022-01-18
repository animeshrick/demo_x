import 'package:dio/dio.dart';
import 'package:dualites/modules/home/widgets/models/video_model.dart';
import 'package:dualites/modules/landing/widgets/recommendation/getx/recommendation_controller.dart';
import 'package:dualites/modules/landing/widgets/recommendation/getx/recommendation_service.dart';
import 'package:dualites/shared/widgets/loading/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Recommendations extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: RecommendationController(recommendationProvider: RecommendationProvider(
          dio: Dio())),
        builder: (RecommendationController recommendationController){
        return LoadingOverlay(
          isLoading: recommendationController.isLoading ? true:false,
          isFormSaveOverlay: false,
          child: recommendationController.errorMessage!=null ? Center(child: Text(
            recommendationController.errorMessage
          ),):ListView.builder(
            itemBuilder: (context, int index) {
              VideoModel videoModel=recommendationController.videosList[index];
              return Column(
                children: [
                  videoModel.thumbnail==null ? Container(
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: BoxDecoration(
              image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/video.jpg"))),
              )
              :Container(
                    width: MediaQuery.of(context).size.width,
                    padding:const EdgeInsets.all(20.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                offset: Offset(5.0, 5.0),
                                blurRadius: 10.0)
                          ],
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(videoModel.thumbnail)
                          )
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(videoModel.title,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0))
                    ],
                  )
                ],
              );
            },
            physics: BouncingScrollPhysics(),
            itemCount: recommendationController.videosList.length,
            shrinkWrap: true,
          )
        );
    });
  }
}