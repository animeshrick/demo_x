import 'package:dualites/modules/profiles/creator/sub_pages/videos_list_user.dart';
import 'package:flutter/material.dart';

class LikedVideos extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
                children: [
            Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
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
                  "Liked Videos",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                SizedBox(),
              ],
            )),

                VideosList()]),
      ),
    ));
  }
}