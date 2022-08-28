import 'package:flutter/foundation.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/models/new_models/alamat_pelanggan.dart';

//=========================Buat CHECKOUT Model bayangan=============================
class WppCheckoutTempWeb {
  List<NewCart> cart;
  List<ShippingCodeTemp> shippingCode;
  List<NoteTemp> note;
  List<int> itemId;
  List<OngkirTemp> ongkir;
  int subtotal, totalPayment, totalOngkir;
  AlamatPelangganWithCart alamatPelangganWithCart;

  WppCheckoutTempWeb(
      {this.cart,
      this.itemId,
      this.shippingCode,
      this.note,
      this.ongkir,
      this.subtotal,
      this.totalPayment,
      this.alamatPelangganWithCart,
      this.totalOngkir});

    factory WppCheckoutTempWeb.fromJson(Map<String, dynamic> json) =>
      WppCheckoutTempWeb(
        cart: List<NewCart>.from(
            json["cart"].map((x) => NewCart.fromJson(x))),
        itemId: List<int>.from(
            json["item_id"].map((x) => x)),
        shippingCode: List<ShippingCodeTemp>.from(
            json["shipping_code"].map((x) => ShippingCodeTemp.fromJson(x))),
        note: List<NoteTemp>.from(
            json["note"].map((x) => NoteTemp.fromJson(x))),
        ongkir: List<OngkirTemp>.from(
            json["ongkir"].map((x) => OngkirTemp.fromJson(x))),
        subtotal: json["sub_total"],
        totalPayment: json["total_payment"],
        alamatPelangganWithCart: AlamatPelangganWithCart.fromJson(json['alamat_with_cart']),
        totalOngkir: json["total_ongkir"],
        
      );
  
  Map<String, dynamic> toJson() => {
        "cart": cart,
        "item_id": itemId,
        "shipping_code": shippingCode,
        "note": note,
        "ongkir": ongkir,
        "sub_total": subtotal,
        "total_payment": totalPayment,
        "alamat_with_cart" : alamatPelangganWithCart,
        "total_ongkir": totalOngkir,
      };
}

class CheckoutTemp {
  List<NewCart> cart;
  List<ShippingCodeTemp> shippingCode;
  List<NoteTemp> note;
  List<int> itemId;
  List<OngkirTemp> ongkir;
  int subtotal, totalPayment, totalOngkir;

  CheckoutTemp(
      {this.cart,
      this.itemId,
      this.shippingCode,
      this.note,
      this.ongkir,
      this.subtotal,
      this.totalPayment,
      this.totalOngkir});
  
}

class ShippingCodeTemp {
  int id;
  int indexWidget;
  String shippingCode;

  ShippingCodeTemp({this.id, this.shippingCode, this.indexWidget});

  factory ShippingCodeTemp.fromJson(Map<String, dynamic> json) =>
      ShippingCodeTemp(
        id: json["id"],
        indexWidget: json["index_widget"],
        shippingCode: json["shipping_code"],
       
      );
  
  Map<String, dynamic> toJson() => {
        "id": id,
        "index_widget": indexWidget,
        "shipping_code": shippingCode,
      };
}

class NoteTemp {
  int id;
  int indexWidget;
  String note;

  NoteTemp({this.id, this.note, this.indexWidget});

  factory NoteTemp.fromJson(Map<String, dynamic> json) =>
      NoteTemp(
        id: json["id"],
        indexWidget: json["index_widget"],
        note: json["note"],
       
      );
  
  Map<String, dynamic> toJson() => {
        "id": id,
        "index_widget": indexWidget,
        "note": note,
      };
}

class OngkirTemp {
  int id;
  int indexWidget;
  int ongkir;
  String courier;

  OngkirTemp({this.id, this.ongkir, this.indexWidget, this.courier});

  factory OngkirTemp.fromJson(Map<String, dynamic> json) =>
      OngkirTemp(
        id: json["id"],
        indexWidget: json["index_widget"],
        ongkir: json["ongkir"],
        courier: json["courier"],
       
      );
  
