import 'dart:convert';

import 'package:meta/meta.dart';

import 'package:marketplace/data/models/models.dart';

class UserResponse {
  UserResponse({
    // @required this.status,
    @required this.message,
    @required this.data,
  });

  // final String status;
  final String message;
  final User data;

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        // status: json["status"],
        message: json["message"],
        data: json["data"] != null ? User.fromJson(json["data"]) : null ,
      );
}

class User {
  User(
      {@required this.id,
      @required this.name,
      @required this.roleId,
      @required this.phonenumber,
      @required this.address,
      @required this.bussinessAddress,
      @required this.avatar,
      this.walletBalance,
      this.reseller,
      this.supplier});

  int id;
  String name;
  String roleId;
  String phonenumber;
  dynamic address;
  dynamic bussinessAddress;
  dynamic avatar;
  Reseller reseller;
  Supplier supplier;
  String walletBalance;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] ?? 0,
        name: json["name"],
        roleId: json["role_id"],
        phonenumber: json["phonenumber"],
        address: json["address"],
        bussinessAddress: json["bussiness_address"],
        avatar: json["avatar"],
        walletBalance: json["wallet_balance"],
        reseller: json.containsKey('reseller') == null
            ? null : json["reseller"] == null ? null
            : Reseller.fromJson(json["reseller"]),
        supplier: json.containsKey('supplier') == null
            ? null : json["supplier"] == null ? null
            : Supplier.fromJson(json["supplier"]),
      );
}

class CheckUserResponse {
  CheckUserResponse({
    @required this.status,
    @required this.message,
    @required this.data,
  });

  final String status;
  final String message;
  final CheckUserData data;

  factory CheckUserResponse.fromJson(Map<String, dynamic> json) =>
      CheckUserResponse(
        status: json["status"],
        message: json["message"],
        data:
            json["data"] == null ? null : CheckUserData.fromJson(json["data"]),
      );
}

class CheckUserData {
  CheckUserData({
    @required this.isActive,
    @required this.user,
    @required this.recipent,
  });

  final bool isActive;
  final User user;
  final List<Recipent> recipent;

  factory CheckUserData.fromJson(Map<String, dynamic> json) => CheckUserData(
        isActive: json["is_active"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        recipent: json["recipent"].length == 0
            ? []
            : List<Recipent>.from(
                json["recipent"].map((x) => Recipent.fromJson(x))),
      );
}

class Role {
  Role({
    this.id,
    this.name,
    this.code,
    this.level,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String name;
  String code;
  int level;
  dynamic createdAt;
  dynamic updatedAt;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        level: json["level"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "level": level,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class CustomerRegisterRes {
  String status;
  WpNewCustomer data;

  CustomerRegisterRes({
    this.status,
    this.data,
  });

  factory CustomerRegisterRes.fromMap(Map<String, dynamic> map) {
    return CustomerRegisterRes(
      status: map['status'],
      data: WpNewCustomer.fromMap(map['data']),
    );
  }
}

class WpNewCustomer {
  int userId;
  int provinceId;
  String province;
  int cityId;
  String city;
  int subdistrictId;
  String subdistrict;
  String name;
  String address;
  String phone;
  String updatedAt;
  String createdAt;
  String walletBalance;
  int id;

  WpNewCustomer({
    this.userId,
    this.provinceId,
    this.province,
    this.cityId,
    this.city,
    this.subdistrictId,
    this.subdistrict,
    this.name,
    this.address,
    this.phone,
    this.updatedAt,
    this.createdAt,
    this.walletBalance,
    this.id,
  });

  factory WpNewCustomer.fromMap(Map<String, dynamic> map) {
    return WpNewCustomer(
      userId: map['userId'],
      provinceId: map['provinceId'],
      province: map['province'],
      cityId: map['cityId'],
      city: map['city'] ?? '-',
      subdistrictId: map['subdistrictId'],
      subdistrict: map['subdistrict'],
      name: map['name'],
      address: map['address'],
      phone: map['phone'],
      updatedAt: map['updatedAt'],
      createdAt: map['createdAt'],
      walletBalance: map['wallet_balance'],
      id: map['id'],
    );
  }
}

class Registration {
  Registration({
    @required this.id,
    @required this.userId,
    @required this.name,
    @required this.nameSeller,
    @required this.roleId,
    @required this.address,
    @required this.kelurahan,
    @required this.rt,
    @required this.rw,
    @required this.provinceId,
    @required this.cityId,
    @required this.subdistrictId,
    @required this.ktpPhoto,
    @required this.isVerified,
  });

  final int id;
  final int userId;
  final String name;
  final String nameSeller;
  final int roleId;
  final String address;
  final String kelurahan;
  final String rt;
  final String rw;
  final int provinceId;
  final int cityId;
  final int subdistrictId;
  final String ktpPhoto;
  final int isVerified;

  factory Registration.fromJson(Map<String, dynamic> json) => Registration(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        nameSeller: json["name_seller"],
        roleId: json["role_id"],
        address: json["address"],
        kelurahan: json["kelurahan"],
        rt: json["rt"] ?? '-',
        rw: json["rw"] ?? '-',
        provinceId: json["province_id"],
        cityId: json["city_id"],
        subdistrictId: json["subdistrict_id"],
        ktpPhoto: json["ktp_photo"],
        isVerified: json["is_verified"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "name_seller": nameSeller,
        "role_id": roleId,
        "address": address,
        "kelurahan": kelurahan,
        "rt": rt,
        "rw": rw,
        "province_id": provinceId,
        "city_id": cityId,
        "subdistrict_id": subdistrictId,
        "ktp_photo": ktpPhoto,
        "is_verified": isVerified,
      };
}
