import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/data/remote/dio_helper.dart';
import 'package:store_app/presentation/models/login_model.dart';

import '../../../../shared/constants/strings.dart';
import 'register_states.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    emit(RegisterLoadingState());
    DioHelper.postData(url: baseUrl + REGISTER, data: {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
    }).then((value) {
      print(value.data);
      var loginModel = LoginModel.fromJson(value.data);
      emit(RegisterSuccessState(loginModel));
    }).catchError((error) {
      emit(RegisterErrorState(error: error.toString()));
    });
  }
  IconData suffix = Icons.visibility_off_outlined;
  IconData suffixConfirm = Icons.visibility_off_outlined;


  bool isPasswordNotVisible = true;
  bool isConfirmPasswordNotVisible = true;

  void changePasswordVisibility() {
    isPasswordNotVisible = !isPasswordNotVisible;

    suffix = isPasswordNotVisible
        ? Icons.visibility_off_outlined
        : Icons.visibility_outlined;

    emit(RegisterChangePasswordVisibilityState());
  }
  void changeConfirmPasswordVisibility() {
    isConfirmPasswordNotVisible = !isConfirmPasswordNotVisible;

    suffixConfirm = isConfirmPasswordNotVisible
        ? Icons.visibility_off_outlined
        : Icons.visibility_outlined;

    emit(RegisterChangeConfirmPasswordVisibilityState());
  }
}
