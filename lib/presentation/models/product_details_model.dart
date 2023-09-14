import 'package:store_app/presentation/models/product_model.dart';

class ProductDetailsModel {
  bool? status;
  ProductDetailsDataModel? data;

  ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = ProductDetailsDataModel.fromJson(json['data']);
  }
}

class ProductDetailsDataModel {
  int? currentPage;
  List<ProductDetailsData> data = [];

  ProductDetailsDataModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    json['data'].forEach((element) {
      data.add(ProductDetailsData.fromJson(element));
    });
  }
}

class ProductDetailsData {
  String description = '';
  List<dynamic> images = [];
  dynamic id;
  dynamic price;
  dynamic oldPrice;
  dynamic discount;
  String image = '';
  String name='';
  bool? inFavorites;
  bool? inCart;
  ProductDetailsData.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    images = json['images'];
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];
  }
}
