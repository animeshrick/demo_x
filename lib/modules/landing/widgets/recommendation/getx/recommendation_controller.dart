import 'package:dualites/modules/home/widgets/models/video_list.dart';
import 'package:dualites/modules/home/widgets/models/video_model.dart';
import 'package:dualites/modules/landing/widgets/recommendation/getx/recommendation_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecommendationController extends GetxController{
  List<VideoModel> videosList = [];
  bool isLoading = true;
  String errorMessage;
  String nextUrl='https://dualite.xyz/api/v1/videos/recommended/';
  RecommendationProvider recommendationProvider;
  RecommendationController({this.recommendationProvider});
  @override
  void onInit() {
    getVideosModel();
    super.onInit();
  }


  void getVideosModel()async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    String key =preferences.getString("key");
    final dynamic response =
      await recommendationProvider.getRecommendedVideos(
          "https://dualite.xyz/api/v1/videos/recommended/",key);
      if(response is VideosList){
        nextUrl=response.next;
        videosList.addAll(response.results);
        isLoading=false;
        update();
      }
      else{
        isLoading=false;
        errorMessage=response;
        update();
      }

  }
}