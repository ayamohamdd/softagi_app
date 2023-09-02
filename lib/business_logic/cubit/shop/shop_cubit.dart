import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/data/remote/dio_helper.dart';
import 'package:store_app/presentation/models/product_model.dart';
import 'package:store_app/presentation/screens/categories.dart';
import 'package:store_app/presentation/screens/products.dart';
import 'package:store_app/presentation/screens/settings.dart';
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
  void getHomeData() {
    emit(ShopLoadingDataState());
    DioHelper.getData(url: baseUrl + HOME, token: token).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      printFullText(homeModel!.data!.banners[0].image);
      printFullText(homeModel!.data!.products[0].image);
      emit(ShopSuccessDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorDataState());
    });
  }

  // Color? changeBottomIconColor(int index) {
  //   if (index == currentIndex) {
  //     color = Colors.white;
  //   } else {
  //     color = AppColors.iconColor;
  //   }
  //   emit(ShopChangeBottomNavIconColorState());
  //   return color;
  // }
}
