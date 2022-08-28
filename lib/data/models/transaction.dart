import 'package:marketplace/data/models/models.dart';
import 'package:meta/meta.dart';

enum FetchTransactionsType { payment, onProcess, completed, orderReseller }

class FetchTransactionsResponse {
  FetchTransactionsResponse({
    @required this.status,
    @required this.message,
    @required this.data,
  });

  final String status;
  final String message;
  final List<Transaction> data;

  factory FetchTransactionsResponse.fromJson(Map<String, dynamic> json) =>
      FetchTransactionsResponse(
        status: json["status"],
        message: json["message"],
        data: List<Transaction>.from(
            json["data"].map((x) => Transaction.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Transaction {
  Transaction({
    @required this.orderId,
    @required this.orderStatusId,
    @required this.sellerId,
    @required this.transactionCode,
    @required this.orderStatus,
    @required this.shopName,
    @required this.shopPhoto,
    @required this.totalPrice,
    @required this.orderDate,
    @required this.productId,
    @required this.productName,
    @required this.paymentDetail,
    @required this.recipentName,
  });

  final int orderId;
  final int orderStatusId;
  final int sellerId;
  final String transactionCode;
  final String orderStatus;
  final String shopName;
  final String shopPhoto;
  final int totalPrice;
  final DateTime orderDate;
  final List<int> productId;
  final List<String> productName;
  final PaymentDetail paymentDetail;
  final String recipentName;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
      orderId: json["order_id"],
      orderStatusId: json["order_status_id"],
      sellerId: json["seller_id"],
      transactionCode: json["transaction_code"] ?? "-",
      orderStatus: json["order_status"],
      shopName: json["shop_name"],
      shopPhoto: json["shop_photo"],
      totalPrice: json["total_price"],
      orderDate: json["order_date"] == null
          ? null
          : DateTime.parse(json["order_date"]),
      productId: json["product_id"] == null
          ? null
          : List<int>.from(json["product_id"].map((x) => x)),
      productName: List<String>.from(json["product_name"].map((x) => x)),
      paymentDetail: json["payment"] == null
          ? null
          : PaymentDetail.fromJson(json["payment"]),
      recipentName: json["recipent_name"]);

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "order_status_id": orderStatusId,
        "transaction_code": transactionCode,
        "order_status": orderStatus,
        "shop_name": shopName,
        "shop_photo": shopPhoto,
        "total_price": totalPrice,
        "order_date":
            "${orderDate.year.toString().padLeft(4, '0')}-${orderDate.month.toString().padLeft(2, '0')}-${orderDate.day.toString().padLeft(2, '0')}",
        "product_name": List<dynamic>.from(productName.map((x) => x)),
        "payment": paymentDetail.toJson(),
      };
}
