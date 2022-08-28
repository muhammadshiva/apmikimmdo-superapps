import 'package:flutter/foundation.dart';

class GeneralRegionResponse {
  GeneralRegionResponse({
    @required this.status,
    @required this.data,
  });

  final String status;
  final List<Region> data;

  factory GeneralRegionResponse.fromJson(Map<String, dynamic> json) =>
      GeneralRegionResponse(
        status: json["status"],
        data: json["data"].length == 0
            ? []
            : List<Region>.from(json["data"].map((x) => Region.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {"status": status, "data": data};
}

class Region {
  Region({
    @required this.id,
    @required this.name,
  });

  final int id;
  final String name;

  factory Region.fromJson(Map<String, dynamic> json) => Region(
        id: json["id"],
        name: json["name"],
      );
}

class Subdistrict {
  Subdistrict({
    @required this.id,
    @required this.name,
  });

  final int id;
  final String name;

  factory Subdistrict.fromJson(Map<String, dynamic> json) => Subdistrict(
        id: json["id"],
        name: json["name"],
      );
      
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
  
}