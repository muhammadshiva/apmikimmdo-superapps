import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:marketplace/data/models/models.dart';


String cartRequestToJson(CheckoutRequest data) => json.encode(data.toJson());

class CheckoutRequest {
  CheckoutRequest({
    @required this.sellerId,
    @required this.serviceCode,
    @required this.shippingCost,
    @required this.recipentId,
    this.isPotency = 0,
  });

  int recipentId;
  String serviceCode;
  int shippingCost;
  int sellerId;
  int isPotency;

  Map<String, dynamic> toJson() => {
        "recipent_id": recipentId,
        "service_code": serviceCode,
        "shipping_cost": shippingCost,
        "seller_id": sellerId,
        "ispotency": isPotency,
      };
}

class CheckoutBookingRequest {
  CheckoutBookingRequest({
    @required this.serviceCode,
    @required this.shippingCost,
    @required this.recipentId,
  });

  int recipentId;
  String serviceCode;
  int shippingCost;

  Map<String, dynamic> toJson() => {
        "recipent_id": recipentId,
        "service_code": serviceCode,
        "shipping_cost": shippingCost,
      };
}

class CheckoutBuyNowRequest {
  CheckoutBuyNowRequest({
    @required this.sellerId,
    @required this.serviceCode,
    @required this.shippingCost,
    @required this.recipentId,
    @required this.productId,
    @required this.quantity,
  });

  int recipentId;
  String serviceCode;
  int shippingCost;
  int sellerId;
  int productId;
  int quantity;

  Map<String, dynamic> toJson() => {
        "recipent_id": recipentId,
        "service_code": serviceCode,
        "shipping_cost": shippingCost,
        "seller_id": sellerId,
        "product_id": productId,
        "quantity": quantity,
      };
}

// class CheckoutRequest {
//   CheckoutRequest({
//     @required this.cart,
//     @required this.serviceCode,
//     @required this.shippingCost,
//     @required this.recipentId,
//   });

//   int recipentId;
//   String serviceCode;
//   int shippingCost;
//   List<CartCheckout> cart;

//   Map<String, dynamic> toJson() => {
//         "recipent_id": recipentId,
//         "service_code": serviceCode,
//         "shipping_cost": shippingCost,
//         "cart": List<dynamic>.from(cart.map((x) => x.toJson())),
//       };
// }

class CartCheckout {
  CartCheckout({
    this.userId,
    this.productId,
    this.quantity,
  });

  final int userId;
  final int productId;
  final int quantity;

  factory CartCheckout.fromJson(Map<String, dynamic> json) => CartCheckout(
        userId: json["user_id"],
        productId: json["product_id"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "product_id": productId,
        "quantity": quantity,
      };
}

// v2
class CartResponse {
  CartResponse({
    @required this.status,
    @required this.data,
  });

  final String status;
  final List<Cart> data;

