import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/data/remote/dio_helper.dart';
import 'package:store_app/presentation/models/categories_model.dart';
import 'package:store_app/presentation/models/favorites_model.dart';
import 'package:store_app/presentation/models/favorits_model.dart';
import 'package:store_app/presentation/models/product_model.dart';
import 'package:store_app/presentation/screens/categories.dart';
import 'package:store_app/presentation/screens/products.dart';
import 'package:store_app/presentation/screens/settings.dart';
import 'package:store_app/shared/components/remove_background.dart';
import 'package:store_app/shared/constants/strings.dart';
import 'package:store_app/shared/constants/temp.dart';
import '../../../presentation/screens/favourits.dart';
import 'shop_states.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  Color? color;
  List<Widget> bottomScreens = [
    ProductsScreen(),
    const CategoriesScreen(),
    const FavouritsScreen(),
    const SettingsScreen(),
  ];

  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel;
  Map<int, bool?> favorits = {};
  void getHomeData() {
    emit(ShopLoadingDataState());
    DioHelper.getData(url: baseUrl + HOME, token: token).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      homeModel!.data!.products.forEach((element) {
        favorits.addAll({
          element.id: element.inFavorites,
        });
      });
      print(favorits.toString());
      emit(ShopSuccessDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorDataState());
    });
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

  ChangeFavoritsModel? changeFavoritsModel;
  void changeFavorits(int productId) {
    favorits[productId] = !favorits[productId]!;
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
        favorits[productId] = !favorits[productId]!;
      }
      print(value.data);
      emit(ShopSuccessChangeFavoritsDataState(changeFavoritsModel));
    }).catchError((error) {
      favorits[productId] = !favorits[productId]!;

      print(error.toString());
      emit(ShopErrorChangeFavoritsDataState());
    });
  }

  FavoritesModel? favoritesModel;
  void getFavoritesData() {
    emit(ShopSuccessGetFavoritsDataState());
    DioHelper.getData(url: baseUrl + FAVORITES, token: token).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);

      printFullText(value.data.toString());
      emit(ShopSuccessGetFavoritsDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetFavoritsDataState());
    });
  }
}
