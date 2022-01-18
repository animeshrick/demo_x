import 'package:flutter/material.dart';

class DaOutlineButtonWidget extends StatelessWidget {
  VoidCallback callback;
  String buttonText;
  DaOutlineButtonWidget({this.buttonText,this.callback});
  @override
  Widget build(BuildContext context) {
    return OutlineButton(
        onPressed:(){
          callback();
        } ,
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 12.0),
          ),
        ),
        textColor: Colors.blue,
        disabledTextColor: Colors.grey,
        disabledBorderColor: Colors.grey,
        borderSide: BorderSide(
          color: Colors.blue, //Color of the border
          style: BorderStyle.solid, //Style of the border
          width: 1, //width of the border
        ));
  }
}
