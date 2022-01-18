import 'package:dualites/models/user_model.dart';
import 'package:dualites/models/user_profile_model.dart';
import 'package:dualites/modules/authentication/authentication_service.dart';
import 'package:dualites/modules/authentication/authentication_state.dart';
import 'package:get/get.dart';

class AuthenticationController extends GetxController {
  final AuthenticationService _authenticationService;
  final _authenticationStateStream = AuthenticationState().obs;
  UserProfileModel userProfileModel;
  AuthenticationState get state => _authenticationStateStream.value;

  AuthenticationController(this._authenticationService);

  // Called immediately after the contoller is allocated in memory.
  @override
  void onInit() {
    _getAuthenticatedUser();
    super.onInit();
  }

  Future<Map<String, List<dynamic>>> register(
      String email, String userName, String password) async {
    User user = new User(userName: userName, email: email, password: password);
    final Map<String, List<dynamic>> response =
        await _authenticationService.registerWithEmailAndPassword(
            "https://dualite.xyz/api/v1/auth/register/", user);
    return response;
  }

  Future<Map<String, String>> login(
      String email, String userName, String password) async {
    User user = new User(userName: userName, email: email, password: password);
    final Map<String, String> response =
        await _authenticationService.loginWithEmailAndPassword(
            "https://dualite.xyz/api/v1/auth/login/", user);
    return response;
  }

  Future<Map<String, String>> loginWithGoogle(
      String accessToken, String idToken, String code) async {
    final Map<String, String> response =
    await _authenticationService.loginWithGmail(
        "https://dualite.xyz/api/v1/auth/google/", accessToken,idToken,code);
    return response;
  }

  Future<dynamic> getUserProfile(String key) async {
    dynamic response= await _authenticationService.getProfileInfoWithEmailAndPassword(
        "https://dualite.xyz/api/v1/profile/", key);
    if(response is UserProfileModel){
      userProfileModel=response;
    }
    return response;
  }

  Future<dynamic> updateUserProfileWithNameAndPassword(String key,String name,String username) async {
    dynamic response= await _authenticationService.updateProfileInfoWithNameAndBio(
        "https://dualite.xyz/api/v1/profile/", key,name,username);
    if(response is UserProfileModel){
      userProfileModel=response;
    }
    return response;
  }

  Future<dynamic> followProfile(String key,int id) async {
    dynamic response= await _authenticationService.followProfile(
        "https://dualite.xyz/api/v1/profiles/${id}/follow/", key);
    return response;
  }

  void signOut() async {
    //remove from shared preference
    _authenticationStateStream.value = UnAuthenticated();
  }

  void _getAuthenticatedUser() async {
    _authenticationStateStream.value = AuthenticationLoading();

    final user = await _authenticationService.getCurrentUser();
    userProfileModel = user;
    if (user == null) {
      _authenticationStateStream.value = UnAuthenticated();
    } else {
      _authenticationStateStream.value = Authenticated(user: userProfileModel);
    }
  }
}
