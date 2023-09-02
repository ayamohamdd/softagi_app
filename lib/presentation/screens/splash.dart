import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:store_app/presentation/screens/auth/login.dart';
import 'package:store_app/shared/constants/colors.dart';
import 'package:store_app/shared/constants/strings.dart';
import 'package:store_app/presentation/screens/onboarding.dart';
import '../../data/local/cache_helper.dart';
import '../layout/layout.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  bool? isOnboardingViewed;
  String? isLoggedIn;
  CacheHelper cacheHelper = CacheHelper();
  onboardingRun() async {
    isOnboardingViewed = await CacheHelper.getData(key: 'onboarding');
    setState(() {});
    return isOnboardingViewed;
  }

  loginRun() async {
    token = await CacheHelper.getData(key: 'login');
    setState(() {});
    return token;
  }
  Widget nextWidget() {
    if (isOnboardingViewed!=null) {
      if (token!=null) {
        return  LayoutScreen();
      } else {
        return LoginScreen();
      }
    } else {
      return const OnboardingScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    //onboardingRun();
    onboardingRun();
    loginRun();
    return AnimatedSplashScreen(
      splash: Column(
          //mainAxisSize: MainAxisSize.min,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: const Offset(0, 70),
              child: Lottie.asset(
                'assets/lotties/animation_lltzoasc.json',
                width: 500,
                height: 400,
              ),
            ),
            DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.backgroundColor,
                ),
                textAlign: TextAlign.center,
                child: Text(
                  'Softagi'.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: "Poppins",
                  ),
                )),
          ]),
      nextScreen: nextWidget(),
      splashIconSize: 550,
      duration: 4000,
      splashTransition: SplashTransition.fadeTransition,
      animationDuration: const Duration(seconds: 2),
      backgroundColor: AppColors.buttonColor,
    );
  }
}
