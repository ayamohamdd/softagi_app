import 'dart:io';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_app/business_logic/cubit/home/shop_cubit.dart';
import 'package:store_app/business_logic/cubit/home/shop_states.dart';
import 'package:store_app/data/local/cache_helper.dart';
import 'package:store_app/presentation/models/login_model.dart';
import 'package:store_app/presentation/models/profile_model.dart';
import 'package:store_app/presentation/screens/carts.dart';
import 'package:store_app/presentation/screens/edit_profile.dart';
import 'package:store_app/presentation/screens/explore.dart';
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
  File? image;
  String? imageUrl;
  final imagePicker = ImagePicker();
  Future uploadImage() async {
    var pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) {
      return;
    }
    final imageTemporary = File(pickedImage.path);
    setState(() {
      image = imageTemporary;
    });
    await CacheHelper.sharedPreferences
        .setString(emailAddress.toString(), image!.path);
  }

  // @override
  // void initState() {
  //   if (CacheHelper.sharedPreferences.getString(emailAddress.toString()) ==
  //       null) return;
  //   print(emailAddress);
  //   if (emailAddress != null) {
  //     image = File(
  //         CacheHelper.sharedPreferences.getString(emailAddress.toString())!);
  //   }
  //   super.initState();
  // }
  // void getImage() {
  //   if (CacheHelper.sharedPreferences.getString(emailAddress.toString()) ==
  //       null) return;
  //   if (emailAddress != null) {
  //     image = File(
  //         CacheHelper.sharedPreferences.getString(emailAddress.toString())!);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        LoginModel? userModel = ShopCubit.get(context).userModel;
        print(userModel);
        // ShopCubit.get(context).getImage();

        return SafeArea(
          child: ConditionalBuilder(
            fallback: (context) => defaultCircularProgressIndicator(),
            condition: ShopCubit.get(context).userModel != null,
            builder: (context) => Scaffold(
              backgroundColor: AppColors.backgroundColor,
              body: Center(
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
                      (image == null)
                          ? CircleAvatar(
                              radius: 58,
                              backgroundColor: AppColors.buttonColor,
                              child: CircleAvatar(
                                radius: 54,
                                backgroundColor: AppColors.backgroundColor,
                                child: IconButton(
                                    onPressed: uploadImage,
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
                                  backgroundImage: FileImage(image!)),
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
                            buildSettingMode(settings[index], index),
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
            ),
          ),
        );
      },
    );
  }

  Widget buildSettingMode(SettingsModel model, int index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
        child: InkWell(
          onTap: () {
            print('press');
            //   if (index == settings.length - 1) {
            //     ShopCubit.get(context).state;
            //  //   ShopCubit.get(context).signOut(context);
            //   }
                        navigateTo(context, model.navigateWidget);

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
