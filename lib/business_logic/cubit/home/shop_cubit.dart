import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/data/remote/dio_helper.dart';
import 'package:store_app/presentation/models/categories_model.dart';
import 'package:store_app/presentation/models/favorites_model.dart';
import 'package:store_app/presentation/models/change_favorits_model.dart';
import 'package:store_app/presentation/models/login_model.dart';
import 'package:store_app/presentation/models/product_details_model.dart';
import 'package:store_app/presentation/models/product_model.dart';
import 'package:store_app/presentation/models/profile_model.dart';
import 'package:store_app/presentation/screens/home.dart';
import 'package:store_app/presentation/screens/profile.dart';
import 'package:store_app/shared/constants/colors.dart';
import 'package:store_app/shared/constants/strings.dart';
import 'package:store_app/shared/constants/temp.dart';
import '../../../presentation/screens/explore.dart';
import 'shop_states.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  Color? color;
  List<Widget> bottomScreens = [
    ProductsScreen(),
    const FavouritsScreen(),
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

  List<ProductModel> electrionicDeviceCategory = [];
  List<ProductModel> clothesCategory = [];
  List<ProductModel> lightCategory = [];
  List<ProductModel> sportsCategory = [];
  List<ProductModel> coronaCategory = [];

  List<List> categories = [];
  //Home
  void getHomeData() {
    emit(ShopLoadingDataState());
    DioHelper.getData(url: baseUrl + HOME, token: token).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      //productDetailsModel = ProductDetailsModel.fromJson(value.data);
      homeModel!.data!.products.forEach((element) {
        favorites.addAll({
          element.id: element.inFavorites,
        });

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

// Product Details
  dynamic id;
  void getProductDetailsData() {
    emit(ProductLoadingDataState());
    DioHelper.getData(
      url: baseUrl + PRODUCTS + '$id',
      token: token,
    ).then((value) {
      productDetailsModel = ProductDetailsModel.fromJson(value.data);
      emit(ProductSuccessDataState());
    }).catchError((error) {
      print('error is: ');
      print(error.toString());
      emit(ProductErrorDataState());
    });
  }

  LoginModel? userModel;
  void getUser() {
    emit(ShopLoadingGetProfileDataState());
    DioHelper.getData(
      url: baseUrl + PROFILE,
      token: token,
    ).then((value) {
      print(value.statusCode);
      print(value.data);
      userModel = LoginModel.fromJson(value.data);
      print(userModel);
      emit(ShopSuccessGetProfileDataState(userModel));
    }).catchError((error) {
      print('error is: ');
      print(error.toString());
      emit(ShopErrorGetProfileDataState());
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
  void getCategoriesData() {
    emit(ShopLoadingDataState());
    DioHelper.getData(url: baseUrl + CATRGORIES, token: token).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);

      emit(ShopSuccessCategoriesDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorCategoriesDataState());
    });
  }

  // Change Favorites
  ChangeFavoritsModel? changeFavoritsModel;
  void changeFavorits(int productId) {
    favorites[productId] = !favorites[productId]!;
    emit(ShopInitialChangeFavoritsDataState());
    DioHelper.postData(
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
  void getFavoritesData() {
    emit(ShopLoadingGetFavoritsDataState());
    DioHelper.getData(url: baseUrl + FAVORITES, token: token).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      printFullText(value.data.toString());
      emit(ShopSuccessGetFavoritsDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetFavoritsDataState());
    });
  }

  // Profile
  // LoginModel? userModel;
  // void getUser() {
  //   emit(ShopLoadingGetProfileDataState());
  //   DioHelper.getData(url: baseUrl + PROFILE, token: token).then((value) {
  //     userModel = LoginModel.fromJson(value.data);
  //     printFullText(value.data.name);
  //     emit(ShopSuccessGetProfileDataState(userModel));
  //   }).catchError((error) {
  //     print(error.toString());
  //     emit(ShopErrorGetProfileDataState());
  //   });
  // }
}
