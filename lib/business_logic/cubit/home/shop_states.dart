import 'package:store_app/presentation/models/change_cart_model.dart';
import 'package:store_app/presentation/models/change_favorits_model.dart';
import 'package:store_app/presentation/models/change_password_model.dart';
import 'package:store_app/presentation/models/login_model.dart';
import 'package:store_app/presentation/screens/profile/change_password.dart';

abstract class ShopStates {}

class ShopInitialState extends ShopStates {}

class ShopLoadingState extends ShopStates {}
class ShopSuccessState extends ShopStates {}
class ShopErrorState extends ShopStates {}


class ShopChangeBottomNavState extends ShopStates {}

//class ShopChangeBottomNavIconColorState extends ShopStates{}

// Products
class ShopLoadingDataState extends ShopStates {}

class ShopSuccessDataState extends ShopStates {}

class ShopErrorDataState extends ShopStates {}

// Search Products
class ShopLoadingGetSearchDataState extends ShopStates {}

class ShopSuccessGetSearchDataState extends ShopStates {}

class ShopErrorGetSearchDataState extends ShopStates {}

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

class ProductSuccessDataState extends ShopStates {}

class ProductErrorDataState extends ShopStates {}

// Profile screen
class ShopLoadingGetProfileDataState extends ShopStates {}

class ShopSuccessGetProfileDataState extends ShopStates {
  final userModel;
  ShopSuccessGetProfileDataState(this.userModel);
}

class ShopErrorGetProfileDataState extends ShopStates {}

class ShopLoadingGetImageDataState extends ShopStates {}

class ShopLoadingProfileImageUploadState extends ShopStates {}

class ShopSuccessProfileImageUploadState extends ShopStates {}

class ShopErrorProfileImageUploadState extends ShopStates {}

// Update Profile
class ShopLoadingUpdateUserDataState extends ShopStates {}

class ShopSuccessUpdateUserDataState extends ShopStates {}

class ShopErrorUpdateUserDataState extends ShopStates {}

// Change Password
class ShopLoadingChangePasswordState extends ShopStates {}

class ShopSuccessChangePasswordState extends ShopStates {
  ChangePasswordModel changePasswordModel;
  ShopSuccessChangePasswordState(this.changePasswordModel);
}

class ShopErrorChangePasswordState extends ShopStates {}

// Category Pressed
class ShopCategoryPressedState extends ShopStates {}

// Cart Screen

class ShopLoadingGetCartDataState extends ShopStates {}

class ShopSuccessGetCartDataState extends ShopStates {}

class ShopErrorGetCartDataState extends ShopStates {}

class ShopEmptyCartDataState extends ShopStates {}

// change Cart
class ShopLoadingChangeCartDataState extends ShopStates {}

class ShopSuccessChangeCartDataState extends ShopStates {
  final ChangeCartModel? model;

  ShopSuccessChangeCartDataState(this.model);
}

class ShopErrorChangeCartDataState extends ShopStates {}

// Edit Cart
class ShopLoadingUpdateCartDataState extends ShopStates {}

class ShopSuccessUpdateCartDataState extends ShopStates {}

class ShopErrorUpdateCartDataState extends ShopStates {}

// Delete Cart
class ShopLoadingDeleteCartDataState extends ShopStates {}

class ShopSuccessDeleteCartDataState extends ShopStates {}

class ShopErrorDeleteCartDataState extends ShopStates {}

// Delete Cart
class ShopLoadingLogoutState extends ShopStates {}

class ShopSuccessLogoutState extends ShopStates {
  SignnoutModel? signnoutModel;
  ShopSuccessLogoutState(signnoutModel);
}

class ShopErrorLogoutState extends ShopStates {}
