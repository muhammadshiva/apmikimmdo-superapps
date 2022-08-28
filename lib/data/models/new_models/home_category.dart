import 'package:flutter/foundation.dart';

class HomeCategoryResponse {
  HomeCategoryResponse({
    @required this.status,
    @required this.data,
  });

  final String status;
  final List<HomeCategory> data;

  factory HomeCategoryResponse.fromJson(Map<String, dynamic> json) =>
      HomeCategoryResponse(
        status: json["status"],
        data: json["data"].length == 0
            ? []
            : List<HomeCategory>.from(
                json["data"].map((x) => HomeCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class HomeCategory {
  HomeCategory({
    this.index,
    @required this.id,
    @required this.order,
    @required this.name,
    @required this.icon,
  });

  final int index;
  final int id;
  final int order;
  final String name;
  final String icon;

  factory HomeCategory.fromJson(Map<String, dynamic> json) => HomeCategory(
        id: json["id"],
        order: json["order"],
        name: json["name"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order": order,
        "name": name,
        "icon": icon,
      };
}
