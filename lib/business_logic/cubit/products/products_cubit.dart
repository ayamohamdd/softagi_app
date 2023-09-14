import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/business_logic/cubit/products/products_state.dart';
import 'package:store_app/data/remote/dio_helper.dart';
import 'package:store_app/presentation/models/product_details_model.dart';
import 'package:store_app/shared/constants/strings.dart';

class ProductCubit extends Cubit<ProductStates> {
  ProductCubit() : super(ProductInitialState());

  static ProductCubit get(context) => BlocProvider.of(context);

  ProductDetailsModel? productDetailsModel;

  void getProductDetailsData() {
    emit(ProductLoadingDataState());
    DioHelper.getData(url: baseUrl + PRODUCTS, token: token,).then((value) {
      productDetailsModel = ProductDetailsModel.fromJson(value.data);
      emit(ProductSuccessDataState());
    }).catchError((error) {
      print('error is: ');
      print(error.toString());
      emit(ProductErrorDataState());
    });
  }

}
