import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InviteProvider{
  Dio dio;
  InviteProvider(this.dio);
  Future<dynamic> sendInviteToUser(String url,String inviteEmail,int creatorId) async {
    try {
      SharedPreferences preferences=await SharedPreferences.getInstance();
      String key =preferences.getString("key");
      Response response = await dio.post(url, data: {
        "invite_email":inviteEmail,
        "inviter":creatorId
      },options: Options(
        headers: {
          "Authorization": "Token ${key}", // set content-length
        },
      ),);
      return true;
    } on DioError catch (e) {
      return e.response.data["msg"];
    }
  }

  Future<dynamic> getInvitesInfo(String url) async {
    try {
      SharedPreferences preferences=await SharedPreferences.getInstance();
      String key =preferences.getString("key");
      Response response = await dio.get(url,
        options: Options(
        headers: {
          "Authorization": "Token ${key}", // set content-length
        },
      ),);
      return response.data["invites_left"];
    } on DioError catch (e) {
      return e.message;
    }
  }
}