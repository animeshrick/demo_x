import 'package:dio/dio.dart';
import 'package:dualites/modules/home/widgets/models/video_list.dart';
import 'package:dualites/modules/home/widgets/models/video_model.dart';
import 'package:dualites/shared/library/api_request.dart';

class ReelsListProvider {
  Dio dio;
  ReelsListProvider({this.dio});
  void getVideosList(String url,{
    Function() beforeSend,
    Function(VideosList videosList) onSuccess,
    Function(dynamic error) onError,
  }) {
    ApiRequest(url: url, data: null).get(
      beforeSend: () => {if (beforeSend != null) beforeSend()},
      onSuccess: (data) {
        onSuccess(VideosList.fromMap(Map.from(data)));
      },
      onError: (error) => {if (onError != null) onError(error)},
    );
  }

  Future<dynamic> getReelsList(
      String url) async {
    try {
      Response response = await dio.get(
          url
      );
      return VideosList.fromMap(Map.from(response.data));
    } on DioError catch (e) {
      if(Map.from(e.response.data).containsKey("detail"))
        return Map.from(e.response.data)["detail"];
      else
        return "There was server error encountered";
    }
  }

  Future<dynamic> getVideoDetail(
      String url) async {
    try {
      Response response = await dio.get(
        url
      );
      return VideoModel.fromMap(response.data);
    } on DioError catch (e) {
      if(Map.from(e.response.data).containsKey("detail"))
        return Map.from(e.response.data)["detail"];
      else
        return "There was server error encountered";
    }
  }

  Future<dynamic> likeVideo(String url,String key)async{
    try {
      Response response = await dio.post(
          url,options: Options(
        headers: {
          "Authorization":"token $key"
        }
      )
      );
      return true;
    } on DioError catch (e) {
      return "There was server error encountered";
    }
  }

}