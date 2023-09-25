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
          body: AnimatedSwitcher(
            duration:
                Duration(milliseconds: 400), // Adjust the duration as needed
            child: cubit.bottomScreens[cubit.currentIndex],
          ),
          bottomNavigationBar: Stack(
            children: [
              AnimatedContainer(
                padding:
                    const EdgeInsets.only(bottom: 8.0, left: 5, right: 6, top: 3),
                height: 75.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  //color: AppColors.backgroundColor
                ),
                duration: Duration(milliseconds: 400),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(70),
                  child: BottomNavigationBar(
                      iconSize: 28,
                      type: BottomNavigationBarType.fixed,
                      backgroundColor: AppColors.buttonColor,
                      //fixedColor: AppColors.backgroundColor,
                      unselectedItemColor: AppColors.iconColor,
                      selectedItemColor: Colors.white,
                      showUnselectedLabels: false,
                      currentIndex: cubit.currentIndex,
                      onTap: (index) {
                        cubit.changeBottom(index);
                      },
                      items: const [
                        BottomNavigationBarItem(
                            icon: Icon(Icons.home), label: 'Home'),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.explore), label: 'Explore'),
                        // BottomNavigationBarItem(
                        //     icon: Icon(Icons.favorite), label: 'Favourits'),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.settings), label: 'Settings'),
                      ]),
                ),
              ),
            Positioned(
                top: 2.5,
                left: (cubit.currentIndex) * (MediaQuery.of(context).size.width / 3)+35,
                child: Container(
                  
                  width: 52,
                  height: 2,
                  
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
