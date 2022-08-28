import 'package:flutter/material.dart';

class HomeSliderResponse {
  HomeSliderResponse({
    @required this.status,
    @required this.data,
  });

  final String status;
  final List<HomeSlider> data;

  factory HomeSliderResponse.fromJson(Map<String, dynamic> json) =>
      HomeSliderResponse(
        status: json["status"],
        data: json["data"].length == 0
            ? []
            : List<HomeSlider>.from(
                json["data"].map((x) => HomeSlider.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class HomeSlider {
  HomeSlider(
      {@required this.id,
      @required this.name,
      @required this.mobilePhoto,
      @required this.webPhoto,
      this.link});

  final int id;
  final String name;
  final String mobilePhoto;
  final String webPhoto;
  final String link;

  factory HomeSlider.fromJson(Map<String, dynamic> json) => HomeSlider(
      id: json["id"],
      name: json["name"],
      mobilePhoto: json["mobile_photo"],
      webPhoto: json["desktop_photo"],
      link: json["link"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "mobile_photo": mobilePhoto,
        "desktop_photo": webPhoto,
        "link": link
      };
}
