import 'package:dualites/modules/home/pages/category_videos_list/videos_list.dart';
import 'package:flutter/material.dart';

class CategoryVideosList extends StatelessWidget{
  final String tagName;
  CategoryVideosList({this.tagName,this.scrollController});
  final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        child: VideosListWidget(tagName: tagName,
        ),
      )
    );
  }
}