  factory CartResponse.fromJson(Map<String, dynamic> json) => CartResponse(
        status: json["status"],
        data: List<Cart>.from(json["data"].map((x) => Cart.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class CountCartResponse {
  CountCartResponse({
    @required this.status,
    @required this.data,
  });

  final String status;
  final int data;

  factory CountCartResponse.fromJson(Map<String, dynamic> json) =>
      CountCartResponse(
        status: json["status"],
        data: json["data"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data,
      };
}

class Cart {
  Cart({
    @required this.sellerId,
    @required this.nameSeller,
    @required this.product,
  });

  final int sellerId;
  final String nameSeller;
  final List<CartProduct> product;

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        sellerId: json["seller_id"],
        nameSeller: json["name_seller"],
        product: List<CartProduct>.from(
            json["product"].map((x) => CartProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "seller_id": sellerId,
        "name_seller": nameSeller,
        "product": List<dynamic>.from(product.map((x) => x.toJson())),
      };
}

class CartProduct {
  CartProduct({
    @required this.id,
    @required this.cartId,
    @required this.name,
    @required this.productPhoto,
    @required this.enduserPrice,
    this.productVariantName,
     this.variantSelected,
    @required this.initialPrice,
    @required this.stock,
    @required this.weight,
    this.unit,
    @required this.quantity,
    this.wholesale,
    
  });

  final int id;
  final int cartId;
  final String name;
  final String productPhoto;
  int enduserPrice;
  final int initialPrice;
  final int stock;
  final int weight;
  final String unit;
  final String productVariantName; 
  int quantity;
  final ProductVariant variantSelected;
  final List<ProductGroceries> wholesale;

  factory CartProduct.fromJson(Map<String, dynamic> json) => CartProduct(
        id: json["id"],
        cartId: json["cart_id"],
        name: json["name"],
        productPhoto: json["product_photo"],
        enduserPrice: json["enduser_price"],
        initialPrice: json["enduser_price"],
        stock: json["stock"],
        weight: json["weight"],
        quantity: json["quantity"],
        unit: json["unit"] ?? null,
        variantSelected:  json["product_variant_selected"] != null ?  ProductVariant.fromJson(json["product_variant_selected"]) : null ,
        wholesale: json["grocirs"] == null
            ? []
            : json["grocirs"].length == 0
                ? []
                : List<ProductGroceries>.from(
                    json["grocirs"].map((x) => ProductGroceries.fromJson(x))),
        // coverage: json["coverage"] == null
        //     ? []
        //     : json["coverage"].length == 0
        //         ? []
        //         : List<City>.from(
        //             json["coverage"].map((x) => City.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cart_id": cartId,
        "name": name,
        "product_photo": productPhoto,
        "enduser_price": enduserPrice,
        "stock": stock,
        "weight": weight,
        "quantity": quantity,
        "unit": unit ?? null,
        "product_variant_selected": variantSelected,
        "grocirs": List<dynamic>.from(wholesale.map((x) => x.toJson())),
        // "coverage": List<dynamic>.from(coverage.map((x) => x.toJson())),
      };

  @override
  String toString() {
    return 'CartProduct{id: $id, cartId: $cartId, name: $name, productPhoto: $productPhoto, enduserPrice: $enduserPrice, initialPrice: $initialPrice, stock: $stock, weight: $weight, unit: $unit, quantity: $quantity, variantselected: $variantSelected, wholesale: ${wholesale.length},}';
  }
}

class AddCartResponse {
  AddCartResponse({
    this.status,
    this.data,
  });

  String status;
  CartProductUpdated data;

  factory AddCartResponse.fromJson(Map<String, dynamic> json) =>
      AddCartResponse(
        status: json["status"],
        data: CartProductUpdated.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class UpdateCartQuantityResponse {
  UpdateCartQuantityResponse({
    @required this.status,
    @required this.data,
  });

  final String status;
  final List<CartProductUpdated> data;

  factory UpdateCartQuantityResponse.fromJson(Map<String, dynamic> json) =>
      UpdateCartQuantityResponse(
        status: json["status"],
        data: json["data"].length <= 0
            ? []
            : List<CartProductUpdated>.from(
                json["data"].map((x) => CartProductUpdated.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class CartProductUpdated {
  CartProductUpdated({
    @required this.id,
    @required this.productId,
    @required this.buyerId,
    @required this.sellerId,
    @required this.quantity,
  });

  final int id;
  final int productId;
  final int buyerId;
  final int sellerId;
  final int quantity;

  factory CartProductUpdated.fromJson(Map<String, dynamic> json) =>
      CartProductUpdated(
        id: json["id"],
        productId: json["product_id"],
        buyerId: json["buyer_id"],
        sellerId: json["seller_id"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "buyer_id": buyerId,
        "seller_id": sellerId,
        "quantity": quantity,
      };
}

class WpCartItem extends Equatable {
  const WpCartItem({
    @required this.product,
    @required this.qty,
  });

  final Products product;
  final int qty;

  bool get minQtyReached => qty == 1;

  bool get maxQtyReached => qty == product.stock;

  bool get insufficientStock => product.stock < qty;

  /// Menghitung harga total setelah diskon promo dan grosir
  // int get totalPrice {
  //   var singleNetPrice = product.netPrice;
  //   if (product.isWholesale == 1 && product.wholesale.isNotEmpty) {
  //     try {
  //       singleNetPrice = product.wholesale
  //           .firstWhere((element) => qty >= element.from && qty <= element.to)
  //           .wholesalePrice;
  //     } catch (e) {}
  //   }
  //   return singleNetPrice * qty;
  // }

  WpCartItem copyWith({
    Products product,
    int qty,
  }) {
    return WpCartItem(
      product: product ?? this.product,
      qty: qty ?? this.qty,
    );
  }

  @override
  String toString() => 'WpCartItem(productId: ${product.id}, qty: $qty)';

  @override
  List<Object> get props => [product, qty];
}
