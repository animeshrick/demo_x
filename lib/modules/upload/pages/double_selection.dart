
import 'package:dio/dio.dart';
import 'package:dualites/modules/upload/getx/gallery_controller.dart';
import 'package:dualites/modules/upload/getx/gallery_provider.dart';
import 'package:dualites/modules/upload/pages/widgets/asset_thumbnail/asset_thumbnail.dart';
import 'package:dualites/modules/upload/pages/widgets/video_screen/video_screen.dart';
import 'package:dualites/shared/widgets/loading/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
BaseOptions baseOptions=BaseOptions(
    receiveTimeout: 0
);
class DoubleSelectionPage extends StatelessWidget{

  GalleryController galleryController=Get.put(GalleryController(new GalleryProvider(Dio(baseOptions))));
  @override
  Widget build(BuildContext context) {
    galleryController.selectedAssets=[];
    return Scaffold(
      appBar: AppBar(
        title: Text("Videos"),
      ),
      body: GetBuilder<GalleryController>(
        builder: (controller){
          return LoadingOverlay(isLoading: controller.isLoading,
          child: controller.errorMessage!=null?
          Center(child: Text(controller.errorMessage),):AnimationLimiter(
          child:Column(
            children: [
              Expanded(child: VideoScreen()),
              Expanded(
                child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3
                ), itemBuilder: (context,int index){
                  return AssetThumbnail(asset: controller.galleryAssets[index]);
                },itemCount: controller.galleryAssets.length,),
              ),
            ],
          )));
        }
      ),
    );
  }
}