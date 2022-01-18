import 'package:dualites/models/user_model.dart';
import 'package:dualites/models/user_profile_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationLoading extends AuthenticationState {}

class UnAuthenticated extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final UserProfileModel user;

  Authenticated({@required this.user});

  @override
  List<Object> get props => [user];
}

class Registered extends AuthenticationState {
  final bool isRegistered;
  Registered({this.isRegistered});

  @override
  List<Object> get props => [];
}

class AuthenticationFailure extends AuthenticationState {
  final String message;

  AuthenticationFailure({@required this.message});

  @override
  List<Object> get props => [message];
}