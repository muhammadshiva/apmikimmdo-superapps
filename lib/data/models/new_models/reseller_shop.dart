import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/models/new_models/products.dart';
import 'package:marketplace/data/models/new_models/recipent.dart';
import 'package:marketplace/data/models/user.dart';

//MODEL INI DIGUNAKAN UNTUK RESELLER SHOP DI WEB

class ResellerShopProductDataResponse{
    ResellerShopProductDataResponse({
        this.status,
        this.message,
        this.data,
    });
  
    String status;
    String message;
    List<Products> data;

    factory ResellerShopProductDataResponse.fromJson(Map<String, dynamic> json) => ResellerShopProductDataResponse(
        status: json["status"],
        message: json["message"],
        data: 
        json["data"] == null
            ? []
            : json["data"].length == 0
                ? []
                : List<Products>.from(json["data"].map((x) => Products.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data
    };
    
}

class ResellerShopDataResponse{
    ResellerShopDataResponse({
        this.status,
        this.message,
        this.data,
    });
  
    String status;
    String message;
    Reseller data;

    factory ResellerShopDataResponse.fromJson(Map<String, dynamic> json) => ResellerShopDataResponse(
        status: json["status"],
        message: json["message"],
        data: 
        json["data"] != null
            ? Reseller.fromJson(json["data"]) : null
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data
    };
    
}


