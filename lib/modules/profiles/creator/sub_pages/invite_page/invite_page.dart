import 'package:dio/dio.dart';
import 'package:dualites/modules/authentication/authentication_controller.dart';
import 'package:dualites/modules/profiles/creator/sub_pages/invite_page/getx/invite_controller.dart';
import 'package:dualites/modules/profiles/creator/sub_pages/invite_page/getx/invite_provider.dart';
import 'package:dualites/modules/search/pages/search.dart';
import 'package:dualites/shared/widgets/loading/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvitePage extends StatelessWidget {
  final InviteController controller =
      Get.put(InviteController(inviteProvider: InviteProvider(new Dio())));
  final AuthenticationController authenticationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF2D388A),
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  "Invite",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                InkWell(
                  onTap: () {
                    controller.sendInviteToUser(controller.inviteEmail,
                        authenticationController.userProfileModel.id);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF2D388A),
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            InvitesRemainingText(),
            SearchTextField(
              changeCallback: (val) {
                controller.updateEmail(val);
              },
            ),
            Expanded(child: GetBuilder<InviteController>(builder: (controller) {
              return LoadingOverlay(
                  child: Container(), isLoading: controller.isLoading);
            }))
          ]),
        ),
      ),
    );
  }
}

class InvitesRemainingText extends StatelessWidget {
  final InviteController inviteController = Get.find();

  @override
  Widget build(BuildContext context) {
    inviteController.getInvitesRemaining();
    return GetBuilder<InviteController>(builder: (inviteController) {
      return Text(
        inviteController.invitesRemaining.toString() + " Invites Remaining",
        style: TextStyle(color: Colors.black,fontSize: 20.0),
      );
    });
  }
}
