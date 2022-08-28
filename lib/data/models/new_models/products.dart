import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/models/new_models/region.dart';

enum FetchProductsType { promo, bestSell, flashSale, bumdes, randomRecom }

class ProductsGeneralResponse {
  ProductsGeneralResponse({
    @required this.status,
    @required this.data,
  });

  final String status;
  final List<Products> data;

  factory ProductsGeneralResponse.fromJson(Map<String, dynamic> json) =>
      ProductsGeneralResponse(
        status: json["status"],
        data: json["data"].length == 0
            ? []
            : List<Products>.from(
                json["data"].map((x) => Products.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ProductsCoverageValidationResponse {
  ProductsCoverageValidationResponse({
    @required this.status,
  });

  final bool status;

  factory ProductsCoverageValidationResponse.fromJson(
          Map<String, dynamic> json) =>
      ProductsCoverageValidationResponse(
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
      };
}

class ProductDetailResponse {
  ProductDetailResponse({
    @required this.status,
    @required this.message,
    @required this.data,
  });

  final String status;
  final String message;
  final Products data;

  factory ProductDetailResponse.fromJson(Map<String, dynamic> json) =>
      ProductDetailResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Products.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

// ignore: must_be_immutable
class Products extends Equatable {
  Products(
      {this.id,
      this.categoryId,
      this.categoryName,
      this.submissionId,
      this.supplierId,
      this.name,
      this.slug,
      this.description,
      this.price,
      this.sellingPrice,
      this.disc,
      this.discPrice,
      this.sold,
      this.stock,
      this.weight,
      this.unit,
      this.status,
      this.komisi,
      this.productPhoto,
      this.productPhotoShop,
      this.productCoverage,
      this.supplier,
      this.reseller,
      this.bumdes,
      this.coverPhoto,
      this.relatedProduct,
      this.productVariant,
      this.productGroceries});

  int id;
  int categoryId;
  String categoryName;
  int submissionId;
  int supplierId;
  String name;
  String slug;
  String description;
  int price;
  int sellingPrice;
  int disc;
  int discPrice;
  int komisi;
  int sold;
  int stock;
  int weight;
  String unit;
  String status;
  String productPhotoShop; //toko saya
  String bumdes;
  String coverPhoto;
  Supplier supplier;
  Reseller reseller;
  List<ProductGroceries> productGroceries;
  List<ProductPhoto> productPhoto;
  List<ProductCoverage> productCoverage;
  List<RelatedProduct> relatedProduct;
  List<ProductVariant> productVariant;

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        id: json["id"],
        categoryId: json["category_id"],
        categoryName: json["category"],
        name: json["product_name"],
        slug: json["product_slug"],
        description: json["product_description"],
        price: json["product_price"],
        //Tidak dibuat untuk ditampilkan
        sellingPrice: json["product_selling_price"].runtimeType == double
            ? json["product_selling_price"].toInt()
            : json["product_selling_price"] ?? 0,
        disc: json["product_disc"].runtimeType == double
            ? json["product_disc"].toInt()
            : json["product_disc"] ?? 0,
        discPrice: json["product_disc_price"].runtimeType == double
            ? json["product_disc_price"].toInt()
            : json["product_disc_price"] ?? 0,
        sold: json["product_sold"] ?? 0,
        stock: json["product_stock"] ?? 0,
        weight: json["product_weight"].runtimeType == double
            ? json["product_weight"].toInt()
            : json["product_weight"] ?? 0,
        unit: json["product_unit"],
        komisi: json["commission"].runtimeType == double
            ? json["commission"].toInt()
            : json["commission"] ?? 0,
        productPhotoShop: json["product_photo"],
        supplier: json["supplier"] != null
            ? Supplier.fromJson(json["supplier"])
            : null,
        reseller: json["reseller"] != null
            ? Reseller.fromJson(json["reseller"])
            : null,
        bumdes: json["unit"],
        coverPhoto: json["cover"],
        productPhoto: json["product_assets"] == null
            ? []
            : json["product_assets"].length == 0
                ? []
                : List<ProductPhoto>.from(json["product_assets"]
                    .map((x) => ProductPhoto.fromJson(x))),
        productCoverage: json["product_coverages"] == null
            ? []
            : json["product_coverages"].length == 0
                ? []
                : List<ProductCoverage>.from(json["product_coverages"]
                    .map((x) => ProductCoverage.fromJson(x))),
        relatedProduct: json["related_products"] == null
            ? []
            : json["related_products"].length == 0
                ? []
                : List<RelatedProduct>.from(json["related_products"]
                    .map((x) => RelatedProduct.fromJson(x))),
        productVariant: json["product_variants"] == null
            ? []
            : json["product_variants"].length == 0
                ? []
                : List<ProductVariant>.from(json["product_variants"]
                    .map((x) => ProductVariant.fromJson(x))),
        productGroceries: json["product_groceries"] == null
            ? []
            : json["product_groceries"].length == 0
                ? []
                : List<ProductGroceries>.from(json["product_groceries"]
                    .map((x) => ProductGroceries.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "category": categoryName,
        "product_name": name,
        "product_description": description,
        "product_price": price,
        "product_selling_price": sellingPrice,
        "product_disc": disc,
        "product_disc_price": discPrice,
        "product_sold": sold,
        "product_stock": stock,
        "product_weight": weight,
        "product_unit": unit,
        "commission": komisi,
        "product_assets": productPhoto,
        "product_photo": productPhotoShop,
        "product_coverages": productCoverage,
        "supplier": supplier,
        "reseller": reseller,
        "bumdes": bumdes,
        "cover": coverPhoto,
        "related_products": relatedProduct,
        "product_variants": productVariant,
        "product_groceries": productGroceries
      };

  /// Menghitung harga akhir satuan setelah promo
  // int get netPrice => price;

  ///Contoh output: Surabaya, Sidoarjo dan Malang
  // String get coverageCitiesString {
  //   if (coverage.isEmpty) return "-";
  //   var cities = coverage.map((e) => e.name).toList();
  //   if (cities.length == 1) return cities[0];
  //   var temp = cities.getRange(0, cities.length - 1);
  //   return '${temp.join(", ")} dan ${cities.last}';
  // }

  @override
  List<Object> get props => [id, stock];
}

class ProductPhoto {
  ProductPhoto(
      {this.id, this.productId, this.submissionId, this.image, this.link});

  int id;
  int productId;
  int submissionId;
  String image;
  String link;

  factory ProductPhoto.fromJson(Map<String, dynamic> json) => ProductPhoto(
        id: json["id"],
        productId: json["product_id"],
        submissionId: json["submission_id"],
        image: json["image"] ?? "",
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "submission_id": submissionId,
        "image": image,
        "link": link,
      };
}

class ProductGroceries {
  ProductGroceries({
    @required this.id,
    @required this.productId,
    @required this.submissionId,
    @required this.minimumOrder,
    @required this.price,
  });

  final int id;
  final int productId;
  int submissionId;
  int minimumOrder;
  int price;

  factory ProductGroceries.fromJson(Map<String, dynamic> json) =>
      ProductGroceries(
        id: json["id"],
        productId: json["product_id"],
        submissionId: json["submission_id"],
        minimumOrder: json["minimum_order"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "submission_id": submissionId,
        "minimum_order": minimumOrder,
        "price": price,
      };
}

class WholesaleRequest {
  WholesaleRequest({
    @required this.price,
    @required this.from,
    @required this.to,
  });

  int price;
  int from;
  int to;

  Map<String, dynamic> toJson() => {
        "grocir_price": price,
        "from": from,
        "to": to,
      };
}

class ProductCoverage {
  ProductCoverage({
    @required this.subdistrict,
  });

  final List<Subdistrict> subdistrict;

  factory ProductCoverage.fromJson(Map<String, dynamic> json) =>
      ProductCoverage(
        subdistrict: json["subdistricts"] == null
            ? []
            : json["subdistricts"].length == 0
                ? []
                : List<Subdistrict>.from(
                    json["subdistricts"].map((x) => Subdistrict.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "subdistricts": subdistrict,
      };
}

class RelatedProduct {
  RelatedProduct({
    this.id,
    this.name,
    this.slug,
    this.disc,
    this.discPrice,
    this.sellingPrice,
    this.sold,
    this.cover,
    this.address,
  });

  int id;
  String name;
  String slug;
  int disc;
  int discPrice;
  int sellingPrice;
  int sold;
  String cover;
  String address;

  factory RelatedProduct.fromJson(Map<String, dynamic> json) => RelatedProduct(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        disc: json["disc"].runtimeType == double
            ? json["disc"].toInt()
            : json["disc"] ?? 0,
        discPrice: json["disc_price"].runtimeType == double
            ? json["disc_price"].toInt()
            : json["disc_price"] ?? 0,
        sellingPrice: json["selling_price"].runtimeType == double
            ? json["selling_price"].toInt()
            : json["selling_price"] ?? 0,
        sold: json["sold"],
        cover: json["cover"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "disc": disc,
        "disc_price": discPrice,
        "selling_price": sellingPrice,
        "sold": sold,
        "cover": cover,
        "address": address,
      };
}

class ProductVariant {
  ProductVariant({
    this.id,
    this.productId,
    this.submissionId,
    this.variantName,
    this.varianSlug,
    this.variantDescription,
    this.variantPrice,
    this.variantSellPrice,
    this.variantDisc,
    this.variantDiscPrice,
    this.variantFinalPrice,
    this.variantStock,
    this.variantWeight,
    this.variantUnit,
    this.variantStatus,
    this.variantType,
  });

  final int id;
  final dynamic productId;
  final int submissionId;
  final String variantName;
  final String varianSlug;
  final dynamic variantDescription;
  final int variantPrice;
  final int variantSellPrice;
  final int variantDisc;
  final int variantDiscPrice;
  final int variantFinalPrice;
  final int variantStock;
  final int variantWeight;
  final String variantUnit;
  final String variantStatus;
  final String variantType;

  factory ProductVariant.fromJson(Map<String, dynamic> json) => ProductVariant(
        id: json["id"],
        productId: json["product_id"],
        submissionId: json["submission_id"],
        variantName: json["variant_name"],
        varianSlug: json["variant_slug"],
        variantDescription: json["variant_description"],
        variantPrice: json["variant_price"],
        variantSellPrice: json["variant_selling_price"],
        variantDisc: json["variant_disc"],
        variantDiscPrice: json["variant_disc_price"],
        variantFinalPrice: json["variant_final_price"],
        variantStock: json["variant_stock"],
        variantWeight: json["variant_weight"],
        variantUnit: json["variant_unit"],
        variantStatus: json["variant_status"],
        variantType: json["variant_type"] == null ? null : json["variant_type"],
      );
}
