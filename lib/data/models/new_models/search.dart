import 'package:flutter/material.dart';
import 'package:marketplace/data/models/new_models/products.dart';

class SearchResponse {
  SearchResponse({
    @required this.message,
    @required this.data,
  });

  final String message;
  final List<Products> data;

  factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
        message: json["message"],
        data: json["data"].length == 0 ? [] :
        List<Products>.from(json["data"].map((x) => Products.fromJson(x))),            
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data,
      };
}



class SearchDataOld {
  SearchDataOld({
    @required this.product,
  });

  final List<Products> product;
  factory SearchDataOld.fromJson(Map<String, dynamic> json) => SearchDataOld(
        product: json["product"].length == 0
            ? []
            : List<Products>.from(
                json["product"].map((x) => Products.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "product": List<dynamic>.from(product.map((x) => x.toJson())),
      };
}
