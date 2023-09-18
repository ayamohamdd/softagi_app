import 'package:store_app/presentation/models/change_favorits_model.dart';
import 'package:store_app/presentation/models/product_details_model.dart';

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
class ShopLoadingGetFavoritsDataState extends ShopStates {}

class ShopSuccessGetFavoritsDataState extends ShopStates {}

class ShopErrorGetFavoritsDataState extends ShopStates {}

// Change Lists in favorites
class ShopSuccessChangeListsState extends ShopStates {}

class ShopErrorChangeListsState extends ShopStates {}

class ProductInitialState extends ShopStates {}

class ProductLoadingDataState extends ShopStates {}

class ProductSuccessDataState extends ShopStates {
  // final ProductDetailsModel? model;

  // ProductSuccessDataState(this.model);
}

class ProductErrorDataState extends ShopStates {}

// Profile screen
class ShopLoadingUserDataState extends ShopStates {}

class ShopSuccessGetUserDataState extends ShopStates {}

class ShopErrorGetUserDataState extends ShopStates {}

class ShopCategoryPressedState extends ShopStates {}

class ShopLoadingGetProfileDataState extends ShopStates {}

class ShopSuccessGetProfileDataState extends ShopStates {
  final userModel;
  ShopSuccessGetProfileDataState(this.userModel);

  
}

class ShopErrorGetProfileDataState extends ShopStates {}
