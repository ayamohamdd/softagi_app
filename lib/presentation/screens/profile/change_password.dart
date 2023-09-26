import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/business_logic/cubit/auth/register/register_cubit.dart';
import 'package:store_app/business_logic/cubit/auth/register/register_states.dart';
import 'package:store_app/business_logic/cubit/home/shop_cubit.dart';
import 'package:store_app/business_logic/cubit/home/shop_states.dart';
import 'package:store_app/shared/components/button.dart';
import 'package:store_app/shared/components/form.dart';
import 'package:store_app/shared/components/navigate.dart';
import 'package:store_app/shared/components/toast.dart';
import 'package:store_app/shared/constants/colors.dart';
import 'package:store_app/shared/constants/temp.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  TextEditingController currentPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmNewPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
            color: AppColors.containerColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'Poppins'),
        elevation: 0,
        backgroundColor: AppColors.buttonColor,
      ),
      backgroundColor: AppColors.backgroundColor,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ShopCubit()),
          BlocProvider(create: (context) => RegisterCubit()),
        ],
        child: BlocBuilder<RegisterCubit, RegisterStates>(
          builder: (context, state) {
            return BlocConsumer<ShopCubit, ShopStates>(
              listener: (context, state) {
                print(state is ShopSuccessChangePasswordState);
                if (state is ShopSuccessChangePasswordState) {
                  //print(state.changePasswordModel!.status);
                  if (state.changePasswordModel.status == true)
                    navigateBack(context);
                  defaultToast(
                      message: state.changePasswordModel.message!,
                      state: state.changePasswordModel.status == false
                          ? ToastState.ERROR
                          : ToastState.SUCCESS);
                }
              },
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/password.png',
                          width: 200,
                          height: 200,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(
                              30.0,
                            ),
                            child: Column(
                              children: [
                                defaultFormField(
                                  controller: currentPassword,
                                  type: TextInputType.visiblePassword,
                                  label: 'Current Password',
                                  suffixPressed: () {
                                    RegisterCubit.get(context)
                                        .changePasswordVisibility();
                                  },
                                  suffix: RegisterCubit.get(context).suffix,
                                  isPassword: RegisterCubit.get(context)
                                      .isPasswordNotVisible,
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return "Password mustn't be empty";
                                    }
                                    if (!passValid.hasMatch(value)) {
                                      return 'Enter valid password';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 18.0,
                                ),
                                defaultFormField(
                                  controller: newPassword,
                                  type: TextInputType.visiblePassword,
                                  label: 'New Password',
                                  suffixPressed: () {
                                    RegisterCubit.get(context)
                                        .changeNewPasswordVisibility();
                                  },
                                  suffix: RegisterCubit.get(context).suffixNew,
                                  isPassword: RegisterCubit.get(context)
                                      .isNewPasswordNotVisible,
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return "Password mustn't be empty";
                                    }
                                    if (!passValid.hasMatch(value)) {
                                      return 'Enter valid password';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 18.0,
                                ),
                                defaultFormField(
                                    onChange: (value) {
                                      // if (_formKey.currentState!.validate()) {
                                      //   RegisterCubit.get(context).state;
                                      // }
                                    },
                                    controller: confirmNewPassword,
                                    type: TextInputType.visiblePassword,
                                    label: 'Confirm New Password',
                                    suffixPressed: () {
                                      RegisterCubit.get(context)
                                          .changeConfirmPasswordVisibility();
                                    },
                                    suffix: RegisterCubit.get(context)
                                        .suffixConfirm,
                                    isPassword: RegisterCubit.get(context)
                                        .isConfirmPasswordNotVisible,
                                    validate: (String? value) {
                                      if (value!.isEmpty) {
                                        return "Password mustn't be null";
                                      }
                                      if (value != newPassword.text) {
                                        return "The password confirmation doesn't match";
                                      }
                                      return null;
                                    }),
                                const SizedBox(
                                  height: 150.0,
                                ),
                                defaultButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        ShopCubit.get(context).changePassword(
                                            currentPassword.text,
                                            newPassword.text);
                                      }
                                    },
                                    text: 'Save Changes',
                                    textColor: AppColors.containerColor,
                                    width: 300),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      // floatingActionButton: ,
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
