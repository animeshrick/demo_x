import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AnimateList extends StatelessWidget{
  final Widget widget;
  final int index;
  AnimateList({this.widget,this.index});
  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
        position: index,
        duration: const Duration(milliseconds: 1000),
    child: SlideAnimation(
    horizontalOffset: 1000.0,
    child: FadeInAnimation(child:widget)));
  }
}