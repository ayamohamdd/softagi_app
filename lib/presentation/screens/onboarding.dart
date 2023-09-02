import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:store_app/presentation/screens/auth/login.dart';
import 'package:store_app/shared/constants/colors.dart';
import 'package:store_app/data/local/cache_helper.dart';
import 'package:store_app/presentation/models/onboarding_model.dart';

import '../../shared/components/navigate.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  List<OnboardingModel> onboarding = [
    OnboardingModel(
        image: 'assets/images/onboarding3.png',
        title: 'Search Products',
        description:
            'Search for your desired product or browse our curated collections'),
    OnboardingModel(
        image: 'assets/images/onboarding2.png',
        title: 'Get best Deals',
        description: 'Now, We are here to make sure you get the best deal'),
    OnboardingModel(
        image: 'assets/images/onboarding1.png',
        title: 'Check Out',
        description: 'Look through the deals and checkout from the company you want'),
  ];
  final _boardController = PageController();
  bool isLast = false;

  void submit() {
    CacheHelper.saveData(key: 'onboarding', value: true).then((value) {
      navigateAndFinish(context,
          LoginScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundOnboardColor,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              submit();
            },
            child: const Text(
              'SKIP',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: AppColors.buttonColor,
              ),
            ),
          )
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: PageView.builder(
            physics: const BouncingScrollPhysics(),
            controller: _boardController,
            itemBuilder: (BuildContext context, int index) =>
                buildOnboardingMode(onboarding[index]),
            itemCount: onboarding.length,
            onPageChanged: (int index) {
              if (index == onboarding.length - 1) {
                setState(() {
                  isLast = true;
                });
              } else {
                setState(() {
                  isLast = false;
                });
              }
            },
          )),
      backgroundColor: AppColors.backgroundOnboardColor,
    );
  }

  Widget buildOnboardingMode(OnboardingModel model) {
    double screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        children: [
          Image.asset(
            model.image,
            width:  300,
            height: screenHeight*0.3,
          ),
           SizedBox(
            height: screenHeight*0.05,
          ),
          SmoothPageIndicator(
            controller: _boardController,
            count: onboarding.length,
            effect: const ExpandingDotsEffect(
              activeDotColor: AppColors.buttonColor,
              dotColor: AppColors.elevColor,
              expansionFactor: 5,
              dotWidth: 10,
              dotHeight: 8,
              spacing: 5,
            ),
          ),
           SizedBox(
            height: screenHeight*0.05
          ),
          Text(
            model.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40.0,
            ),
          ),
          
          Padding(
            padding: isLast? const EdgeInsets.symmetric(horizontal: 35.0) : const EdgeInsets.symmetric(horizontal: 50.0),
            child: Text(
              model.description,
              style: const TextStyle(
                fontSize: 16.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Stack(
            children: [
              Positioned(
                top: 85.0,
                left: 45,
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: AppColors.elevColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 90.0, horizontal: 50.0),
                child: SizedBox(
                  width: 90.0,
                  height: 90.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonColor,
                      shape: const CircleBorder(),
                    ),
                    onPressed: () {
                      isLast
                          ? submit()
                          : _boardController.nextPage(
                              duration: const Duration(milliseconds: 750),
                              curve: Curves.fastLinearToSlowEaseIn);
                    },
                    child: Icon(
                      isLast ? Icons.done : Icons.arrow_forward_sharp,
                      color: AppColors.backgroundColor,
                      size: 35,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
