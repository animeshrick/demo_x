import 'package:dualites/modules/profiles/creator/sub_pages/invite_page/getx/invite_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InviteController extends GetxController{
  InviteProvider inviteProvider;
  bool isLoading=false;
  InviteController({this.inviteProvider});
  String inviteEmail="";
  int invitesRemaining=0;
  @override
  void onInit() {
    super.onInit();
    getInvitesRemaining();
  }

  sendInviteToUser(String email,int creatorId)async{
    isLoading=true;
    update();
    dynamic response= await inviteProvider.sendInviteToUser("https://dualite.xyz/api/v1/invite/", email,
        creatorId);
    isLoading=false;

    if(response is bool){
      dynamic invitesSentResponse=await callInviteApiAndGetResponse();
      invitesRemaining=invitesSentResponse;
      Get.snackbar("Sent", "Invite has Been sent",backgroundColor: Colors.green,snackPosition: SnackPosition.BOTTOM);
    }
    else if(response is String){
      Get.snackbar("Error", response,backgroundColor: Colors.red);
    }
    update();
  }

  getInvitesRemaining()async{
    isLoading=true;
    update();
    dynamic response= await callInviteApiAndGetResponse();
    isLoading=false;

    if(response is int){
      invitesRemaining=response;
    }
    else if(response is String) {
      Get.snackbar("Error", response,backgroundColor: Colors.red);
    }
    update();
  }

  dynamic callInviteApiAndGetResponse()async{
    dynamic response= await inviteProvider.getInvitesInfo("https://dualite.xyz/api/v1/invite/");
    return response;

  }
  updateEmail(String email){
    inviteEmail=email;
  }

}