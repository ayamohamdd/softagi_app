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
import 'package:store_app/shared/constants/var.dart';
import '../../../presentation/screens/explore/explore.dart';
import 'shop_states.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  LoginModel? userModel;
  HomeModel? homeModel;
  ProductDetailsModel? productDetailsModel;
  SearchModel? searchModel;
  ChangePasswordModel? changePasswordModel;
  CategoriesModel? categoriesModel;
  CategoryDetailsProductsModel? categoriesDetailsModel;
  CartModel? cartModel;
  FavoritesModel? favoritesModel;
  ChangeCartModel? changeCartModel;
  SignnoutModel? signoutModel;


  List<Widget> bottomScreens = [
    ProductsScreen(),
    const FavouritsScreen(),
    // CartScreen(),
    const ProfileScreen(),
  ];

  Map<int, bool?> favorites = {};
  Map<int, bool?> cart = {};
  int currentIndex = 0;
  Color? color;
  dynamic id;
  bool isCategoryPressed = false;
  int categoryIndex = 0;
  Color categoryColor = AppColors.elevColor;

  ShopCubit createNewShopCubit() {
    print('created');
    //currentIndex = 0;
    userModel!.data!.token = token!;
    return ShopCubit()..getUser();
  }

  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  // Home
  getHomeData() async {
    emit(ShopLoadingDataState());
    await DioHelper.getData(url: baseUrl + HOME, token: token).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      //productDetailsModel = ProductDetailsModel.fromJson(value.data);
      homeModel!.data!.products.forEach((element) {
        favorites.addAll({
          element.id: element.inFavorites,
        });
        cart.addAll({element.id: element.inCart});
        emit(ShopLoadingDataState());
      });
      emit(ShopSuccessDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorDataState());
    });
  }

  // Search
  void getSearchData(String? text) async {
    emit(ShopLoadingGetSearchDataState());
    await DioHelper.postData(
            url: baseUrl + SEARCH, data: {"text": text}, token: token)
        .then((value) {
      searchModel = SearchModel.fromJson(value.data);
      emit(ShopSuccessGetSearchDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetSearchDataState());
    });
  }

  // Product Details
  void getProductDetailsData(int id) async {
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

  // Profile
  getUser() async {
    print(token);
    emit(ShopLoadingGetProfileDataState());
    await DioHelper.getData(
      url: baseUrl + PROFILE,
      token: token,
    ).then((value) async {
      //print(token);
      if (value.statusCode == 200) {
        print(value.data);
        userModel = LoginModel.fromJson(value.data);
        print('userModel');

        emailAddress = userModel!.data!.email;
        final String userEmail = userModel!.data!.email;
        final String fileName = 'profile_image.jpg';

        final Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('user_images/$userEmail/$fileName');

        // Download the image
        await storageReference.getDownloadURL().then((url) {
          print(url);
          if (url !=
              'https://student.valuxapps.com/storage/assets/defaults/user.jpg') {
            userModel!.data!.image = url;
          }
        }).catchError((error) {
          print('Error downloading image: $error');
        });
        //  getImage(userModel!.data!.email);
        //  print(userModel);
        emit(ShopSuccessGetProfileDataState(userModel));
        return;
      } else {
        return;
      }
    }).catchError((error) {
      print('error in get use is: ');
      print(error.toString());
      emit(ShopErrorGetProfileDataState());
    });
  }

  // upload Image
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

      uploadTask.whenComplete(() async {
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

  // update profile image
  void updateUserProfile(String newImageURL) {
    // Update the user's image URL in your user data
    userModel!.data!.image = newImageURL;
    //getUser();
    emit(ShopSuccessGetProfileDataState(userModel));
  }

  // Update Profile
  void updateProfile({String? name, String? email, String? phone}) async {
    emit(ShopLoadingUpdateUserDataState());
    await DioHelper.putData(url: baseUrl + UPDATEPROFILE, token: token, data: {
      "name": name,
      "email": email,
      "phone": phone,
    }).then((value) {
      emit(ShopLoadingUpdateUserDataState());
      print('value.data ${value.data}');
      getUser();
      // emit(ShopSuccessUpdateUserDataState());
    }).catchError((error) {
      print('error in update profile is: ');
      print(error.toString());
      emit(ShopErrorUpdateUserDataState());
    });
  }

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

  // on Category Pressed
  void categoryPressed(int index) {
    isCategoryPressed = true;
    categoryIndex = index;
    categoryColor = AppColors.elevColor;
    emit(ShopCategoryPressedState());
  }
  
  // categories
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

  // category details
  void getCategoriesDetailsData(int categoryId) async {
    emit(ShopLoadingCategoriesDetailsDataState());
    await DioHelper.getData(
            url: baseUrl + CATRGORIES + '/$categoryId', token: token)
        .then((value) {
      categoriesDetailsModel =
          CategoryDetailsProductsModel.fromJson(value.data);
      emit(ShopSuccessCategoriesDetailsDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorCategoriesDetailsDataState());
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

  // Get cart
  void getCartData() async {
    emit(ShopLoadingGetCartDataState());
    await DioHelper.getData(url: baseUrl + CART, token: token).then((value) {
      cartModel = CartModel.fromJson(value.data);
      printFullText(value.data.toString());
      print(
          'product  ${cartModel!.cartData!.cartItemData[0].productData!.name}');
      if (cartModel?.cartData?.cartItemData.isEmpty == true) {
        //emit(ShopEmptyCartDataState());
        return;
      } else {
        emit(ShopSuccessGetCartDataState());
      }
    }).catchError((error) {
      print('error in cart is ${error.toString()}');
      emit(ShopErrorGetCartDataState());
    });
  }

  // Change Cart
  void changeCart(int productId) async {
    print(cart[55]);
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
        token = '';
        userModel!.data!.token = '';
        userModel!.data!.email = '';
        //categories.clear();
        //  userModel!.data = null;
        emit(ShopSuccessLogoutState(signoutModel));
        //  userModel = null;
        resetState();

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

  void resetState() {
    print('After reset: $state');
    token = '';
    userModel!.data!.token = '';
    favorites.clear();
    emit(ShopInitialState());

    print('After reset: $state');
  }
}
