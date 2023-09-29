import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_app/business_logic/cubit/home/shop_cubit.dart';
import 'package:store_app/business_logic/cubit/home/shop_states.dart';
import 'package:store_app/data/local/cache_helper.dart';
import 'package:store_app/presentation/models/login_model.dart';
import 'package:store_app/presentation/models/profile_model.dart';
import 'package:store_app/presentation/screens/auth/login.dart';
import 'package:store_app/presentation/screens/home/carts.dart';
import 'package:store_app/presentation/screens/profile/edit_profile.dart';
import 'package:store_app/presentation/screens/explore/explore.dart';
import 'package:store_app/shared/components/navigate.dart';
import 'package:store_app/shared/components/progress_indicator.dart';
import 'package:store_app/shared/constants/colors.dart';
import 'package:store_app/shared/constants/strings.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // @override
  List<SettingsModel> settings = [
    SettingsModel(
        icon: Icons.settings_outlined,
        settingName: 'Profile',
        navigateWidget: EditProfileScreen()),
    SettingsModel(
        icon: Icons.shopping_cart_checkout_outlined,
        settingName: 'Cart',
        navigateWidget: CartScreen()),
    SettingsModel(
        icon: Icons.favorite_border_outlined,
        settingName: 'Favorites',
        navigateWidget: FavouritsScreen()),
    SettingsModel(
        icon: Icons.info_outline,
        settingName: 'About Us',
        navigateWidget: EditProfileScreen()),
    SettingsModel(
      icon: Icons.logout_outlined,
      settingName: 'Logout',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: RefreshIndicator(
          onRefresh: () {
            return ShopCubit.get(context).getUser();
          },
          child: BlocBuilder<ShopCubit, ShopStates>(
            builder: (context, state) {
              //print(token);
              LoginModel? userModel = ShopCubit.get(context).userModel;
              // print(userModel!.data!.token);
              // print(userModel!.data!.image);

              return ConditionalBuilder(
                fallback: (context) => defaultCircularProgressIndicator(),
                condition: ShopCubit.get(context).userModel != null &&
                    ShopCubit.get(context).userModel!.data!.token != null,
                builder: (context) => Center(
                    child: ListView(children: [
                  SizedBox(
                    height: 195,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Container(
                            padding: EdgeInsets.zero,
                            height: 170,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: AppColors.buttonColor,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(40)),
                            ),
                          ),
                        ),
                        (userModel!.data!.image ==
                                    'https://student.valuxapps.com/storage/assets/defaults/user.jpg' ||
                                userModel.data!.image == null)
                            ? CircleAvatar(
                                radius: 58,
                                backgroundColor: AppColors.buttonColor,
                                child: CircleAvatar(
                                  radius: 54,
                                  backgroundColor: AppColors.backgroundColor,
                                  child: IconButton(
                                      onPressed: () {
                                        navigateTo(
                                            context, EditProfileScreen());
                                      },
                                      icon: const Icon(
                                        Icons.camera_alt,
                                        color: AppColors.buttonColor,
                                        size: 35,
                                      )),
                                ))
                            : CircleAvatar(
                                radius: 54,
                                backgroundColor: AppColors.backgroundColor,
                                child: CircleAvatar(
                                  radius: 50,
                                  //backgroundImage: Cac(image!)
                                  child: ClipOval(
                                      child: CachedNetworkImage(
                                          width: 230,
                                          height: 230,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              defaultCircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                          imageUrl: userModel.data!.image)),
                                ),
                              )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          userModel!.data!.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 19),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) =>
                              buildSettingMode(settings[index], index, context),
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(
                            height: 5,
                          ),
                          itemCount: settings.length,
                        )
                      ],
                    ),
                  ),
                ])),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildSettingMode(
          SettingsModel model, int index, BuildContext context) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
        child: InkWell(
          onTap: () {
            print('press');
            if (index == settings.length - 1) {
              //ShopCubit.get(context).state;
              ShopCubit.get(context).signOut(context);

              //navigateAndFinish(context, LoginScreen());

              //final shopCubit = context.read<ShopCubit>();
            }
            //navigateTo(context, model.navigateWidget);
          },
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
                color: AppColors.containerColor,
                borderRadius: BorderRadius.circular(15)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    index == settings.length - 1 ? null : model.icon,
                    color: AppColors.buttonColor,
                  ),
                  TextButton(
                      onPressed: () {
                        navigateTo(context, model.navigateWidget);
                      },
                      child: Text(
                        model.settingName,
                        style: TextStyle(
                            color: index == settings.length - 1
                                ? AppColors.errorColor
                                : AppColors.fontColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      )),
                  IconButton(
                      onPressed: () {
                        // navigateTo(context, widget);
                        navigateTo(context, model.navigateWidget);
                      },
                      icon: Icon(
                        index == settings.length - 1 ? model.icon : model.arrow,
                        color: AppColors.buttonColor,
                      ))
                ]),
          ),
        ),
      );
}
