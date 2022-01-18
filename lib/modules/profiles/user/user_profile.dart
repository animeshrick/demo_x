import 'package:dualites/modules/profiles/widgets/user_info_widget.dart';
import 'package:dualites/modules/profiles/widgets/user_profile_links.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height*0.4,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/profile_back.jpg"))),
                  ),
                  Positioned(top: MediaQuery.of(context).size.height*0.07,
                    left: MediaQuery.of(context).size.width*0.01,
                    right: MediaQuery.of(context).size.width*0.01,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SizedBox(),
                        ),
                        UserInfoWidget(),
                        Expanded(
                          child: SizedBox()
                        ),
                      ],
                    ),),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.01,
              color: Color(0xFF00AEEF),
            ),
            Expanded(child: UserProfileLinksWidget())
          ],
        ),
      ),
    );
  }
}