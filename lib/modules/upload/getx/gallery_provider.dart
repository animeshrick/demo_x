import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dualites/modules/home/widgets/models/video_model.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GalleryProvider{
  Dio dio;
  GalleryProvider(this.dio);
  Future<List<AssetEntity>> loadGalleryAssets()async{
    final albums = await PhotoManager.getAssetPathList(onlyAll: true);
    if(albums.isEmpty)
      return [];
    else {
      final recentAlbum = albums.first;

      // Now that we got the album, fetch all the assets it contains
      final recentAssets = await recentAlbum.getAssetListRange(
        start: 0, // start at index 0
        end: 1000000, // end at a very big index (to get all the assets)
      );

      return recentAssets.where((element) => element.type == AssetType.video)
          .toList();
    }
  }

  Future<dynamic> postVideoContent(
      String url,String title,String description,String type,String tags,String thumbnailUrl) async {
    try {
      SharedPreferences preferences=await SharedPreferences.getInstance();
      String authKey=preferences.getString("key");
      var formData = {
        "title":title,
        "description":description,
        "type":type,
        "tags":tags==null || tags=="" ?["Movies","Video"] :[tags],
        "thumbnail_url":thumbnailUrl
      };
      var response = await dio.post(url,data: formData,options:Options(
        contentType: "application/json",
        headers: {
          "Authorization": "token $authKey"
        }
      ));
      return VideoModel.fromMap(response.data);
    } on DioError catch (e) {
      if (DioErrorType.RECEIVE_TIMEOUT == e.type ||
          DioErrorType.CONNECT_TIMEOUT == e.type) {
        return "Server is not reachable. Please verify your internet connection and try again";
      } else if (DioErrorType.RESPONSE == e.type) {
        if(Map.from(e.response.data).containsKey("detail"))
          return Map.from(e.response.data)["detail"];
        else
          return "There was some other client error";
      } else if (DioErrorType.DEFAULT == e.type) {
        if (e.message.contains('SocketException')) {
          return "There was socket issue from server side encountered";
        }
      } else {
        return "There was some issue observed on server side";
      }

    }
  }


  Future<Map<bool,String>> postThumbnailFile(
      String url,File thumbnail) async {
    Map<bool,String> postVideoFileResponse={};
    try {
      SharedPreferences preferences=await SharedPreferences.getInstance();
      String authKey=preferences.getString("key");
      String thumbnailImagePath = thumbnail.path.split('/').last;
      var formData = new FormData.fromMap({
        "thumbnail":await MultipartFile.fromFile(thumbnail.path,filename: thumbnailImagePath)
      });
      var response = await dio.post(url,data: formData,options:Options(
          contentType: 'multipart/form-data',
          headers: {
            "Authorization": "token $authKey"
          }
      ));
      postVideoFileResponse={true:response.data["thumbnail"]};
    } on DioError catch (e) {
      if (DioErrorType.RECEIVE_TIMEOUT == e.type ||
          DioErrorType.CONNECT_TIMEOUT == e.type) {
        postVideoFileResponse={false:"Server is not reachable. Please verify your internet connection and try again"};

      } else if (DioErrorType.RESPONSE == e.type) {
        postVideoFileResponse={false:"Server responded with wrong error code"};
      } else if (DioErrorType.DEFAULT == e.type) {
        if (e.message.contains('SocketException')) {
          postVideoFileResponse={false:"There was socket issue from server side encountered"};
        }
        else {
          postVideoFileResponse={false:"There was some issue observed on server side"};
        }
      } else {
        postVideoFileResponse={false:"There was some issue observed on server side"};
      }

    }
    return Future.value(postVideoFileResponse);
  }

  Future<dynamic> postVideoFiles(
      String url,File file1) async {
    Map<bool,String> postVideoFileResponse={};
    try {
      SharedPreferences preferences=await SharedPreferences.getInstance();
      Uint8List video = File(file1.path).readAsBytesSync();

      Options options = Options(
          contentType: "video/*",
          headers: {
            'Content-Length': video.length,

          }
      );
      var response = await dio.put(url,
          options: options,
        data: Stream.fromIterable(video.map((e) => [e])),
          );
      if(response.statusCode==200)
        return true;
      return false;
    } on DioError catch (e) {
      if (DioErrorType.RECEIVE_TIMEOUT == e.type ||
          DioErrorType.CONNECT_TIMEOUT == e.type) {
        postVideoFileResponse={false:"Server is not reachable. Please verify your internet connection and try again"};

      } else if (DioErrorType.RESPONSE == e.type) {
        postVideoFileResponse={false:"Server responded with wrong error code"};
      } else if (DioErrorType.DEFAULT == e.type) {
        if (e.message.contains('SocketException')) {
          postVideoFileResponse={false:"There was socket issue from server side encountered"};
        }
        else {
          postVideoFileResponse={false:"There was some issue observed on server side"};
        }
      } else {
        postVideoFileResponse={false:"There was some issue observed on server side"};
      }

    }
    return Future.value(postVideoFileResponse);
  }

}