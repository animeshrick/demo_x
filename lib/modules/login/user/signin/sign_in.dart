import 'package:dualites/modules/login/getx/login_controller.dart';
import 'package:dualites/modules/login/getx/login_state.dart';
import 'package:dualites/shared/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserSignInPage extends StatefulWidget {
  UserSignInPageState createState() => UserSignInPageState();
}

class UserSignInPageState extends State<UserSignInPage> {
  final _controller = Get.put(LoginController()); // inject controller

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final GlobalKey<FormState> _scaffoldKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _userNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Form(
                  key: _key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: SizedBox()),
                      Image.asset("assets/images/logo.png"),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "To Continue,log in to Dualite",
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      RaisedButton(
                        onPressed: () {
                          _controller.loginWithGoogle(context);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        color: Colors.white,
                        child: Center(
                          child: Text(
                            "Contnue With Google",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                            height: 1.0,
                            color: Colors.white,
                          )),
                          Text(
                            "OR",
                            style: TextStyle(color: Colors.white),
                          ),
                          Expanded(
                              child: Container(
                            height: 1.0,
                            color: Colors.white,
                          )),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: Colors.white),
                          controller: _userNameController,
                          decoration: InputDecoration(
                            labelText: "Username",
                            labelStyle: TextStyle(color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          )),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: Colors.white),
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        validator: (val) =>
                            val.trim() == "" ? "Please Enter Email" : null,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        validator: (val) =>
                            val.trim() == "" ? "Please Enter Password" : null,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RaisedButton(
                            onPressed: () {
                              if (_key.currentState.validate()) {
                                if(_userNameController.text.trim()=="")
                                  _userNameController.text=_emailController.text;
                                _controller.login(
                                    _emailController.text,
                                    _userNameController.text,
                                    _passwordController.text,context);
                              }
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            color: Colors.white,
                            child: Center(
                              child: Text(
                                "Sign In",
                                style: TextStyle(color: Colors.black),
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
                        "Dont Have An Account",
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      RaisedButton(
                        onPressed: ()=>Navigator.popAndPushNamed(context, Routes.USER_SIGNUP),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        color: Colors.white,
                        child: Center(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (_controller.state is LoginLoading)
                        Center(
                          child: CircularProgressIndicator(),
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
