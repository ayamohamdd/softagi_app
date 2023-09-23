class CartModel {
  bool? status;
  String? message;
  CartData? cartData;
  CartModel.fromJson(Map<String, dynamic>? json) {
    status = json!["status"];
    message = json["message"];
    cartData =
        json['data'] != null ? new CartData.fromJson(json['data']) : null;
  }
}

class CartData {
  dynamic subTotal;
  dynamic total;
  List<CartItemData> cartItemData = [];
  CartData.fromJson(Map<String, dynamic>? json) {
    subTotal = json!["sub_total"];
    total = json["total"];
    json['cart_items'].forEach((element) {
      cartItemData.add(CartItemData.fromJson(element));
    });
  }
}

class CartItemData {
  int? id;
  int? quantity;
  ProductData? productData;
  CartItemData.fromJson(Map<String, dynamic>? json) {
    id = json!["id"];
    quantity = json["quantity"];
    productData=json["product"] != null ? new ProductData.fromJson(json['product']) : null;
  }
}

class ProductData {
  int? id;
  dynamic price;
  dynamic oldPrice;
  dynamic discount;
  String image = '';
  String name = '';
  String description = '';
  List<String> images = [];
  bool? inFavorites;
  bool? inCart;
  ProductData.fromJson(Map<String, dynamic>? json) {
    id = json!["id"];
    price = json["price"];
    oldPrice = json["old_price"];
    discount = json["discount"];
    image = json["image"];
    name = json["name"];
    description = json["description"];
    inFavorites = json["in_favorites"];
    inCart = json["in_cart"];
    images = json['images'].cast<String>();
  }
}
