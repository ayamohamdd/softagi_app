import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/business_logic/cubit/auth/login/login_cubit.dart';
import 'package:store_app/business_logic/cubit/auth/login/login_states.dart';
import 'package:store_app/data/local/cache_helper.dart';
import 'package:store_app/presentation/layout/layout.dart';
import 'package:store_app/presentation/screens/auth/register.dart';
import 'package:store_app/shared/components/button.dart';
import 'package:store_app/shared/components/form.dart';
import 'package:store_app/shared/constants/colors.dart';

import '../../../shared/components/navigate.dart';
import '../../../shared/components/toast.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  // Start Form Variables
  final _formKey = GlobalKey<FormState>();

  final TextEditingController email = TextEditingController();

  final TextEditingController password = TextEditingController();

  final emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final passValid =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}');

  // End Form Variables

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: ((BuildContext context) => LoginCubit()),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (BuildContext context, LoginStates state) {
          if (state is LoginSuccessState) {
            if (state.loginModel.status) {
              CacheHelper.saveData(
                      key: 'login', value: state.loginModel.data.token)
                  .then((value) => navigateAndFinish(
                      context,
                       const LayoutScreen()));
            } else {
              defaultToast(
                state: ToastState.ERROR,
                message: state.loginModel.message,
              );
            }
          }
        },
        builder: (BuildContext context, LoginStates state) {
          return Scaffold(
            body: Center(
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
                    offset: const Offset(0, -50),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          const Text(
                            '  Welcome Back !',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: AppColors.fontColor),
                          ),
                          Image.asset(
                            'assets/images/login.png',
                            width: 230,
                            height: 220,
                          ),
                          Form(
                            key: _formKey,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Column(
                                children: [
                                  defaultFormField(
                                      onChange: (value) {
                                        if (_formKey.currentState!.validate()) {
                                          LoginCubit.get(context).state;
                                        }
                                      },
                                      controller: email,
                                      type: TextInputType.emailAddress,
                                      label: 'Enter your email',
                                      validate: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'Email cannot be empty ';
                                        }
                                        if (!emailValid.hasMatch(value)) {
                                          return 'Enter valid email ';
                                        }
                                        return null;
                                      }),
                                  const SizedBox(
                                    height: 17.0,
                                  ),
                                  defaultFormField(
                                      onChange: (value) {
                                        if (_formKey.currentState!.validate()) {
                                          LoginCubit.get(context).state;
                                        }
                                      },
                                      controller: password,
                                      type: TextInputType.visiblePassword,
                                      label: 'Enter your Password',
                                      validate: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'Password cannot be empty ';
                                        }
                                        if (!passValid.hasMatch(value)) {
                                          return 'Enter valid password';
                                        }
                                        return null;
                                      },
                                      suffixPressed: () {
                                        LoginCubit.get(context)
                                            .changePasswordVisibility();
                                      },
                                      suffix: LoginCubit.get(context).suffix,
                                      isPassword: LoginCubit.get(context)
                                          .isPasswordNotVisible,
                                      onSubmit: (value) {
                                        if (_formKey.currentState!.validate()) {
                                          LoginCubit.get(context).userLogin(
                                              email: email.text,
                                              password: password.text);
                                        }
                                      }),
                                  // const SizedBox(
                                  //   height: 5.0,
                                  // ),
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      "Forgot Password",
                                      style: TextStyle(
                                          color: AppColors.buttonColor),
                                    ),
                                  ),
                                  ConditionalBuilder(
                                    condition: state is! LoginLoadingState,
                                    builder: (context) => defaultButton(
                                      text: 'Login',
                                      radius: 15.0,
                                      width: 300,
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          LoginCubit.get(context).userLogin(
                                              email: email.text,
                                              password: password.text);
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
                                      const Text("Don't have an account?"),
                                      TextButton(
                                          onPressed: () {
                                            navigateAndFinish(
                                                context,
                                                const RegisterScreen()
                                                );
                                          },
                                          child: Transform.translate(
                                            offset: const Offset(-5, 0),
                                            child: const Text(
                                              'Sign up',
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
          );
        },
      ),
    );
  }
}
