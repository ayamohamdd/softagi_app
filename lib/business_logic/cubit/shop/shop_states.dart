import 'package:store_app/presentation/models/favorits_model.dart';

abstract class ShopStates {}

class ShopInitialState extends ShopStates {}

class ShopChangeBottomNavState extends ShopStates {}

//class ShopChangeBottomNavIconColorState extends ShopStates{}

// Products
class ShopLoadingDataState extends ShopStates {}

class ShopSuccessDataState extends ShopStates {}

class ShopErrorDataState extends ShopStates {}

// Remove product image background

class ShopRemoveBgLoadingState extends ShopStates {}

class ShopRemoveBgSuccessState extends ShopStates {}

class ShopRemoveBgErrorState extends ShopStates {}

// Categories
class ShopSuccessCategoriesDataState extends ShopStates {}

class ShopErrorCategoriesDataState extends ShopStates {}

// change Favorits in home
class ShopInitialChangeFavoritsDataState extends ShopStates {}

class ShopSuccessChangeFavoritsDataState extends ShopStates {
  final ChangeFavoritsModel? model;

  ShopSuccessChangeFavoritsDataState(this.model);
}

class ShopErrorChangeFavoritsDataState extends ShopStates {}

// Favorites screen
class ShopSuccessGetFavoritsDataState extends ShopStates {}

class ShopErrorGetFavoritsDataState extends ShopStates {}
