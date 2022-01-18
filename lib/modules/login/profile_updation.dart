import 'package:dualites/modules/authentication/authentication_controller.dart';
import 'package:dualites/modules/login/getx/login_controller.dart';
import 'package:dualites/modules/login/getx/login_state.dart';
import 'package:dualites/modules/profiles/creator/creator_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileUpdationPage extends StatefulWidget {
  ProfileUpdationPageState createState() => ProfileUpdationPageState();
}

class ProfileUpdationPageState extends State<ProfileUpdationPage> {
  TextEditingController _nameController = TextEditingController(text: "");
  TextEditingController _userNameController = TextEditingController(text: "");
  final LoginController loginController = Get.find();
  final AuthenticationController authenticationController = Get.find();
  GlobalKey<FormState> _formKey = GlobalKey();
  void initState() {
    super.initState();
    _nameController = TextEditingController(
        text: authenticationController.userProfileModel.name);
    _userNameController = TextEditingController(
        text: authenticationController.userProfileModel.username);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
                            onTap: (){
            Navigator.pushReplacement(
            context,
            MaterialPageRoute(
            builder: (context) => CreatorProfilePage()));
            },
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
                            "Fill In Your Info",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          InkWell(
                            onTap: loginController.state is LoginLoading
                                ? null
                                : () {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                      loginController
                                          .updateProfileWithNameAndBio(
                                              _nameController.text,
                                              _userNameController.text,
                                              context);
                                    }
                                  },
                            child: Container(
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF2D388A),
                              ),
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      )),
                  Container(
                      padding: const EdgeInsets.all(0.0),
                      child:
                          Image.asset("assets/images/profile_container.jpg")),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      authenticationController.userProfileModel.avatar == null
                          ? CircleAvatar(
                              backgroundImage: AssetImage(
                                  "assets/images/author_image.jpg"),
                              radius: 70,
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(
                                  authenticationController
                                      .userProfileModel.avatar),
                              radius: 70,
                            )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 10.0),
                    child: Form(
                      key: _formKey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text(
                            "Name:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.0),
                          )),
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      child: TextFormField(
                                    controller: _nameController,
                                    validator: (val) {
                                      return val.toString().trim() == ""
                                          ? "Please Enter Valid Name"
                                          : null;
                                    },
                                  )),
                                  Divider(
                                    color: Colors.grey,
                                  )
                                ]),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Text(
                          "UserName:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        )),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    child: TextFormField(
                                  controller: _userNameController,
                                  validator: (val) {
                                    return val.toString().trim() == ""
                                        ? "Please Enter Valid Username"
                                        : null;
                                  },
                                )),
                                Divider(
                                  color: Colors.grey,
                                )
                              ]),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ));
    });
  }
}
