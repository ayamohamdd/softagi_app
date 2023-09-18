import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/business_logic/cubit/home/shop_cubit.dart';
import 'package:store_app/shared/constants/colors.dart';

import '../../business_logic/cubit/home/shop_states.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopCubit.get(context);
        // Change color of icon
        Color? color = Colors.white;

        Color? changeBottomIconColor(int index) {
          if (index == cubit.currentIndex) {
            color = Colors.white;
          } else {
            color = AppColors.iconColor;
          }
          return color;
        }

        // Curved Nav Bar
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: cubit.bottomScreens[cubit.currentIndex],
          bottomNavigationBar: Container(
            padding:
                const EdgeInsets.only(bottom: 8.0, left: 5, right: 5, top: 3),
            height: 100.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                //color: AppColors.backgroundColor
                ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(70),
              child: CurvedNavigationBar(
                  backgroundColor: Colors.white,
                  buttonBackgroundColor: AppColors.buttonColor,
                  //fixedColor: AppColors.backgroundColor,
                  color: AppColors.buttonColor,
                  animationDuration: const Duration(milliseconds: 300),
                  onTap: (index) {
                    cubit.changeBottom(index);
                  },
                  items: [
                    Icon(
                      Icons.home,
                      color: changeBottomIconColor(0),
                      size: 30,
                    ),
                    Icon(
                      Icons.explore,
                      color: changeBottomIconColor(1),
                      size: 30,
                    ),
                    // Icon(
                    //   Icons.favorite,
                    //   color: changeBottomIconColor(2),
                    //   size: 30,
                    // ),
                    Icon(
                      Icons.settings,
                      color: changeBottomIconColor(3),
                      size: 30,
                    ),
                  ]),
            ),
          ),
        );
      },
    );
  }
}
