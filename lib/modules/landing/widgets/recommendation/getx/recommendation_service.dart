import 'package:dio/dio.dart';
import 'package:dualites/modules/home/widgets/models/video_list.dart';

class RecommendationProvider {
  Dio dio;
  RecommendationProvider({this.dio});

  Future<dynamic> getRecommendedVideos(
      String url,String key) async {
    try {
      Response response = await dio.get(
          url,options: Options(
          headers: {
            "Authorization":"token $key"
          }
      )
      );
      return VideosList.fromMap(Map.from(response.data));
    } on DioError catch (e) {
      if(Map.from(e.response.data).containsKey("detail"))
        return Map.from(e.response.data)["detail"];
      else
        return "There was server error encountered";
    }
  }
}