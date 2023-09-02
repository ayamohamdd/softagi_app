
abstract class LoginStates {}

// Login Form States
class LoginInitialState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {
  var loginModel;
  LoginSuccessState(this.loginModel);
}

class LoginErrorState extends LoginStates {
  final String? error;

  LoginErrorState({this.error});
}

// Login Password Visibility
class LoginChangePasswordVisibilityState extends LoginStates {}
