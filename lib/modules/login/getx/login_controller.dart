import 'dart:convert';

import 'package:dualites/models/user_profile_model.dart';
import 'package:dualites/modules/authentication/authentication_controller.dart';
import 'package:dualites/modules/authentication/authentication_service.dart';
import 'package:dualites/modules/login/getx/login_state.dart';
import 'package:dualites/modules/profiles/creator/creator_profile.dart';
import 'package:dualites/modules/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final AuthenticationController _authenticationController = Get.find();
  final _loginStateStream = LoginState().obs;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  LoginState get state => _loginStateStream.value;

  void register(String email, String userName, String password) async {
    _loginStateStream.value = RegisterLoading();

    try {
      Map<String, List<dynamic>> isRegistered =
          await _authenticationController.register(email, userName, password);
      if (isRegistered.containsKey("isRegistered")) {
        Get.snackbar(
            "Success", "Mail has been sent. Please verify the email address.",
            backgroundColor: Colors.green, snackPosition: SnackPosition.BOTTOM);
        _loginStateStream.value = RegisteredState();
      } else {
        String errorMessage = "";
        for (List<dynamic> v in isRegistered.values) {
          for (int i = 0; i < v.length; i++) {
            errorMessage = errorMessage + v[i].toString() + " \n";
          }
        }
        Get.snackbar("Error", errorMessage,
            backgroundColor: Colors.red, snackPosition: SnackPosition.BOTTOM);
        _loginStateStream.value =
            RegistrationFailure(error: "Invalid credentials.");
      }
    } on AuthenticationException catch (e) {
      _loginStateStream.value = RegistrationFailure(error: e.message);
    }
  }

  void loginWithGoogle(BuildContext context)async{
    _loginStateStream.value = LoginLoading();

    try {
      await googleSignIn.signOut();
      final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication;
      if (googleSignInAccount != null) {
        googleSignInAuthentication=
        await googleSignInAccount.authentication;
      }
      else{
        _loginStateStream.value = LoginFailure(error: "There was an error on Google login");
      }

      Map<String, String> key =
      await _authenticationController.loginWithGoogle(googleSignInAuthentication.accessToken,
          googleSignInAuthentication.idToken, googleSignInAuthentication.serverAuthCode);
      if (key.containsKey("key")) {
        final dynamic response =
        await _authenticationController.getUserProfile(key["key"]);
        if (response is UserProfileModel) {
          SharedPreferences.getInstance().then((value) {
            value.setString("key", key["key"]);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Widgets(
                      userProfileModel: response,
                      index: 0,
                    )));
            _loginStateStream.value = LoggedInState(userProfileModel: response);
          });

        } else {
          Get.snackbar("Error", response.toString(),
              backgroundColor: Colors.red, snackPosition: SnackPosition.BOTTOM);
          _loginStateStream.value = LoginFailure(error: response);
        }
      } else {
        Get.snackbar("Error", key["error"],
            backgroundColor: Colors.red, snackPosition: SnackPosition.BOTTOM);
        _loginStateStream.value = LoginFailure(error: key["error"]);
      }
      update();
    } on AuthenticationException catch (e) {
      _loginStateStream.value = LoginFailure(error: e.message);
    }
    catch(e){
      Get.snackbar("Error",
          "Google configuration Not complete",
          backgroundColor: Colors.red, snackPosition: SnackPosition.BOTTOM);
      _loginStateStream.value = LoginFailure(error:"Google configuration Not complete");
      print(e);
    }

  }
  void login(String email, String userName, String password,
      BuildContext context) async {
    _loginStateStream.value = LoginLoading();

    try {
      Map<String, String> key =
          await _authenticationController.login(email, userName, password);
      if (key.containsKey("key")) {
        final dynamic response =
            await _authenticationController.getUserProfile(key["key"]);
        if (response is UserProfileModel) {
          SharedPreferences.getInstance().then((value) {
            value.setString("key", key["key"]);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Widgets(
                      userProfileModel: response,
                      index: 0,
                    )));
            _loginStateStream.value = LoggedInState(userProfileModel: response);
          });

        } else {
          Get.snackbar("Error", response.toString(),
              backgroundColor: Colors.red, snackPosition: SnackPosition.BOTTOM);
          _loginStateStream.value = LoginFailure(error: response);
        }
      } else {
        Get.snackbar("Error", key["error"],
            backgroundColor: Colors.red, snackPosition: SnackPosition.BOTTOM);
        _loginStateStream.value = LoginFailure(error: key["error"]);
      }
      update();
    } on AuthenticationException catch (e) {
      _loginStateStream.value = LoginFailure(error: e.message);
    }
  }

  void updateProfileWithNameAndBio(
      String name, String userName, BuildContext context) async {
    _loginStateStream.value = LoginLoading();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      dynamic response =
          await _authenticationController.updateUserProfileWithNameAndPassword(
              preferences.getString("key"), name, userName);
      if (response is UserProfileModel) {
        //preferences.setString("user", jsonEncode(response));
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => CreatorProfilePage()));
        _loginStateStream.value = LoggedInState(userProfileModel: response);
      } else {
        Get.snackbar("Error", response.toString(),
            backgroundColor: Colors.red, snackPosition: SnackPosition.BOTTOM);
        _loginStateStream.value = LoginFailure(error: response);
      }
    } on AuthenticationException catch (e) {
      _loginStateStream.value = LoginFailure(error: e.message);
    }
  }

  void followProfile(
      int id) async {
    _loginStateStream.value = LoginLoading();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      dynamic response =
      await _authenticationController.followProfile(
          preferences.getString("key"), id);
      if (response is bool) {
        Get.snackbar("Success", "Thanks For Liking",
            backgroundColor: Colors.red, snackPosition: SnackPosition.BOTTOM);
        _loginStateStream.value = FollowedProfileState(isFollowed: true);
      } else {
        Get.snackbar("Error", response.toString(),
            backgroundColor: Colors.red, snackPosition: SnackPosition.BOTTOM);
        _loginStateStream.value = FollowedProfileState(isFollowed: false);
      }
    } on AuthenticationException catch (e) {
      _loginStateStream.value = LoginFailure(error: e.message);
    }
  }


}
