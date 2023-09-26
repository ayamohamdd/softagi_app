
import 'package:store_app/presentation/models/login_model.dart';

abstract class RegisterStates {}

// Register Form States
class RegisterInitialState extends RegisterStates {}

class RegisterLoadingState extends RegisterStates {}

class RegisterSuccessState extends RegisterStates {
  LoginModel? loginModel;
  RegisterSuccessState(this.loginModel);
}

class RegisterErrorState extends RegisterStates {
  final String? error;
  RegisterErrorState({this.error});
}
// Register Password Visibility
class RegisterChangePasswordVisibilityState extends RegisterStates{}
class RegisterChangeNewPasswordVisibilityState extends RegisterStates{}
class RegisterChangeConfirmPasswordVisibilityState extends RegisterStates{}

