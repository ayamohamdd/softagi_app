import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/data/local/cache_helper.dart';
import 'package:store_app/data/remote/dio_helper.dart';
import 'package:store_app/presentation/models/cart_model.dart';
import 'package:store_app/presentation/models/categories_model.dart';
import 'package:store_app/presentation/models/change_cart_model.dart';
import 'package:store_app/presentation/models/change_password_model.dart';
import 'package:store_app/presentation/models/favorites_model.dart';
import 'package:store_app/presentation/models/change_favorits_model.dart';
import 'package:store_app/presentation/models/login_model.dart';
import 'package:store_app/presentation/models/product_details_model.dart';
import 'package:store_app/presentation/models/product_model.dart';
import 'package:store_app/presentation/models/profile_model.dart';
import 'package:store_app/presentation/models/search_model.dart';
import 'package:store_app/presentation/screens/auth/login.dart';
import 'package:store_app/presentation/screens/home/carts.dart';
import 'package:store_app/presentation/screens/home/home.dart';
import 'package:store_app/presentation/screens/profile/profile.dart';
import 'package:store_app/shared/components/navigate.dart';
import 'package:store_app/shared/constants/colors.dart';
import 'package:store_app/shared/constants/strings.dart';
import 'package:store_app/shared/constants/temp.dart';
import '../../../presentation/screens/explore/explore.dart';
import 'shop_states.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);


  int currentIndex = 0;
  Color? color;
  List<Widget> bottomScreens = [
    ProductsScreen(),
    const FavouritsScreen(),
    // CartScreen(),
    const ProfileScreen(),
  ];

  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel;
  ProductDetailsModel? productDetailsModel;

  //ProductDetailsData? productDetailsData;

  Map<int, bool?> favorites = {};
  Map<int, bool?> cart = {};

  List<ProductModel> electrionicDeviceCategory = [];
  List<ProductModel> clothesCategory = [];
  List<ProductModel> lightCategory = [];
  List<ProductModel> sportsCategory = [];
  List<ProductModel> coronaCategory = [];

  List<List> categories = [];
  // Start Home
  void getHomeData() async {
    emit(ShopLoadingDataState());
    await DioHelper.getData(url: baseUrl + HOME, token: token).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      //productDetailsModel = ProductDetailsModel.fromJson(value.data);
      homeModel!.data!.products.forEach((element) {
        favorites.addAll({
          element.id: element.inFavorites,
        });
        cart.addAll({element.id: element.inCart});
        //print(cart[55]);
        // productDetailsModel!.data!.data.forEach((element) {
        //   favorites.addAll({
        //     element.id: element.inFavorites,
        //   });
        if (element.id >= 90 && element.id <= 92) {
          clothesCategory.add(element);
        } else if (element.id == 88) {
          lightCategory.add(element);
        } else if (element.id >= 84 && element.id <= 85 || element.id == 58) {
          sportsCategory.add(element);
        } else if (element.id >= 80 && element.id <= 81) {
          coronaCategory.add(element);
        } else {
          electrionicDeviceCategory.add(element);
        }
        categories.insert(0, electrionicDeviceCategory);
        categories.insert(1, coronaCategory);
        categories.insert(2, sportsCategory);
        categories.insert(3, lightCategory);
        categories.insert(4, clothesCategory);
      });

      print(favorites.toString());
      emit(ShopSuccessDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorDataState());
    });
  }

  // Search
  SearchModel? searchModel;
  void getSearchData(String? text) async {
    emit(ShopLoadingGetSearchDataState());
    await DioHelper.postData(url: baseUrl + SEARCH, data: {"text": text})
        .then((value) {
      searchModel = SearchModel.fromJson(value.data);
      emit(ShopSuccessGetSearchDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetSearchDataState());
    });
  }

  // Product Details
  dynamic id;
  void getProductDetailsData() async {
    if (id == null) return;
    emit(ProductLoadingDataState());
    await DioHelper.getData(
      url: baseUrl + PRODUCTS + '$id',
      token: token,
    ).then((value) {
      productDetailsModel = ProductDetailsModel.fromJson(value.data);
      emit(ProductSuccessDataState());
    }).catchError((error) {
      print('error in product details is: ');
      print(error.toString());
      emit(ProductErrorDataState());
    });
  }

  LoginModel? userModel;
  void getUser() async {
    emit(ShopLoadingGetProfileDataState());
    await DioHelper.getData(
      url: baseUrl + PROFILE,
      token: token,
    ).then((value) {
      userModel = LoginModel.fromJson(value.data);
      print(userModel);
      emailAddress = userModel!.data!.email;
      final String userEmail = userModel!.data!.email;
      final String fileName = 'profile_image.jpg';

      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('user_images/$userEmail/$fileName');

      // Download the image
      storageReference.getDownloadURL().then((url) {
        print(url);
        if (url !=
            'https://student.valuxapps.com/storage/assets/defaults/user.jpg') {
          userModel!.data!.image = url;
        }
      }).catchError((error) {
        print('Error downloading image: $error');
      });
      //  getImage(userModel!.data!.email);
      print(userModel);
      emit(ShopSuccessGetProfileDataState(userModel));
    }).catchError((error) {
      print('error in get use is: ');
      print(error.toString());
      emit(ShopErrorGetProfileDataState());
    });
  }

  Future<void> uploadImage({
    required File image,
    required String userEmail,
  }) async {
    emit(ShopSuccessProfileImageUploadState());

    try {
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('user_images/$userEmail/profile_image.jpg');

      UploadTask uploadTask = storageReference.putFile(image);

      await uploadTask.whenComplete(() async {
        final String imageURL = await storageReference.getDownloadURL();
        updateUserProfile(imageURL);
        // Image uploaded successfully
        emit(ShopSuccessProfileImageUploadState());
      });
    } catch (e) {
      // Handle errors
      print(e.toString());
      emit(ShopErrorProfileImageUploadState());
    }
  }

  void updateUserProfile(String newImageURL) {
    // Update the user's image URL in your user data
    userModel!.data!.image = newImageURL;
    emit(ShopSuccessGetProfileDataState(userModel));
  }

  // Get image
  // void getImage(String emailAddress) {
  //   emit(ShopLoadingGetImageDataState());
  //   //getUser();
  //   final String userEmail =  emailAddress;
  //   final String fileName = 'profile_image.jpg';
  //   if (userEmail != null) {
  //     final Reference storageReference = FirebaseStorage.instance
  //         .ref()
  //         .child('user_images/$userEmail/$fileName');
  //     // Download the image
  //     storageReference.getDownloadURL().then((url) {
  //       imageUrl = url;
  //       emit(ShopSuccessGetImageDataState());
  //     }).catchError((error) {
  //       print('Error downloading image: $error');
  //       emit(ShopErrorGetImageDataState());
  //     });
  //     // Trigger the image upload when the screen is first loaded
  //     //uploadImage();
  //   }
  // }
  // // End Home

