import 'dart:io';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_app/business_logic/cubit/home/shop_cubit.dart';
import 'package:store_app/business_logic/cubit/home/shop_states.dart';
import 'package:store_app/data/local/cache_helper.dart';
import 'package:store_app/presentation/models/login_model.dart';
import 'package:store_app/shared/components/button.dart';
import 'package:store_app/shared/components/form.dart';
import 'package:store_app/shared/components/progress_indicator.dart';
import 'package:store_app/shared/constants/colors.dart';
import 'package:store_app/shared/constants/temp.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? image;
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
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(image);
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        UserData? userData = ShopCubit.get(context).userModel!.data;
        email.text = userData!.email;
        name.text = userData.name;
        phone.text = userData.phone;
        return Scaffold(
          appBar: AppBar(
            title: const Text('My profile'),
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
          body: Padding(
            padding: const EdgeInsets.only(
              top: 40.0,
            ),
            child: ConditionalBuilder(
              condition: state is!ShopLoadingGetProfileDataState,
                fallback: (context) => defaultCircularProgressIndicator(),
                builder: (context) =>
               ListView(children: [
                image == null
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
                        radius: 70,
                        backgroundColor: AppColors.containerColor,
                        child: Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                                radius: 65, backgroundImage: FileImage(image!)),
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.buttonColor,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: AppColors.containerColor,
                                  size: 22,
                                ),
                                onPressed: uploadImage,
                              ),
                            )
                          ],
                        ),
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
                              controller: name,
                              type: TextInputType.name,
                              label: 'Enter Your Name',
                              prefix: Icons.person_outline,
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
                              controller: email,
                              type: TextInputType.emailAddress,
                              label: 'Enter Your Email',
                              prefix: Icons.email_outlined,
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
                              controller: phone,
                              type: TextInputType.phone,
                              label: 'Enter Your Phone',
                              prefix: Icons.phone_android_outlined,
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return "Phone mustn't be empty ";
                                }
                                // if (!emailValid.hasMatch(value)) {
                                //   return 'Enter valid phone ';
                                // }
                                return null;
                              }),
                          const SizedBox(
                            height: 18.0,
                          ),
                          defaultButton(
                              onPressed: () {},
                              text: 'Change Password',
                              color: AppColors.containerColor,
                              textColor: AppColors.fontColor,
                              isUpperCase: false,
                              fontWeight: FontWeight.w400,
                              radius: 50),
                          const SizedBox(
                            height: 50.0,
                          ),
                          defaultButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  ShopCubit.get(context).updateProfile(
                                      email: email.text,
                                      name: name.text,
                                      phone: phone.text);
                                }
                              },
                              text: 'Save Changes',
                              width: 250,
                              isUpperCase: false)
                        ],
                      ),
                    ),
                  ),
                
              ]),
            ),
          ),
        );
      },
    );
  }
}
