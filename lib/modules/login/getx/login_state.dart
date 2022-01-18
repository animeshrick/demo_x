import 'package:dualites/models/user_profile_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class RegisteredState extends LoginState {
  @override
  List<Object> get props => [];
}

class LoggedInState extends LoginState {
  final UserProfileModel userProfileModel;
  LoggedInState({this.userProfileModel});
  @override
  List<Object> get props => [];
}

class FollowedProfileState extends LoginState {
  bool isFollowed;
  FollowedProfileState({this.isFollowed});
  @override
  List<Object> get props => [];
}
class LoginLoading extends LoginState {}

class RegisterLoading extends LoginState {}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({@required this.error});

  @override
  List<Object> get props => [error];
}

class RegistrationFailure extends LoginState {
  final String error;

  RegistrationFailure({@required this.error});

  @override
  List<Object> get props => [error];
}