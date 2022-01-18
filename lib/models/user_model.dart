class User{

  String email,userName,password;
  User({this.password,this.email,this.userName});
  toJsonForRegister(){
    return {
      "email":email,
      "username":userName,
      "password1":password,
      "password2":password
    };
  }

  toJsonForLogin(){
    return {
      "email":email,
      "username":userName,
      "password":password
    };
  }
}