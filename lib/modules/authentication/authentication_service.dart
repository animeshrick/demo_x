import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dualites/models/user_model.dart';
import 'package:dualites/models/user_profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService {
  Dio dio;
  AuthenticationService(this.dio);
  Future<Map> registerWithEmailAndPassword(String url, User user) async {
    Map<String, List<dynamic>> values = {};
    try {
      Response response = await dio.post(url, data: user.toJsonForRegister());
      values["isRegistered"] = [response.data["key"]];
      return values;
    } on DioError catch (e) {
      values = Map.from(e.response.data);
      return values;
    }
  }

  Future<Map> loginWithEmailAndPassword(String url, User user) async {
    Map<String, String> values = {};
    try {
      Response response = await dio.post(url, data: user.toJsonForLogin());
      values["key"] = response.data["key"];
      return values;
    } on DioError catch (e) {
      values["error"] = List.from(e.response.data["non_field_errors"])[0];
      return values;
    }
  }

  Future<Map> loginWithGmail(
      String url, String accessToken, String idToken, String code) async {
    Map<String, String> values = {};
    try {
      Response response = await dio
          .post(url, data: {"access_token": accessToken, "id_token": idToken});
      values["key"] = response.data["key"];
      return values;
    } on DioError catch (e) {
      values["error"] = List.from(e.response.data["non_field_errors"])[0];
      return values;
    }
  }

  Future<dynamic> getProfileInfoWithEmailAndPassword(
      String url, String key) async {
    try {
      Response response = await dio.get(
        url,
        options: Options(
          headers: {"Authorization": "token $key"},
        ),
      );
      return UserProfileModel.fromMap(response.data);
    } on DioError catch (e) {
      if (Map.from(e.response.data).containsKey("detail"))
        return Map.from(e.response.data)["detail"];
      else
        return "There was server error encountered";
    }
  }

  Future<dynamic> updateProfileInfoWithNameAndBio(
      String url, String key, String name, String bio) async {
    try {
      Response response = await dio.patch(
        url,
        data: {"name": name, "bio": bio},
        options: Options(
          headers: {"Authorization": "token $key"},
        ),
      );
      return UserProfileModel.fromMap(response.data);
    } on DioError catch (e) {
      if (Map.from(e.response.data).containsKey("detail"))
        return Map.from(e.response.data)["detail"];
      else
        return "There was server error encountered";
    }
  }

  Future<dynamic> followProfile(String url, String key) async {
    try {
      Response response = await dio.post(url,
          options: Options(headers: {"Authorization": "token $key"}));
      return true;
    } on DioError catch (e) {
      return "There was server error encountered";
    }
  }

  @override
  Future<UserProfileModel> getCurrentUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey("user")) {
      UserProfileModel userProfileModel =
          jsonDecode(preferences.getString("user"));
      return userProfileModel;
    }
    return null;
  }
}

class AuthenticationException implements Exception {
  final String message;

  AuthenticationException({this.message = 'Unknown error occurred. '});
}
