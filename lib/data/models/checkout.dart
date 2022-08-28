import 'package:marketplace/data/models/models.dart';
import 'package:meta/meta.dart';

class CheckoutRequestWarung {
  CheckoutRequestWarung({
    @required this.productId,
    @required this.quantity,
  });

  int productId;
  int quantity;

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "quantity": quantity,
      };
}

class CheckoutResponse {
  CheckoutResponse({
    @required this.status,
    @required this.message,
    @required this.data,
    @required this.summary,
    @required this.paymentMethod,
  });

  final String status;
  final String message;
  final CheckoutOrder data;
  final List<OrderSummary> summary;
  final List<Payment> paymentMethod;

  factory CheckoutResponse.fromJson(Map<String, dynamic> json) =>
      CheckoutResponse(
        status: json["status"],
        message: json["message"],
        data: CheckoutOrder.fromJson(json["data"]),
        summary: json["summary"].length == 0
            ? []
            : List<OrderSummary>.from(
                json["summary"].map((x) => OrderSummary.fromJson(x))),
        paymentMethod: json["payment_method"].length == 0
            ? []
            : List<Payment>.from(
                json["payment_method"].map((x) => Payment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
        "summary": List<dynamic>.from(summary.map((x) => x.toJson())),
        "payment_method":
            List<dynamic>.from(paymentMethod.map((x) => x.toJson())),
      };
}

class CheckoutBookingResponse {
  CheckoutBookingResponse({
    @required this.message,
    @required this.data,
    @required this.summary,
    @required this.paymentMethod,
  });

  final String message;
  final CheckoutOrder data;
  final OrderSummary summary;
  final List<Payment> paymentMethod;

  factory CheckoutBookingResponse.fromJson(Map<String, dynamic> json) =>
      CheckoutBookingResponse(
        message: json["message"],
        data: CheckoutOrder.fromJson(json["data"]),
        summary: OrderSummary.fromJson(json["summary"]),
        paymentMethod: json["payment_method"].length == 0
            ? []
            : List<Payment>.from(
                json["payment_method"].map((x) => Payment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
        "summary": summary.toJson(),
        "payment_method":
            List<dynamic>.from(paymentMethod.map((x) => x.toJson())),
      };
}

class CheckoutOrder {
  CheckoutOrder({
    @required this.recipentId,
    @required this.buyerId,
    @required this.sellerId,
    @required this.subtotal,
    @required this.ongkir,
    @required this.totalPayment,
    @required this.shippingCode,
    @required this.orderStatus,
    @required this.orderDate,
    @required this.id,
  });

  final int id;
  final int recipentId;
  final int buyerId;
  final int sellerId;
  final int ongkir;
  final int totalPayment;
  final int subtotal;
  final String shippingCode;
  final int orderStatus;
  final DateTime orderDate;

  factory CheckoutOrder.fromJson(Map<String, dynamic> json) => CheckoutOrder(
        recipentId: json["recipent_id"],
        buyerId: json["buyer_id"],
        sellerId: json["seller_id"],
        ongkir: json["ongkir"],
        subtotal: json["subtotal"],
        totalPayment: json["total_payment"],
        shippingCode: json["shipping_code"],
        orderStatus: json["order_status"],
        orderDate: DateTime.parse(json["order_date"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "recipent_id": recipentId,
        "buyer_id": buyerId,
        "seller_id": sellerId,
        "ongkir": ongkir,
        "total_payment": totalPayment,
        "subtotal": subtotal,
        "shipping_code": shippingCode,
        "order_status": orderStatus,
        "order_date": orderDate.toIso8601String(),
        "id": id,
      };
}

class OrderSummary {
  OrderSummary({
    @required this.orderId,
    @required this.productName,
    @required this.quantity,
    @required this.ongkir,
    @required this.subtotal,
    @required this.total,
  });

  final String orderId;
  final String productName;
  final int quantity;
  final int ongkir;
  final int subtotal;
  final int total;

  factory OrderSummary.fromJson(Map<String, dynamic> json) => OrderSummary(
        orderId: json["order_id"],
        productName: json["product_name"],
        quantity: json["quantity"],
        ongkir: json["ongkir"],
        subtotal: json["subtotal"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "product_name": productName,
        "quantity": quantity,
        "ongkir": ongkir,
        "subtotal": subtotal,
        "total": total,
      };
}

class CheckoutTempData{
  final int orderId;
  final int sellerId;
  final int shippingAddressId;
  final int shippingCost;
  final String selectedShippingServiceCode;
  final int userId;

  CheckoutTempData({@required this.orderId,@required this.sellerId, @required this.shippingAddressId, @required this.shippingCost, @required this.selectedShippingServiceCode, @required this.userId});
}
