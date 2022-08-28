import 'package:meta/meta.dart';
import 'dart:convert';

SearchKecamatan kecamatanFromJson(String str) => SearchKecamatan.fromJson(json.decode(str));

class SearchKecamatan {
  SearchKecamatan({
    @required this.data,
    @required this.message,
    @required this.status,
  });

  List<SearchKecamatanData> data;
  String message;
  String status;

  factory SearchKecamatan.fromJson(Map<String, dynamic> json) => SearchKecamatan(
    data: List<SearchKecamatanData>.from(json["data"].map((x) => SearchKecamatanData.fromJson(x))),
    message: json["message"],
    status: json["status"],
  );

  @override
  String toString() {
    return 'SearchKecamatan{data: $data}';
  }
}

class SearchKecamatanData {
  SearchKecamatanData({
    @required this.id,
    @required this.countryId,
    @required this.subdistrictId,
    @required this.provinceId,
    @required this.province,
    @required this.cityId,
    @required this.city,
    @required this.type,
    @required this.subdistrictName,
  });

  int id;
  int countryId;
  int subdistrictId;
  int provinceId;
  String province;
  int cityId;
  String city;
  String type;
  String subdistrictName;

  factory SearchKecamatanData.fromJson(Map<String, dynamic> json) => SearchKecamatanData(
    id: json["id"],
    countryId: json["country_id"],
    subdistrictId: json["subdistrict_id"],
    provinceId: json["province_id"],
    province: json["province"],
    cityId: json["city_id"],
    city: json["city"],
    type: json["type"],
    subdistrictName: json["subdistrict_name"],
  );

  @override
  String toString() {
    return 'SearchKecamatanData{id: $id, countryId: $countryId, subdistrictId: $subdistrictId, provinceId: $provinceId, province: $province, cityId: $cityId, city: $city, type: $type, subdistrictName: $subdistrictName}';
  }
}
