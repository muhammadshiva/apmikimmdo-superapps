import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/models/new_models/products.dart';
import 'package:marketplace/data/models/new_models/recipent.dart';
import 'package:marketplace/data/models/user.dart';

class TokoSayaDataResponse {
  TokoSayaDataResponse({
    this.status,
    this.message,
    this.data,
  });

  String status;
  String message;
  List<TokoSayaProducts> data;

  factory TokoSayaDataResponse.fromJson(Map<String, dynamic> json) =>
      TokoSayaDataResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"].length == 0
                ? []
                : List<TokoSayaProducts>.from(
                    json["data"].map((x) => TokoSayaProducts.fromJson(x))),
      );

  Map<String, dynamic> toJson() =>
      {"status": status, "message": message, "data": data};
}

// class TokoSayaData {
//   TokoSayaData(
//       {this.reseller,
//       this.productReseller,
//       });

//   Reseller reseller;
//   List<TokoSayaProducts> productReseller;

//   factory TokoSayaData.fromJson(Map<String, dynamic> json) =>
//       TokoSayaData(
//         reseller: json["seller"] == null
//                 ? null
//                 : Reseller.fromJson(json["seller"]),
//         productReseller: json["products"].length == 0
//             ? []
//             : List<TokoSayaProducts>.from(
//                 json["products"].map((x) => TokoSayaProducts.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "seller": reseller,
//         "products": productReseller,
//       };
// }

class TokoSayaProducts {
  TokoSayaProducts(
      {this.id,
      this.productId,
      this.name,
      this.slug,
      this.categoryId,
      this.categoryName,
      this.oriPrice,
      this.finalPrice,
      this.disc,
      this.totalDisc,
      this.productPhoto,
      this.description,
      this.sold,
      this.stock});

  int id;
  int productId;
  String name;
  String slug;
  int categoryId;
  String categoryName;
  int oriPrice;
  int finalPrice;
  int disc;
  int totalDisc;
  int stock;
  int sold;
  String productPhoto;
  String description;

  factory TokoSayaProducts.fromJson(Map<String, dynamic> json) =>
      TokoSayaProducts(
        id: json["id"],
        productId: json["product_id"],
        name: json["name"],
        slug: json["slug"],
        categoryId: json["category_id"],
        categoryName: json["category_name"],
        oriPrice: json["price"].runtimeType == double ? json["price"].toInt() : json["price"] ?? 0,
        finalPrice: json["final_price"].runtimeType == double ? json["final_price"].toInt() : json["final_price"] ?? 0,
        disc: json["disc"],
        totalDisc: json["total_disc"].runtimeType == double ? json["total_disc"].toInt() : json["total_disc"] ?? 0,
        productPhoto: json["product_photo"],
        description: json["description"],
        stock: json["stock"],
        sold: json["sold"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id":productId,
        "name": name,
        "slug": slug,
        "category_id": categoryId,
        "category_name": categoryName,
        "price": oriPrice,
        "final_price":finalPrice,
        "disc":disc,
        "total_disc":totalDisc,
        "product_photo": productPhoto,
        "description": description,
        "stock": stock,
        "sold": sold
      };
}

class TokoSayaCustomersResponse {
  TokoSayaCustomersResponse({
    this.message,
    this.data,
  });

  String message;
  List<TokoSayaCustomer> data;

  factory TokoSayaCustomersResponse.fromJson(Map<String, dynamic> json) =>
      TokoSayaCustomersResponse(
        message: json["message"],
        data: json["data"] == null
            ? []
            : json["data"].length == 0
                ? []
                : List<TokoSayaCustomer>.from(
                    json["data"].map((x) => TokoSayaCustomer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {"message": message, "data": data};
}

class TokoSayaCustomer {
  int id;
  String name;
  String phone;
  String address;
  String whatsappLink;

  TokoSayaCustomer({
    this.id,
    this.name,
    this.phone,
    this.address,
    this.whatsappLink,
  });

  factory TokoSayaCustomer.fromJson(Map<String, dynamic> json) {
    return TokoSayaCustomer(
      id: json['id'],
      name: json['name'],
      phone: json['phonenumber'],
      address: json['address'],
      whatsappLink: json['whatsapp_link'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'whatsapp_link': whatsappLink,
    };
  }
}
