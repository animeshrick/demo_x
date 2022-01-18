import 'dart:math';

import 'package:dualites/modules/login/getx/login_controller.dart';
import 'package:dualites/modules/login/getx/login_state.dart';
import 'package:dualites/shared/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class UserSignUpPage extends StatefulWidget{
  UserSignUpPageState createState()=>UserSignUpPageState();
}
class UserSignUpPageState extends State<UserSignUpPage> {
  final LoginController controller=Get.find();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailController = TextEditingController();
  final _userNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Obx(() {

      return Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Form(
              key: _key,
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: SizedBox()),
                      Container(
                          decoration: BoxDecoration(
                            color: Color((Random().nextDouble() * 0x000000)
                                        .toInt() <<
                                    0)
                                .withOpacity(1.0),
                          ),
                          child: Image.asset("assets/images/logo.png")),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        controller: _userNameController,
                        decoration: InputDecoration(
                          labelText: "USERNAME",
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        )
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "EMAIL",
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        validator: (val)=>val.trim()==""?"Please Enter Email":null,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "PASSWORD",
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                          validator: (val){
                            if(val.trim()=="")
                              return "Please Enter Password";
                            else if(_confirmPasswordController.text!=_passwordController.text)
                              return "Password and confirm password Should be same";
                            return null;
                          }
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "CONFIRM PASSWORD",
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        validator: (val){
                          if(val.trim()=="")
                            return "Please Enter Confirm Password";
                          else if(_confirmPasswordController.text!=_passwordController.text)
                            return "Password and confirm password Should be same";
                          return null;
                        }
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RaisedButton(
                            onPressed: controller.state is RegisterLoading ?null :() {
                              //Navigator.pushNamed(context, Routes.USER_WELCOME_NEXT);
                              if (_key.currentState.validate()) {
                                if(_userNameController.text.trim()=="")
                                  _userNameController.text=_emailController.text;
                                controller.register(
                                    _emailController.text,
                                    _userNameController.text,
                                    _passwordController.text);
                              }
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            color: Colors.blue,
                            child: controller.state is RegisterLoading
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Logging"),
                                      CircularProgressIndicator()
                                    ],
                                  )
                                : Center(
                                    child: Text(
                                      "Sign Up",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        height: 1.0,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "Already Have An Account",
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      RaisedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, Routes.USER_LOGIN);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        color: Colors.white,
                        child: Center(
                          child: Text(
                            "LOG IN",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                      Expanded(child: SizedBox()),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
