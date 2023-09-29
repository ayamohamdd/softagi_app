// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:store_app/presentation/models/login_model.dart';

abstract class LoginStates {}

// Login Form States
class LoginInitialState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {
  LoginModel? loginModel;
  LoginSuccessState(
    this.loginModel,
  );
}

class LoginErrorState extends LoginStates {
  final String? error;

  LoginErrorState({this.error});
}

class LoginUpdateToke extends LoginStates{}
// Login Password Visibility
class LoginChangePasswordVisibilityState extends LoginStates {}
