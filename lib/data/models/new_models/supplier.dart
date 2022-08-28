import 'package:marketplace/data/models/models.dart';

class Supplier {
  int id;
  int userId;
  String name;
  String slug;
  String rename;
  String phone;
  String logo;
  String address;
  int provinceId;
  String province;
  int cityId;
  String city;
  int subdistrictId;
  String subdistrict;
  int isActive;
  String joinDate;
  int productCount;
  int memberCount;

  Supplier(
      {this.id,
        this.userId,
        this.name,
        this.slug,
        this.rename,
        this.address,
        this.phone,
        this.logo,
        this.provinceId,
        this.province,
        this.cityId,
        this.city,
        this.subdistrictId,
        this.subdistrict,
        this.joinDate,
        this.productCount,
        this.memberCount});

  factory Supplier.fromJson(Map<String, dynamic> json) => Supplier(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      slug: json['slug'],
      rename: json['rename'],
      address: json['address'],
      phone: json['phonenumber'],
      provinceId: json['province_id'],
      province: json['province'] != null ? json['province'] : '-',
      cityId: json['city_id'],
      city: json['city'] != null ? json['city'] : '-',
      subdistrictId: json['subdistrict_id'],
      subdistrict: json['subdistrict'] != null ? json['subdistrict'] : '-',
      // json['subdistrict'] != null ? json['subdistrict'] : '-', //ININYA BERMASALAH HARUS E STRING, ADA RESPONSE LAIN NYA Object
      logo: json['logo'],
      joinDate: json['join_date'],
      productCount: json['product_count'],
      memberCount: json['member_count']);

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "name": name,
    "slug": slug,
    "rename": rename,
    "address": address,
    "phone_number": phone,
    "logo": logo,
    "province_id": provinceId,
    "province": province,
    "city_id": cityId,
    "city": city,
    "subdistrict_id": subdistrictId,
    "subdistrict": subdistrict,
    "join_date": joinDate,
    "product_count": productCount,
    "member_count": memberCount
  };
}


class SupplierDataResponse {
  SupplierDataResponse({
    this.data,
    this.message,
  });

  final List<SupplierDataResponseItem> data;
  final String message;

  factory SupplierDataResponse.fromJson(Map<String, dynamic> json) =>
      SupplierDataResponse(
        data: List<SupplierDataResponseItem>.from(
            json["data"].map((x) => SupplierDataResponseItem.fromJson(x))),
        message: json["message"],
      );
}

class SupplierDataResponseItem {
  SupplierDataResponseItem({
    this.id,
    this.supplierId,
    this.supplierName,
    this.productName,
    this.productDescription,
    this.productPrice,
    this.productSellingPrice,
    this.productStock,
    this.productWeight,
    this.productUnit,
    this.productStatus,
    this.productAssets,
    this.productGroceries,
    this.productVariants,
    this.categoryId,
    this.category,
    this.subCategoryId,
    this.subCategory,
    this.commission,
    this.coverPhoto
  });

  final int id;
  final int supplierId;
  final String supplierName;
  final String productName;
  final String productDescription;
  final int productPrice;
  final int productSellingPrice;
  final int productStock;
  final int productWeight;
  final String productUnit;
  final String productStatus;
  final int categoryId;
  final String category;
  final int subCategoryId;
  final String subCategory;
  final int commission;
  final String coverPhoto;
  final List<ProductAsset> productAssets;
  final List<ProductGrocery> productGroceries;
  final List<ProductVariant> productVariants;

  factory SupplierDataResponseItem.fromJson(Map<String, dynamic> json) =>
      SupplierDataResponseItem(
        id: json["id"],
        supplierId: json["supplier_id"],
        supplierName: json["supplier_name"],
        productName: json["product_name"],
        productDescription: json["product_description"],
        productPrice: json["product_price"],
        productSellingPrice : json["product_selling_price"],
        productStock: json["product_stock"],
        productWeight: json["product_weight"],
        productUnit: json["product_unit"],
        productStatus: json["product_status"],
        categoryId: json["category_id"],
        category: json["category"],
        subCategoryId: json["subcategory_id"],
        subCategory: json["subcatgory"],
        commission: json["commission"],
        coverPhoto: json["cover"],
        productAssets: List<ProductAsset>.from(
            json["product_assets"].map((x) => ProductAsset.fromJson(x))),
        productGroceries: List<ProductGrocery>.from(
            json["product_groceries"].map((x) => ProductGrocery.fromJson(x))),
        productVariants: List<ProductVariant>.from(
            json["product_variants"].map((x) => ProductVariant.fromJson(x))),
      );
}

class ProductAsset {
  ProductAsset({
    this.id,
    this.productId,
    this.submissionId,
    this.image,
    this.link,
  });

  final int id;
  final dynamic productId;
  final int submissionId;
  final String image;
  final String link;

  factory ProductAsset.fromJson(Map<String, dynamic> json) => ProductAsset(
    id: json["id"],
    productId: json["product_id"],
    submissionId: json["submission_id"],
    image: json["image"] == null ? null : json["image"],
    link: json["link"] == null ? null : json["link"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_id": productId,
    "submission_id": submissionId,
    "image": image == null ? null : image,
    "link": link == null ? null : link,
  };
}

class ProductGrocery {
  ProductGrocery({
    this.id,
    this.productId,
    this.submissionId,
    this.minimumOrder,
    this.price,
  });

  final int id;
  final int productId;
  final int submissionId;
  final int minimumOrder;
  final int price;

  factory ProductGrocery.fromJson(Map<String, dynamic> json) => ProductGrocery(
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

