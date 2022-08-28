class ListWarungDataResponse {
  ListWarungDataResponse({
    // this.status,
    // this.message,
    this.data,
  });

  // String status;
  // String message;
  List<Reseller> data;

  factory ListWarungDataResponse.fromJson(Map<String, dynamic> json) =>
      ListWarungDataResponse(
        // status: json["status"],
        // message: json["message"],
        data: json["data"] == null
            ? []
            : json["data"].length == 0
                ? []
                : List<Reseller>.from(
                    json["data"].map((x) => Reseller.fromJson(x))),
      );

  // Map<String, dynamic> toJson() =>
  //     {"status": status, "message": message, "data": data};
}

class Reseller {
  int id;
  String address;
  String phone;
  String name;
  String logo;
  String slug;
  int provinceId;
  String province;
  int cityId;
  String city;
  int subdistrictId;
  String subdistrict;
  int isActive;
  double rating;
  int sold;
  int customer;
  int totalProduct;
  String joinDate;

  Reseller(
      {this.id,
      this.provinceId,
      this.province,
      this.cityId,
      this.city,
      this.subdistrictId,
      this.subdistrict,
      this.name,
      this.address,
      this.phone,
      this.logo,
      this.slug,
      this.rating,
      this.sold,
      this.customer,
      this.totalProduct,
      this.joinDate
      });

  factory Reseller.fromJson(Map<String, dynamic> json) => Reseller(
        id: json['id'],
        name: json['name'],
        address: json['address'],
        phone: json['phonenumber'],
        logo: json['logo'] ?? "",
        slug: json['slug'],
        provinceId: json['province_id'],
        province: json['province'] != null ? json['province'] : '-',
        cityId: json['city_id'],
        city: json['city'] != null ? json['city'] : '-',
        subdistrictId: json['subdistrict_id'],
        subdistrict: json['subdistrict'] != null ? json['subdistrict'] : '-', 
        rating: json['rating'] ?? 0,
        sold: json['sold'] ?? 0,
        customer: json['customer'] ?? 0,
        totalProduct: json['products'] ?? 0,
        joinDate: json['join_date'] ?? '-'
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "phone_number": phone,
        "logo": logo,
        "province_id": provinceId,
        "province": province,
        "city_id": cityId,
        "city": city,
        "subdistrict_id": subdistrictId,
        "subdistrict": subdistrict,
        "slug": slug,
        "rating": rating,
        "sold": sold,
        "customer": customer,
        "join_date": joinDate,
        "products": totalProduct
      };
}
