import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final bool isFormSaveOverlay;

  const LoadingOverlay({
    Key key,
    this.isLoading,
    this.isFormSaveOverlay=false,
    @required this.child,
  })  : assert(child != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: Lottie.asset('assets/lotties/video_loader.json'),
      );
    }
    else if(isFormSaveOverlay){
      return FadeTransition(
        child: Stack(
          children: <Widget>[
            Opacity(
              child: ModalBarrier(
                dismissible: false,
                color: Colors.blue,
              ),
              opacity: 0.5,
            ),
            Center(child: Lottie.asset('assets/lotties/video_loader.json'))
          ],
        ),
      );
    }
    return child;
  }
}