  Map<String, dynamic> toJson() => {
        "id": id,
        "index_widget": indexWidget,
        "ongkir": ongkir,
        "courier": courier,
      };
}

class WppInvoice {
  WppCheckoutTempWeb checkout;
 GeneralOrderResponseData order;

  WppInvoice(
      {
        this.checkout,
        this.order,
     });

    factory WppInvoice.fromJson(Map<String, dynamic> json) =>
      WppInvoice(
        checkout: WppCheckoutTempWeb.fromJson(json['checkout']),
        order: GeneralOrderResponseData.fromJson(json['order'])
        
      );
  
  Map<String, dynamic> toJson() => {
        "checkout": checkout,
        "order": order,
      
      };
}

//=================================================================
class GeneralOrderResponse {
  GeneralOrderResponse({
    @required this.message,
    @required this.data,
  });

  final String message;
  final GeneralOrderResponseData data;

  factory GeneralOrderResponse.fromJson(Map<String, dynamic> json) =>
      GeneralOrderResponse(
        message: json["message"],
        data: json["data"] != null
            ? GeneralOrderResponseData.fromJson(json["data"])
            : null,
      );
}

class GeneralOrderResponseData {
  GeneralOrderResponseData({
    @required this.payment,
  });

  final Payment payment;

  factory GeneralOrderResponseData.fromJson(Map<String, dynamic> json) =>
      GeneralOrderResponseData(
        payment:
            json['payment'] != null ? Payment.fromJson(json["payment"]) : null,
      );
   Map<String, dynamic> toJson() => {
        "payment": payment,
  };
}

// ============================== NO AUTH ==================================
class GeneralOrderNoAuthResponseData {
  GeneralOrderNoAuthResponseData({
    @required this.carts,
  });

  final List<CartTempAddOrderNoAuth> carts;

  factory GeneralOrderNoAuthResponseData.fromJson(Map<String, dynamic> json) =>
      GeneralOrderNoAuthResponseData(
        carts: List<CartTempAddOrderNoAuth>.from(
            json["carts"].map((x) => CartTempAddOrderNoAuth.fromJson(x))),
      );
  
  Map<String, dynamic> toJson() => {
        "carts": carts,
  };
}

class CartTempAddOrderNoAuth {
  CartTempAddOrderNoAuth({
    @required this.supplierId,
    @required this.ongkir,
    @required this.shippingCode,
    @required this.note,
    @required this.products,
  });

  int supplierId;
  int ongkir;
  String shippingCode;
  String note;
  List<ProductAddOrderNoAuth> products;