// Update Profile
  void updateProfile(
      {String? name, String? email, String? phone, String? image}) async {
    emit(ShopLoadingUpdateUserDataState());
    await DioHelper.putData(url: baseUrl + UPDATEPROFILE, token: token, data: {
      "name": name,
      "email": email,
      "phone": phone,
      "image": image
    }).then((value) {
      print('value.data ${value.data}');
      getUser();
    }).catchError((error) {
      print('error in update profile is: ');
      print(error.toString());
      emit(ShopErrorUpdateUserDataState());
    });
  }

  ChangePasswordModel? changePasswordModel;
  // Change Password
  void changePassword(String currentPassword, String newPassword) async {
    emit(ShopLoadingChangePasswordState());
    await DioHelper.postData(
      url: baseUrl + CHANGEPASSWORD,
      data: {'current_password': currentPassword, 'new_password': newPassword},
      token: token,
    ).then((value) {
      changePasswordModel = ChangePasswordModel.fromJson(value.data);
      print('Changes');
      print(value.data);
      emit(ShopSuccessChangePasswordState(changePasswordModel!));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorChangePasswordState());
    });
  }

  bool isCategoryPressed = false;
  int categoryIndex = 0;
  Color categoryColor = AppColors.elevColor;

  // on Category Pressed
  void categoryPressed(int index) {
    isCategoryPressed = true;
    categoryIndex = index;
    categoryColor = AppColors.elevColor;
    emit(ShopCategoryPressedState());
  }

  // get category name
  String getCategoryName(int index) {
    switch (index) {
      case 0:
        return 'All';
      case 1:
        return 'Electrionics';
      case 2:
        return 'Corona';
      case 3:
        return 'Sports';
      case 4:
        return 'Lighting';
      default:
        return 'Clothes';
    }
  }

  CategoriesModel? categoriesModel;
  void getCategoriesData() async {
    emit(ShopLoadingDataState());
    await DioHelper.getData(url: baseUrl + CATRGORIES, token: token)
        .then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(ShopSuccessCategoriesDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorCategoriesDataState());
    });
  }

  // Change Favorites
  ChangeFavoritsModel? changeFavoritsModel;
  void changeFavorits(int productId) async {
    favorites[productId] = !favorites[productId]!;
    emit(ShopInitialChangeFavoritsDataState());
    await DioHelper.postData(
      url: baseUrl + FAVORITES,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then((value) {
      changeFavoritsModel = ChangeFavoritsModel.fromJson(value.data);
      if (changeFavoritsModel?.status == false) {
        favorites[productId] = !favorites[productId]!;
      } else {
        getFavoritesData();
        emit(ShopLoadingGetFavoritsDataState());
      }
      print(value.data);
      emit(ShopSuccessChangeFavoritsDataState(changeFavoritsModel));
    }).catchError((error) {
      favorites[productId] = !favorites[productId]!;

      print(error.toString());
      emit(ShopErrorChangeFavoritsDataState());
    });
  }

  // Get Favorites
  FavoritesModel? favoritesModel;
  void getFavoritesData() async {
    emit(ShopLoadingGetFavoritsDataState());
    await DioHelper.getData(url: baseUrl + FAVORITES, token: token)
        .then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      printFullText(value.data.toString());
      emit(ShopSuccessGetFavoritsDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetFavoritsDataState());
    });
  }

  CartModel? cartModel;
  void getCartData() async {
    //emit(ShopLoadingGetCartDataState());
    await DioHelper.getData(url: baseUrl + CART, token: token).then((value) {
      cartModel = CartModel.fromJson(value.data);
      printFullText(value.data.toString());
      print(
          'product  ${cartModel!.cartData!.cartItemData[0].productData!.name}');
      if (cartModel?.cartData?.cartItemData.isNotEmpty == true) {
        emit(ShopSuccessGetCartDataState());
      } else {
        emit(ShopEmptyCartDataState());
      }
    }).catchError((error) {
      print('error in cart is ${error.toString()}');
      emit(ShopErrorGetCartDataState());
    });
  }

  // Change Cart
  ChangeCartModel? changeCartModel;
  void changeCart(int productId) async {
    cart[productId] = !cart[productId]!;
    emit(ShopLoadingChangeCartDataState());
    await DioHelper.postData(
      url: baseUrl + CART,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then((value) {
      changeCartModel = ChangeCartModel.fromJson(value.data);
      if (changeCartModel?.status == false) {
        cart[productId] = !cart[productId]!;
      } else {
        emit(ShopLoadingChangeCartDataState());

        getCartData();
        emit(ShopLoadingGetCartDataState());
      }
      print('value.data ${value.data}');
      emit(ShopSuccessChangeCartDataState(changeCartModel));
    }).catchError((error) {
      cart[productId] = !cart[productId]!;
      print(error.toString());
      emit(ShopErrorChangeCartDataState());
    });
  }

  // Update Cart
  void updateCart({
    required int quantity,
    required int id,
  }) async {
    emit(ShopLoadingUpdateCartDataState());
    await DioHelper.putData(
        url: baseUrl + '$CART/$id',
        token: token,
        data: {"quantity": quantity}).then((value) {
      print('value.data ${value.data}');
      getCartData();
    }).catchError((error) {
      print('error in update cart is: ');
      print(error.toString());
      emit(ShopErrorUpdateCartDataState());
    });
  }

  void deleteCart({
    required int id,
    required int productIid,
  }) async {
    emit(ShopLoadingDeleteCartDataState());
    await DioHelper.deleteData(url: baseUrl + '$CART/$id', token: token)
        .then((value) {
      getCartData();
      changeCart(productIid);
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorDeleteCartDataState());
    });
  }

  SignnoutModel? signoutModel;
  void signOut(BuildContext context) async {
    emit(ShopLoadingLogoutState());
    await DioHelper.postData(
            url: baseUrl + LOGOUT, data: {"fcm_token": token}, token: token)
        .then((value) async {
      print(value.data);
      //print('token=$token');

      //print('Done');
      //  print(signoutModel!.message);
      try {
        signoutModel = SignnoutModel.fromJson(value.data);
        emit(ShopSuccessLogoutState(signoutModel));
        //disposeShopCubit(context);
      } catch (e) {
        print('Error parsing JSON: $e');
      }

      print(signoutModel!.message);
    }).catchError((error) {
      print('error');
      print(error.toString());
      emit(ShopErrorLogoutState());
    });
  }

  void disposeShopCubit(BuildContext context) {
    final shopCubit = context.read<ShopCubit>();
    shopCubit.close();
  }

  
}
