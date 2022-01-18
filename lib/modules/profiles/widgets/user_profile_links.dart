import 'package:dualites/shared/constants/routes.dart';
import 'package:flutter/material.dart';

class UserProfileLinksWidget extends StatelessWidget {
  Map<String, IconData> linksInfo = {"Subscriptions": Icons.notifications,
  "Liked Videos":Icons.notifications,
  "Notifications":Icons.notifications,
  "Privacy":Icons.security,
  "Security":Icons.privacy_tip_outlined,
    "Help":Icons.help
  };
  @override
  Widget build(BuildContext context) {
    return ListView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.all(10.0),
        shrinkWrap: true,
        children: linksInfo.entries.map((e) {
          return ListTile(
            onTap: (){
              switch(e.key){
                case "Liked Videos":
                  Navigator.pushNamed(context, Routes.LIKED_VIDEOS);
                  break;
                case "Subscriptions":
                  Navigator.pushNamed(context, Routes.SUBSCRIPTIONS_LIST);
                  break;
                case "Notifications":
                  Navigator.pushNamed(context, Routes.NOTIFICATIONS_LIST);
                  break;

              }
            },
            leading: Icon(e.value,color: Color(0xFF2D388A),),
            title: Text(e.key),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 12.0,
            ),
          );
        }).toList());
  }
}
