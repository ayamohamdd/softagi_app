class ChangeCartModel {
  bool? status;
  String? message;
  CartData? cartData;
  ChangeCartModel.fromJson(Map<String, dynamic>? json) {
    status = json!["status"];
    message = json["message"];
    cartData =
        json['data'] != null ? CartData.fromJson(json['data']) : null;
  }
}

class CartData {
  int id=0;
  int? quantity;
  ProductData? productData;

  CartData.fromJson(Map<String, dynamic>? json) {
    id = json!["id"];
    quantity = json["quantity"];
   productData=json["product"] != null ? ProductData.fromJson(json['product']) : null;

  }
}
class ProductData {
  int? id;
  dynamic price;
  dynamic oldPrice;
  dynamic discount;
  String? image;
  String? name;
  String? description;
  
  ProductData.fromJson(Map<String, dynamic>? json) {
    id = json!["id"];
    price = json["price"];
    oldPrice = json["old_price"];
    discount = json["discount"];
    image = json["image"];
    name = json["name"];
    description = json["description"];
    
  }
}
