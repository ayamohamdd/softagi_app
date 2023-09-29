import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/business_logic/cubit/auth/login/login_states.dart';
import 'package:store_app/data/remote/dio_helper.dart';
import 'package:store_app/presentation/models/login_model.dart';
import 'package:store_app/shared/constants/strings.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);
  LoginModel? loginModel;
  void userLogin({
    required String email,
    required String password,
  }) {
    emit(LoginLoadingState());
    DioHelper.postData(url: baseUrl + LOGIN, data: {
      'email': email,
      'password': password,
    }).then((value) {
      print(value.data);
      loginModel = LoginModel.fromJson(value.data);
      emit(LoginSuccessState(loginModel));
    }).catchError((error) {
      print(error.toString());
      emit(LoginErrorState(error: error.toString()));
    });
  }

  IconData suffix = Icons.visibility_off_outlined;

  bool isPasswordNotVisible = true;

  void changePasswordVisibility() {
    isPasswordNotVisible = !isPasswordNotVisible;

    suffix = isPasswordNotVisible
        ? Icons.visibility_off_outlined
        : Icons.visibility_outlined;

    emit(LoginChangePasswordVisibilityState());
  }

  void updateToke(String token) {
  loginModel!.data!.token=token;
    emit(LoginUpdateToke());
  }
}
