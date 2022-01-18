import 'package:dio/dio.dart';
import 'package:dualites/modules/authentication/authentication_controller.dart';
import 'package:dualites/modules/authentication/authentication_service.dart';
import 'package:dualites/modules/home/widgets/models/video_model.dart';
import 'package:dualites/modules/landing/landing_page.dart';
import 'package:dualites/shared/constants/routes.dart';
import 'package:dualites/shared/controller/video_list_controller.dart';
import 'package:dualites/shared/controller/video_list_provider.dart';
import 'package:dualites/shared/widgets/animate_list/animate_list.dart';
import 'package:dualites/shared/widgets/loading/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class VideosListWidget extends StatelessWidget{
  final ScrollController scrollController;
  final String categoryId;
  VideosListWidget({this.scrollController,this.categoryId});
  final VideoListController videoListController=Get.find();

  final AuthenticationController authenticationController=Get.put(AuthenticationController(AuthenticationService(Dio())));
  Widget build(BuildContext context) {
    return Expanded(
        flex: 3,
        child: GetBuilder<VideoListController>(
            builder: (controller){
              return LoadingOverlay(
                isLoading: controller.isLoading,
                child: AnimationLimiter(
                  child: ListView.builder(
                    controller: scrollController,
                    //physics: BouncingScrollPhysics(),
                    itemBuilder: (context, int index) {
                      if(index==controller.videosList.length-1 && controller.nextLoading){
                        return Center(
                          child: Lottie.asset('assets/lotties/video_loader.json'),
                        );
                      }
                      VideoModel videoModel=controller.videosList[index];
                      return AnimateList(index:index,widget:InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LandingPage(id: videoModel.id,)));

                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                videoModel.thumbnail==null ?
                                Container(
                                  padding:const EdgeInsets.all(10.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: Container(
                                    height: MediaQuery.of(context).size.height * 0.2,
                                    width: MediaQuery.of(context).size.width,
                                    child:Image.asset("assets/images/home_girl.jpg",fit: BoxFit.cover,),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey,
                                            offset: Offset(5.0, 5.0),
                                            blurRadius: 10.0)
                                      ],
                                    ),
                                  ),
                                ):Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding:const EdgeInsets.all(10.0),
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
                                Container(
                                  padding:const EdgeInsets.symmetric(horizontal:50.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        videoModel.title,
                                        style: TextStyle(
                                            color: Colors.black,fontFamily:"Montserrat", fontWeight: FontWeight.bold,fontSize: 20.0),
                                      ),
                                      Expanded(child: SizedBox()),
                                      PopupMenuButton(
                                        itemBuilder: (BuildContext context) {
                                          return {'1', '2'}.map((String choice) {
                                            return PopupMenuItem<String>(
                                              value: choice,
                                              child: Text(choice),
                                            );
                                          }).toList();
                                        },
                                      )
                                    ],
                                  ),
                                ),

                                Container(
                                  padding:const EdgeInsets.symmetric(horizontal:50.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 5.0),
                                        child:  CircleAvatar(
                                          backgroundImage: AssetImage(
                                              "assets/images/author_image.jpg"),
                                        )
                                      ),
                                      Text(videoModel.authorName!=null ?videoModel.authorName:"Author Name",style: TextStyle(color: Colors.black,fontSize: 12.0),),
                                      Expanded(child: SizedBox()),
                                      Text("242 Views",style: TextStyle(color: Colors.grey,fontSize: 12.0),),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ));
                    },
                    itemCount: controller.videosList.length,
                    shrinkWrap: true,
                    //padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                  ),
                )
              );
            },
          ),
        );
  }
}