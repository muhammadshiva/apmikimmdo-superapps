import 'package:marketplace/data/models/cart.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/models/new_models/products.dart';
import 'package:marketplace/data/models/new_models/supplier.dart';
import 'package:meta/meta.dart';

class NewCartResponse {
  NewCartResponse({
    @required this.data,
    @required this.message,
  });

  final NewCartResponseData data;
  final String message;

  factory NewCartResponse.fromJson(Map<String, dynamic> json) =>
      NewCartResponse(
        data: NewCartResponseData.fromJson(json["data"]),
        message: json["message"],
      );
}

class NewCartResponseData {
  NewCartResponseData({
    @required this.covered,
    @required this.uncovered,
  });

  final List<CartResponseElement> covered;
  final List<CartResponseElement> uncovered;

  factory NewCartResponseData.fromJson(Map<String, dynamic> json) =>
      NewCartResponseData(
        covered: List<CartResponseElement>.from(
            json["covered"].map((x) => CartResponseElement.fromJson(x))),
        uncovered: List<CartResponseElement>.from(
            json["uncovered"].map((x) => CartResponseElement.fromJson(x))),
      );
}

class CartResponseElement {
  CartResponseElement({
    @required this.supplier,
    @required this.products,
    this.reseller,
  });

  final Supplier supplier;
  final Reseller reseller;
  final List<ProductsCart> products;

  factory CartResponseElement.fromJson(Map<String, dynamic> json) =>
      CartResponseElement(
        supplier:
            json["seller"] != null ? Supplier.fromJson(json["seller"]) : null,
        reseller: json["reseller"] != null
            ? Reseller.fromJson(json["reseller"])
            : null,
        products: List<ProductsCart>.from(
            json["products"].map((x) => ProductsCart.fromJson(x))),
      );

  @override
  String toString() {
    return 'CartResponseElement{supplier: $supplier, reseller: $reseller, products: $products}';
  }
}

class ProductsCart {
  ProductsCart({
    @required this.id,
    @required this.quantity,
    @required this.productId,
    @required this.product,
    this.variantSelected
  });

  final int id;
  final int quantity;
  final int productId;
  final Products product;
  final ProductVariant variantSelected;

  factory ProductsCart.fromJson(Map<String, dynamic> json) => ProductsCart(
        id: json["id"],
        quantity: json["quantity"],
        productId: json["product_id"],
        product: Products.fromJson(json["product"]),
        variantSelected: json["variantSelected"] != null ?  ProductVariant.fromJson(json["variantSelected"]) : null
      );

  @override
  String toString() {
    return 'ProductsCart{quantity: $quantity, productId: $productId, cartId $id, product $product, variantSelected: $variantSelected}';
  }
}

class ProductCart {
  ProductCart({
    @required this.id,
    @required this.categoryId,
    @required this.submissionId,
    @required this.supplierId,
    @required this.name,
    @required this.slug,
    @required this.description,
    @required this.price,
    @required this.sellingPrice,
    @required this.disc,
    @required this.commission,
    @required this.sold,
    @required this.stock,
    @required this.weight,
    @required this.unit,
    @required this.status,
    @required this.createdAt,
    @required this.updatedAt,
    @required this.assets,
  });

  final int id;
  final int categoryId;
  final int submissionId;
  final int supplierId;
  final String name;
  final String slug;
  final String description;
  final int price;
  final int sellingPrice;
  final int disc;
  final int commission;
  final int sold;
  final int stock;
  final int weight;
  final String unit;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ProductPhoto> assets;

  factory ProductCart.fromJson(Map<String, dynamic> json) => ProductCart(
        id: json["id"],
        categoryId: json["category_id"],
        submissionId: json["submission_id"],
        supplierId: json["supplier_id"],
        name: json["name"],
        slug: json["slug"],
        description: json["description"],
        price: json["price"],
        sellingPrice: json["selling_price"],
        disc: json["disc"],
        commission: json["commission"],
        sold: json["sold"],
        stock: json["stock"],
        weight: json["weight"],
        unit: json["unit"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        assets: List<ProductPhoto>.from(
            json["assets"].map((x) => ProductPhoto.fromJson(x))),
      );
}

class NewCart {
  final int sellerId;
  final int resellerId;
  final String nameSeller;
  final String city;
  final List<CartProduct> product;

  const NewCart({
    @required this.sellerId,
    this.resellerId,
    this.nameSeller,
    @required this.city,
    @required this.product,
  });

  factory NewCart.fromJson(Map<String, dynamic> json) => NewCart(
        sellerId: json["sellerId"],
        resellerId: json["resellerId"],
        nameSeller: json["nameSeller"],
        city: json["city"],
        product: json["product"] == null
            ? []
            : List<CartProduct>.from(
                json["product"].map((x) => CartProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() {
    return {
      'sellerId': sellerId,
      'resellerId': resellerId,
      'nameSeller': nameSeller,
      'city': city,
      'product': product
    };
  }

  @override
  String toString() {
    return 'NewCart{sellerId: $sellerId, resellerId: $resellerId, nameSeller: $nameSeller, product: $product}';
  }
}


class ProductsCartVariantSelectedNoAuth {
  ProductsCartVariantSelectedNoAuth({
    @required this.variantId,
    @required this.isVariant,
    @required this.variantName,
  });

  final int variantId;
  final int isVariant;
  final String variantName;

  factory ProductsCartVariantSelectedNoAuth.fromJson(Map<String, dynamic> json) => ProductsCartVariantSelectedNoAuth(
        variantId: json["variantId"],
        isVariant: json["isVariant"],
        variantName: json["variantName"],
      );

  Map<String, dynamic> toJson() {
    return {
      'variantId': variantId,
      'isVariant': isVariant,
      'variantName': variantName,
    };
  }

  @override
  String toString() {
    return 'ProductsCartVariantSelectedNoAuth{variantId: $variantId, isVariant: $isVariant, variantName: $variantName}';
  }
}