  factory CartTempAddOrderNoAuth.fromJson(Map<String, dynamic> json) =>
      CartTempAddOrderNoAuth(
        supplierId: json["supplier_id"],
        ongkir: json["ongkir"],
        shippingCode: json["shipping_code"],
        note: json["note"],
        products: List<ProductAddOrderNoAuth>.from(
            json["products"].map((x) => ProductAddOrderNoAuth.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "supplier_id": supplierId,
        "ongkir": ongkir,
        "shipping_code": shippingCode,
        "note": note,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class ProductAddOrderNoAuth {
  ProductAddOrderNoAuth({
    @required this.productId,
    @required this.isVariant,
    @required this.variantId,
    @required this.quantity,
  });

  int productId;
  int isVariant;
  int variantId;
  int quantity;

  factory ProductAddOrderNoAuth.fromJson(Map<String, dynamic> json) =>
      ProductAddOrderNoAuth(
        productId: json["product_id"],
        isVariant: json["is_variant"],
        variantId: json["variant_id"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "is_variant": isVariant,
        "variant_id": variantId,
        "quantity": quantity,
      };
}

//******GET ORDER RESPONSE*******//

class OrderResponse {
  OrderResponse({
    @required this.data,
    @required this.links,
    @required this.meta,
    @required this.message,
  });

  final List<OrderResponseData> data;
  final Links links;
  final Meta meta;
  final String message;

  factory OrderResponse.fromJson(Map<String, dynamic> json) => OrderResponse(
        data: List<OrderResponseData>.from(
            json["data"].map((x) => OrderResponseData.fromJson(x))),
        links: Links.fromJson(json["links"]),
        meta: Meta.fromJson(json["meta"]),
        message: json["message"],
      );
}

class OrderResponseData {
  OrderResponseData({
    @required this.id,
    @required this.status,
    @required this.paymentMethod,
    @required this.transactionCode,
    @required this.recipientName,
    @required this.courirer,
    @required this.city,
    @required this.cover,
    @required this.title,
    @required this.subtitle,
    @required this.orderDate,
    @required this.totalPrice,
    @required this.createdAt,
  });

  final int id;
  final String status;
  final String paymentMethod;
  final String transactionCode;
  final String recipientName;
  final String courirer;
  final String city;
  final String cover;
  final String title;
  final String subtitle;
  final String orderDate;
  final String totalPrice;
  final DateTime createdAt;

  factory OrderResponseData.fromJson(Map<String, dynamic> json) =>
      OrderResponseData(
        id: json["id"],
        status: json["status"],
        paymentMethod: json["payment_method"],
        transactionCode: json["transaction_code"],
        recipientName: json["recipient_name"],
        courirer: json["courirer"],
        city: json["city"],
        cover: json["cover"],
        title: json["title"],
        subtitle: json["subtitle"] == null ? null : json["subtitle"],
        orderDate: json["order_date"],
        totalPrice: json["total_price"],
        createdAt: DateTime.parse(json["created_at"]),
      );
}

class Links {
  Links({
    @required this.first,
    @required this.last,
    @required this.prev,
    @required this.next,
  });

  final String first;
  final String last;
  final String prev;
  final String next;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        first: json["first"],
        last: json["last"],
        prev: json["prev"],
        next: json["next"],
      );

  Map<String, dynamic> toJson() => {
        "first": first,
        "last": last,
        "prev": prev,
        "next": next,
      };
}

class Meta {
  Meta({
    @required this.currentPage,
    @required this.from,
    @required this.lastPage,
    @required this.links,
    @required this.path,
    @required this.perPage,
    @required this.to,
    @required this.total,
  });

  final int currentPage;
  final int from;
  final int lastPage;
  final List<Link> links;
  final String path;
  final int perPage;
  final int to;
  final int total;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json["current_page"],
        from: json["from"],
        lastPage: json["last_page"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        path: json["path"],
        perPage: json["per_page"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "from": from,
        "last_page": lastPage,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "path": path,
        "per_page": perPage,
        "to": to,
        "total": total,
      };
}

class Link {
  Link({
    @required this.url,
    @required this.label,
    @required this.active,
  });

  final String url;
  final String label;
  final bool active;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"] == null ? null : json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url == null ? null : url,
        "label": label,
        "active": active,
      };
}

//******TRANSAKSI ORDER MENUNGGU PEMBAYARAN*******//
class OrderMenungguPembayaran {
  OrderMenungguPembayaran({
    @required this.data,
    @required this.links,
    @required this.meta,
    @required this.message,
  });

  final List<OrderMenungguPembayaranData> data;
  final Links links;
  final Meta meta;
  final String message;

  factory OrderMenungguPembayaran.fromJson(Map<String, dynamic> json) =>
      OrderMenungguPembayaran(
        data: List<OrderMenungguPembayaranData>.from(
            json["data"].map((x) => OrderMenungguPembayaranData.fromJson(x))),
        links: Links.fromJson(json["links"]),
        meta: Meta.fromJson(json["meta"]),
        message: json["message"],
      );
}

class OrderMenungguPembayaranData {
  OrderMenungguPembayaranData({
    @required this.id,
    @required this.transactionCode,
    @required this.verificationMethod,
    @required this.link,
    @required this.status,
    @required this.amount,
    @required this.bankName,
    @required this.bankLogo,
    @required this.accountName,
    @required this.accountNumber,
    @required this.orderName,
    @required this.orderDate,
    @required this.deliveryDate,
    @required this.createdAt,
  });

  final int id;
  final String transactionCode;
  final String verificationMethod;
  final String link;
  final String status;
  final String amount;
  final String bankName;
  final String bankLogo;
  final String accountName;
  final String accountNumber;
  final String orderName;
  final String orderDate;
  final String deliveryDate;
  final DateTime createdAt;

  factory OrderMenungguPembayaranData.fromJson(Map<String, dynamic> json) =>
      OrderMenungguPembayaranData(
        id: json["id"],
        transactionCode: json["transaction_code"],
        verificationMethod: json["verification_method"],
        link: json["link"],
        status: json["status"],
        amount: json["amount"],
        bankName: json["bank_name"],
        bankLogo: json["bank_logo"],
        accountName: json["account_name"],
        accountNumber: json["account_number"],
        orderName: json["order_name"] ?? '-',
        orderDate: json["order_date"] ?? '-',
        deliveryDate: json["delivery_date"] ?? '-',
        createdAt: DateTime.parse(json["created_at"]),
      );
}

//****TRANSAKSI DETAIL****//

class OrderDetailResponse {
  OrderDetailResponse({
    @required this.data,
    @required this.message,
  });

  final OrderDetailResponseData data;
  final String message;

  factory OrderDetailResponse.fromJson(Map<String, dynamic> json) =>
      OrderDetailResponse(
        data: json["data"] != null
            ? OrderDetailResponseData.fromJson(json["data"])
            : null,
        message: json["message"],
      );
}

class OrderDetailResponseData {
  OrderDetailResponseData({
    @required this.id,
    @required this.status,
    @required this.recipientName,
    @required this.sellerName,
    @required this.transactionCode,
    @required this.orderDate,
    @required this.deliveryDate,
    @required this.products,
    @required this.paymentMethod,
    @required this.totalItem,
    @required this.subtotal,
    @required this.shippingCost,
    @required this.total,
    @required this.courier,
    @required this.note,
    @required this.airwayBill,
    @required this.recipientAddress,
    @required this.hubAddress,
    @required this.createdAt,
  });

  final int id;
  final String status;
  final String recipientName;
  final String orderDate;
  final String sellerName;
  final String deliveryDate;
  final String transactionCode;
  final List<ProductOrder> products;
  final String paymentMethod;
  final int totalItem;
  final String subtotal;
  final String shippingCost;
  final String total;
  final String courier;
  final String note;
  final String airwayBill;
  final String recipientAddress;
  final String hubAddress;
  final DateTime createdAt;

  factory OrderDetailResponseData.fromJson(Map<String, dynamic> json) =>
      OrderDetailResponseData(
        id: json["id"],
        status: json["status"],
        recipientName: json["recipient_name"],
        sellerName: json["seller_name"],
        transactionCode: json["transaction_code"],
        orderDate: json["order_date"],
        deliveryDate: json["delivery_date"],
        products: List<ProductOrder>.from(
            json["products"].map((x) => ProductOrder.fromJson(x))),
        paymentMethod: json["payment_method"],
        totalItem: json["total_item"],
        subtotal: json["subtotal"],
        shippingCost: json["shipping_cost"],
        total: json["total"],
        courier: json["courier"],
        note: json["note"],
        airwayBill: json["airway_bill"],
        recipientAddress: json["recipient_address"],
        hubAddress: json["hub_address"],
        createdAt: DateTime.parse(json["created_at"]),
      );
}

class ProductOrder {
  ProductOrder({
    @required this.id,
    @required this.name,
    @required this.cover,
    @required this.price,
    @required this.quantity,
    @required this.weight,
    @required this.subtotal,
    @required this.total,
    @required this.isVariant,
  });

  final int id;
  final String name;
  final String cover;
  final String price;
  final int quantity;
  final String subtotal;
  final String weight;
  final String total;
  final bool isVariant;

  factory ProductOrder.fromJson(Map<String, dynamic> json) => ProductOrder(
        id: json["id"],
        name: json["name"],
        cover: json["cover"],
        price: json["price"],
        quantity: json["quantity"],
        weight: json["weight"],
        subtotal: json["subtotal"],
        total: json["total"],
        isVariant: json["is_variant"],
      );
}

//*****TRANSAKSI DETAIL SUPPLIER*****//
class OrderDetailSupplierResponse {
  OrderDetailSupplierResponse({
    @required this.data,
    @required this.message,
  });

  final OrderDetailSupplierResponseData data;
  final String message;

  factory OrderDetailSupplierResponse.fromJson(Map<String, dynamic> json) =>
      OrderDetailSupplierResponse(
        data: OrderDetailSupplierResponseData.fromJson(json["data"]),
        message: json["message"],
      );
}

class OrderDetailSupplierResponseData {
  OrderDetailSupplierResponseData({
    @required this.id,
    @required this.status,
    @required this.transactionCode,
    @required this.recipientName,
    @required this.orderDate,
    @required this.sentDate,
    @required this.sellerName,
    @required this.sellerAddress,
    @required this.products,
    @required this.paymentMethod,
    @required this.productSubtotal,
    @required this.shippingSubtotal,
    @required this.handlingFee,
    @required this.totalPayment,
    @required this.courirer,
    @required this.airwayBill,
    @required this.shippingAddress,
    @required this.hubAddress,
  });

  final int id;
  final String status;
  final String transactionCode;
  final String recipientName;
  final String orderDate;
  final dynamic sentDate;
  final String sellerName;
  final String sellerAddress;
  final List<ProductOrderSupplier> products;
  final String paymentMethod;
  final String productSubtotal;
  final String shippingSubtotal;
  final String handlingFee;
  final String totalPayment;
  final String courirer;
  final dynamic airwayBill;
  final String shippingAddress;
  final String hubAddress;

  factory OrderDetailSupplierResponseData.fromJson(Map<String, dynamic> json) =>
      OrderDetailSupplierResponseData(
        id: json["id"],
        status: json["status"],
        transactionCode: json["transaction_code"],
        recipientName: json["recipient_name"],
        orderDate: json["order_date"],
        sentDate: json["sent_date"],
        sellerName: json["seller_name"],
        sellerAddress: json["seller_address"],
        products: List<ProductOrderSupplier>.from(
            json["products"].map((x) => ProductOrderSupplier.fromJson(x))),
        paymentMethod: json["payment_method"],
        productSubtotal: json["product_subtotal"],
        shippingSubtotal: json["shipping_subtotal"],
        handlingFee: json["handling_fee"],
        totalPayment: json["total_payment"],
        courirer: json["courirer"],
        airwayBill: json["airway_bill"],
        shippingAddress: json["shipping_address"],
        hubAddress: json["hub_address"],
      );
}

class ProductOrderSupplier {
  ProductOrderSupplier({
    @required this.id,
    @required this.cover,
    @required this.title,
    @required this.subtitle,
    @required this.price,
    @required this.isVariant,
    @required this.variantName,
  });

  final int id;
  final String cover;
  final String title;
  final String subtitle;
  final String price;
  final bool isVariant;
  final dynamic variantName;

  factory ProductOrderSupplier.fromJson(Map<String, dynamic> json) =>
      ProductOrderSupplier(
        id: json["id"],
        cover: json["cover"],
        title: json["title"],
        subtitle: json["subtitle"],
        price: json["price"],
        isVariant: json["is_variant"],
        variantName: json["variant_name"],
      );
}

//***TRANSAKSI DETAIL MENUNGGU PEMBAYARAN***//

class OrderDetailMenungguPembayaranResponse {
  OrderDetailMenungguPembayaranResponse({
    @required this.data,
    @required this.message,
  });

  final OrderDetailMenungguPembayaranResponseData data;
  final String message;

  factory OrderDetailMenungguPembayaranResponse.fromJson(
          Map<String, dynamic> json) =>
      OrderDetailMenungguPembayaranResponse(
        data: OrderDetailMenungguPembayaranResponseData.fromJson(json["data"]),
        message: json["message"],
      );
}

class OrderDetailMenungguPembayaranResponseData {
  OrderDetailMenungguPembayaranResponseData({
    @required this.id,
    @required this.transactionCode,
    @required this.status,
    @required this.totalPayment,
    @required this.bankName,
    @required this.accountName,
    @required this.accountNumber,
    @required this.orderName,
    @required this.orderDate,
    @required this.deliveryDate,
    @required this.orders,
    @required this.totalOngkir,
    @required this.subtotal,
  });

  final int id;
  final String transactionCode;
  final String status;
  final String totalPayment;
  final String bankName;
  final String accountName;
  final String accountNumber;
  final String orderName;
  final String orderDate;
  final String deliveryDate;
  final List<OrderDetailMenungguPembayaranResponseDataOrder> orders;
  final String totalOngkir;
  final String subtotal;

  factory OrderDetailMenungguPembayaranResponseData.fromJson(
          Map<String, dynamic> json) =>
      OrderDetailMenungguPembayaranResponseData(
        id: json["id"],
        transactionCode: json["transaction_code"],
        status: json["status"],
        totalPayment: json["total_payment"],
        bankName: json["bank_name"],
        accountName: json["account_name"],
        accountNumber: json["account_number"],
        orderName: json["order_name"] ?? '-',
        orderDate: json["order_date"] ?? '-',
        deliveryDate: json["delivery_date"] ?? '-',
        orders: List<OrderDetailMenungguPembayaranResponseDataOrder>.from(
            json["orders"].map((x) =>
                OrderDetailMenungguPembayaranResponseDataOrder.fromJson(x))),
        totalOngkir: json["total_ongkir"],
        subtotal: json["subtotal"],
      );
}

class OrderDetailMenungguPembayaranResponseDataOrder {
  OrderDetailMenungguPembayaranResponseDataOrder({
    @required this.id,
    @required this.sellerName,
    @required this.sellerAddress,
    @required this.note,
    @required this.items,
    @required this.ongkir,
    @required this.subtotal,
    @required this.totalPayment,
    @required this.courier,
    @required this.airwayBill,
    @required this.recipientAddress,
    @required this.hubAddress,
  });

  final int id;
  final String sellerName;
  final String sellerAddress;
  final String note;
  final List<OrderDetailMenungguPembayaranResponseDataItem> items;
  final String ongkir;
  final String subtotal;
  final String totalPayment;
  final String courier;
  final String airwayBill;
  final String recipientAddress;
  final String hubAddress;

  factory OrderDetailMenungguPembayaranResponseDataOrder.fromJson(
          Map<String, dynamic> json) =>
      OrderDetailMenungguPembayaranResponseDataOrder(
        id: json["id"],
        sellerName: json["seller_name"],
        sellerAddress: json["seller_address"],
        note: json["note"] ?? "",
        items: List<OrderDetailMenungguPembayaranResponseDataItem>.from(
            json["items"].map((x) =>
                OrderDetailMenungguPembayaranResponseDataItem.fromJson(x))),
        ongkir: json["ongkir"],
        subtotal: json["subtotal"],
        totalPayment: json["total_payment"],
        courier: json["courier"],
        airwayBill: json["airway_bill"] ?? "-",
        recipientAddress: json["recipient_address"],
        hubAddress: json["hub_address"],
      );
}

class OrderDetailMenungguPembayaranResponseDataItem {
  OrderDetailMenungguPembayaranResponseDataItem({
    @required this.id,
    @required this.productName,
    @required this.productImage,
    @required this.productPrice,
    @required this.quantity,
    @required this.totalPrice,
    @required this.variantName,
  });

  final int id;
  final String productName;
  final String productImage;
  final String productPrice;
  final int quantity;
  final String totalPrice;
  final String variantName;

  factory OrderDetailMenungguPembayaranResponseDataItem.fromJson(
          Map<String, dynamic> json) =>
      OrderDetailMenungguPembayaranResponseDataItem(
        id: json["id"],
        productName: json["product_name"],
        productImage: json["product_image"],
        productPrice: json["product_price"],
        quantity: json["quantity"],
        totalPrice: json["total_price"],
        variantName: json["variant_name"] ?? "",
      );
}
