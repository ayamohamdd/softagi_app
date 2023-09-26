import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_app/business_logic/cubit/home/shop_cubit.dart';
import 'package:store_app/business_logic/cubit/home/shop_states.dart';
import 'package:store_app/data/local/cache_helper.dart';
import 'package:store_app/presentation/models/login_model.dart';
import 'package:store_app/presentation/screens/profile/change_password.dart';
import 'package:store_app/shared/components/button.dart';
import 'package:store_app/shared/components/form.dart';
import 'package:store_app/shared/components/navigate.dart';
import 'package:store_app/shared/components/progress_indicator.dart';
import 'package:store_app/shared/constants/colors.dart';
import 'package:store_app/shared/constants/strings.dart';
import 'package:store_app/shared/constants/temp.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? image;
  String? imageUrl;
  final imagePicker = ImagePicker();
  @override
  // void initState() {
  //   super.initState();

  //   // Use the user's email address to construct the Firebase Storage reference
  //   final String userEmail = emailAddress!;
  //   final String fileName = 'profile_image.jpg';

  //   final Reference storageReference = FirebaseStorage.instance
  //       .ref()
  //       .child('user_images/$userEmail/$fileName');

  //   // Download the image
  //   storageReference.getDownloadURL().then((url) {
  //     setState(() {
  //       imageUrl = url;
  //     });
  //   }).catchError((error) {
  //     print('Error downloading image: $error');
  //   });
  //   // Trigger the image upload when the screen is first loaded
  //   //uploadImage();
  // }

  Future<void> uploadImage() async {
    try {
      final String userEmail = emailAddress!;
      if (image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an image to upload.'),
          ),
        );
        return;
      }

      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('user_images/$userEmail/profile_image.jpg');

      UploadTask uploadTask = storageReference.putFile(image!);

      await uploadTask.whenComplete(() {
        // Image uploaded successfully
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image uploaded successfully!'),
          ),
        );
        ShopCubit.get(context).getUser();
      });
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading image: $e'),
        ),
      );
    }
  }

  // Future pickImage() async {
  //   var pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
  //   if (pickedImage == null) {
  //     return;
  //   }
  //   if (pickedImage != null) {
  //     // Handle the picked image (e.g., upload it and update the user's profile)
  //     ShopCubit.get(context).uploadImage(
  //       image: File(pickedImage.path),
  //       userEmail: ShopCubit.get(context).userModel!.data!.email,
  //     );
  //   }
  //   final imageTemporary = File(pickedImage.path);
  //   setState(() {
  //     image = imageTemporary;
  //     ShopCubit.get(context).userModel!.data!.image = image!.path;
  //   });
  //   ShopCubit.get(context).uploadImage(
  //       image: image!,
  //       userEmail: ShopCubit.get(context).userModel!.data!.email);
  // }

  Future<void> pickImage() async {
  final imagePicker = ImagePicker();

  // Show a dialog with options for choosing the image source
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Select Image Source'),
        actions: <Widget>[
          TextButton(
            child: Text('Camera',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.buttonColor),),
            onPressed: () async {
              Navigator.of(context).pop();
              var pickedImage = await imagePicker.pickImage(
                source: ImageSource.camera,
              );
              if (pickedImage != null) {
                handlePickedImage(File(pickedImage.path));
              }
            },
          ),
          TextButton(
            child: Text('Gallery',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.buttonColor),),
            onPressed: () async {
              Navigator.of(context).pop();
              var pickedImage = await imagePicker.pickImage(
                source: ImageSource.gallery,
              );
              if (pickedImage != null) {
                handlePickedImage(File(pickedImage.path));
              }
            },
          ),
        ],
      );
    },
  );
}
void handlePickedImage(File imageFile) {
  setState(() {
    image = imageFile;
    ShopCubit.get(context).userModel!.data!.image = imageFile.path;
  });
  ShopCubit.get(context).uploadImage(
    image: imageFile,
    userEmail: ShopCubit.get(context).userModel!.data!.email,
  );
}

  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(image);
    return BlocBuilder<ShopCubit, ShopStates>(
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
              condition: state is! ShopLoadingProfileImageUploadState &&
                  state is! ShopLoadingGetProfileDataState,
              fallback: (context) => defaultCircularProgressIndicator(),
              builder: (context) => ListView(children: [
                userData.image ==
                            'https://student.valuxapps.com/storage/assets/defaults/user.jpg' ||
                        userData.image == null
                    ? CircleAvatar(
                        radius: 58,
                        backgroundColor: AppColors.buttonColor,
                        child: CircleAvatar(
                          radius: 54,
                          backgroundColor: AppColors.backgroundColor,
                          child: IconButton(
                              onPressed: () {
                                pickImage();
                                //uploadImage();
                              },
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
                              radius: 65,
                              backgroundColor: AppColors.backgroundColor,
                              // backgroundImage: CachedNetworkImageProvider(imageUrl!)
                              child: ClipOval(
                                  child: CachedNetworkImage(
                                width: 230,
                                height: 230,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    defaultCircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    defaultCircularProgressIndicator(),
                                //    Center(child: Text('Image will be uploaded soon',style: TextStyle(fontSize: 12,color: AppColors.fontColor),textAlign: TextAlign.center,),),
                                imageUrl: userData.image,
                              )),
                            ),
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.buttonColor,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: AppColors.containerColor,
                                  size: 22,
                                ),
                                onPressed: () async {
                                  pickImage();
                                  // ShopCubit.get(context).getUser();
                                  print('image ${userData.image}');
                                },
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
                            onPressed: () {
                              navigateTo(context, ChangePasswordScreen());
                            },
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
