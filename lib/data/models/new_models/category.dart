import 'package:flutter/cupertino.dart';

class CategoryResponse {
  CategoryResponse({
    @required this.status,
    @required this.data,
  });

  final String status;
  final List<Category> data;

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      CategoryResponse(
        status: json["status"],
        data: json["data"].length == 0
            ? []
            : List<Category>.from(
                json["data"].map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Category {
  Category({
    this.index,
    @required this.id,
    @required this.name,
    @required this.slug,
    @required this.icon,
  });

  final int index; // for web
  final int id;
  final String name;
  final String slug;
  final String icon;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "icon": icon,
      };
}

class SubcategoryResponse {
  SubcategoryResponse({
    @required this.status,
    @required this.data,
  });

  final String status;
  final List<Subcategory> data;

  factory SubcategoryResponse.fromJson(Map<String, dynamic> json) =>
      SubcategoryResponse(
        status: json["status"],
        data: json["data"].length == 0
            ? []
            : List<Subcategory>.from(
                json["data"].map((x) => Subcategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Subcategory {
  Subcategory({
    this.id,
    this.categoryId,
    this.name,
    this.code,
    this.icon,
    this.category,
  });

  final int id;
  final int categoryId;
  final String name;
  final String code;
  final String icon;
  final Category category;

  factory Subcategory.fromJson(Map<String, dynamic> json) => Subcategory(
        id: json["id"],
        categoryId: json["category_id"],
        name: json["name"],
        code: json["slug"],
        icon: json["icon"],
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "name": name,
        "slug": code,
        "icon": icon,
        "category": category
      };
}
