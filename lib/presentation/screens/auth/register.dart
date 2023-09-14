import 'dart:io';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:store_app/business_logic/cubit/auth/register/register_cubit.dart';
import 'package:store_app/data/local/cache_helper.dart';
import 'package:store_app/presentation/screens/auth/login.dart';
import 'package:store_app/shared/components/button.dart';
import 'package:store_app/shared/components/form.dart';
import 'package:store_app/shared/constants/colors.dart';

import '../../../business_logic/cubit/auth/register/register_states.dart';
import '../../../shared/components/navigate.dart';
import '../../../shared/components/toast.dart';
import '../home.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Start Form Variables
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  String? selectedPhoneCode = '';
  bool isPasswordNotVisible = true;
  bool isConfirmPasswordNotVisible = true;

  final emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final passValid =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}');
  final nameValid = RegExp(r'^[a-z A-Z]+$');
  // End Form Variables

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
          listener: (BuildContext context, RegisterStates state) {
        if (state is RegisterSuccessState) {
          if (state.loginModel.status) {
            CacheHelper.saveData(
                    key: 'login', value: state.loginModel.data.token)
                .then((value) =>
                    navigateAndFinish(context,  ProductsScreen()));
          } else {
            defaultToast(
              state: ToastState.ERROR,
              message: state.loginModel.message,
            );
          }
        }
        if (state is RegisterLoadingState) {
          print('Loadingggggggg');
        }
      }, builder: (BuildContext context, RegisterStates state) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: ListView(
                children: [
                  Transform.translate(
                    offset: const Offset(-40, -90),
                    child: Row(
                      children: [
                        Transform.translate(
                          offset: const Offset(-5, 60),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                                width: 160,
                                height: 160,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(80),
                                    color: AppColors.alignColor)),
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(-80, 10),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                                width: 160,
                                height: 160,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(80),
                                    color: AppColors.alignColor)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -130),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/register.png',
                            width: 150,
                            height: 130,
                          ),
                          const Text(
                            ' Welcome Onboard !',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: AppColors.fontColor),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Form(
                            key: _formKey,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 30.0, right: 30.0, bottom: 0),
                              child: Column(
                                children: [
                                  defaultFormField(
                                      onChange: (value) {
                                        if (_formKey.currentState!.validate()) {
                                          RegisterCubit.get(context).state;
                                        }
                                      },
                                      controller: name,
                                      type: TextInputType.name,
                                      label: 'Enter your name',
                                      validate: (String? value) {
                                        if (value!.isEmpty) {
                                          return "Name mustn't be empty";
                                        }
                                        if (!nameValid.hasMatch(value)) {
                                          return 'Enter valid username';
                                        }
                                        return null;
                                      }),
                                  const SizedBox(
                                    height: 18.0,
                                  ),
                                  defaultFormField(
                                      onChange: (value) {
                                        if (_formKey.currentState!.validate()) {
                                          RegisterCubit.get(context).state;
                                        }
                                      },
                                      controller: email,
                                      type: TextInputType.emailAddress,
                                      label: 'Enter your email',
                                      validate: (String? value) {
                                        if (value!.isEmpty) {
                                          return "Email mustn't be empty ";
                                        }
                                        if (!emailValid.hasMatch(value)) {
                                          return 'Enter valid email ';
                                        }
                                        return null;
                                      }),
                                  const SizedBox(
                                    height: 18.0,
                                  ),
                                  defaultFormField(
                                    onChange: (value) {
                                      if (_formKey.currentState!.validate()) {
                                        RegisterCubit.get(context).state;
                                      }
                                    },
                                    controller: password,
                                    type: TextInputType.visiblePassword,
                                    label: 'Enter your Password',
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
                                      onChange: (value) {
                                        if (_formKey.currentState!.validate()) {
                                          RegisterCubit.get(context).state;
                                        }
                                      },
                                      controller: confirmPassword,
                                      type: TextInputType.visiblePassword,
                                      label: 'Confirm Password',
                                      suffixPressed: () {
                                        RegisterCubit.get(context)
                                            .changeConfirmPasswordVisibility();
                                      },
                                      suffix:RegisterCubit.get(context).suffixConfirm,
                                      isPassword: RegisterCubit.get(context).isConfirmPasswordNotVisible,
                                      validate: (String? value) {
                                        if (value!.isEmpty) {
                                          return "Password mustn't be null";
                                        }
                                        if (value != password.text) {
                                          return "The password confirmation doesn't match";
                                        }
                                        return null;
                                      }),
                                  const SizedBox(
                                    height: 18.0,
                                  ),
                                  defaultPhoneFormField(
                                    label: 'Enter your phone',
                                    onChangeMethod: (String? value) {},
                                    cursorColor: AppColors.buttonColor,
                                    phoneNumber: PhoneNumber(
                                      isoCode:
                                          Platform.localeName.split('_').last,
                                    ),
                                    phoneController: phone,
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  ConditionalBuilder(
                                    condition: state is! RegisterLoadingState,
                                    builder: (context) => defaultButton(
                                      text: 'Register',
                                      radius: 15.0,
                                      width: 300,
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          print('Success');
                                          RegisterCubit.get(context)
                                              .userRegister(
                                                  name: name.text,
                                                  email: email.text,
                                                  password: password.text,
                                                  phone: phone.text);
                                        }
                                      },
                                    ),
                                    fallback: (context) => const Center(
                                        child: CircularProgressIndicator()),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: AppColors.formColor,
                                        child: Image.asset(
                                            'assets/images/googleicon.png'),
                                      ),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      CircleAvatar(
                                        backgroundColor: AppColors.formColor,
                                        child: Image.asset(
                                          'assets/images/Facebook_icon.svg.webp',
                                          height: 30.0,
                                          width: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("Already have an account?"),
                                      TextButton(
                                          onPressed: () {
                                            navigateAndFinish(
                                                context, LoginScreen());
                                          },
                                          child: Transform.translate(
                                            offset: const Offset(-5, 0),
                                            child: const Text(
                                              'Log in',
                                              style: TextStyle(
                                                  color: AppColors.buttonColor),
                                            ),
                                          ))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
