import 'package:meta/meta.dart';

class FetchShippingOptionsResponse {
  FetchShippingOptionsResponse({
    @required this.status,
    @required this.data,
  });

  final String status;
  final List<ShippingOptionItem> data;

  factory FetchShippingOptionsResponse.fromJson(Map<String, dynamic> json) =>
      FetchShippingOptionsResponse(
        status: json["status"],
        data: List<ShippingOptionItem>.from(
            json["data"].map((x) => ShippingOptionItem.fromJson(x))),
      );
}

class ShippingOptionItem {
  ShippingOptionItem({
    @required this.name,
    @required this.etd,
    @required this.price,
  });

  final String name;
  final String etd;
  final int price;

  factory ShippingOptionItem.fromJson(Map<String, dynamic> json) =>
      ShippingOptionItem(
        name: json["name"],
        etd: json["etd"],
        price: json["price"],
      );
}
