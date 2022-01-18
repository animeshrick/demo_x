import 'package:dualites/shared/constants/routes.dart';
import 'package:flutter/material.dart';

class WelcomeNextPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 50.0,),
                Image.asset("assets/images/logo.jpg"),
                Expanded(child: SizedBox()),
                Text("Welcome",style: TextStyle(fontStyle: FontStyle.italic,color: Colors.white,fontSize: 26.0),),
                Text("Rohan",style: TextStyle(fontStyle: FontStyle.italic,color: Colors.white,fontSize: 26.0),),
                Expanded(child: SizedBox()),
                Container(
                  width: MediaQuery.of(context).size.width*0.9,
                  child: RaisedButton(onPressed: (){
                    Navigator.pushReplacementNamed(context, Routes.USER_PROFILE);
                  },shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),color:Colors.white,child: Center(child: Text("NEXT",style: TextStyle(color: Colors.red),),),),
                ),
                Expanded(child: SizedBox()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}