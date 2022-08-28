import 'package:marketplace/data/models/models.dart';

class WalletHistoryResponse {
  WalletHistoryResponse({
    this.message,
    this.data,
  });

  String message;
  List<WalletHistory> data;

  factory WalletHistoryResponse.fromJson(Map<String, dynamic> json) =>
      WalletHistoryResponse(
        message: json["message"],
        data: json["data"] == null
            ? []
            : json["data"].length == 0
                ? []
                : List<WalletHistory>.from(
                    json["data"].map((x) => WalletHistory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {"message": message, "data": data};
}

class WalletHistory {
  int id;
  String type;
  String amount;
  String title;
  String date;

  WalletHistory({
    this.id,
    this.type,
    this.amount,
    this.title,
    this.date,
  });

  factory WalletHistory.fromJson(Map<String, dynamic> json) {
    return WalletHistory(
      id: json['id'],
      type: json['type'],
      amount: json['amount'],
      title: json['title'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'title': title,
      'date': date,
    };
  }
}

class WalletHistoryDetailResponse {
  WalletHistoryDetailResponse({
    this.status,
    this.message,
    this.data,
  });

  String status;
  String message;
  WalletHistoryDetailNonWithdrawal data;

  factory WalletHistoryDetailResponse.fromJson(Map<String, dynamic> json) =>
      WalletHistoryDetailResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : WalletHistoryDetailNonWithdrawal.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class WalletHistoryDetailNonWithdrawal {
  WalletHistoryDetailNonWithdrawal({
    this.id,
    this.type,
    this.amount,
    this.date,
    this.productName,
    this.productPrice,
    this.productCover,
    this.orderDate,
    this.quantity,
    this.totalPrice,
  });

  int id;
  String type;
  String amount;
  String date;
  String productName;
  String productPrice;
  String productCover;
  String orderDate;
  String quantity;
  String totalPrice;

  factory WalletHistoryDetailNonWithdrawal.fromJson(Map<String, dynamic> json) =>
      WalletHistoryDetailNonWithdrawal(
        id: json["id"],
        type: json["type"],
        amount: json["amount"],
        date: json["date"],
        productName: json["product_name"],
        productPrice: json["product_price"],
        productCover: json["product_cover"],
        orderDate: json["order_date"],
        quantity: json["quantity"].runtimeType == int ? json["quantity"].toString() : json["quantity"] ?? null,
        totalPrice: json["total_price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "amount": amount,
        "date": date,
        "product_name": productName,
        "product_price": productPrice,
        "product_cover": productCover,
        "order_date": orderDate,
        "quantity": quantity,
        "total_price": totalPrice
      };
}

class WalletHistoryDetailWithdrawal {
  WalletHistoryDetailWithdrawal({
    this.id,
    this.type,
    this.amount,
    this.date,
    this.productName,
    this.productPrice,
    this.productCover,
    this.orderDate,
    this.quantity,
    this.totalPrice,
  });

  int id;
  String type;
  String amount;
  String date;
  String productName;
  String productPrice;
  String productCover;
  String orderDate;
  String quantity;
  String totalPrice;

  factory WalletHistoryDetailWithdrawal.fromJson(Map<String, dynamic> json) =>
      WalletHistoryDetailWithdrawal(
        id: json["id"],
        type: json["type"],
        amount: json["amount"],
        date: json["date"],
        productName: json["product_name"],
        productPrice: json["product_price"],
        productCover: json["product_cover"],
        orderDate: json["order_date"],
        quantity: json["quantity"].runtimeType == int ? json["quantity"].toString() : json["quantity"] ?? null,
        totalPrice: json["total_price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "amount": amount,
        "date": date,
        "product_name": productName,
        "product_price": productPrice,
        "product_cover": productCover,
        "order_date": orderDate,
        "quantity": quantity,
        "total_price": totalPrice
      };
}

class WalletWithdrawData {
  final int logId;
  final int saldo, noRek;
  final PaymentMethod paymentMethod;
  final String atasNama;

  WalletWithdrawData({this.saldo, this.noRek, this.paymentMethod, this.atasNama, this.logId});
}

class WalletWithdrawResponse {
  WalletWithdrawResponse({
    this.message,
    this.data,
  });

  String message;
  WalletWithdrawResponseData data;

  factory WalletWithdrawResponse.fromJson(Map<String, dynamic> json) =>
      WalletWithdrawResponse(
        message: json["message"],
        data: json["data"] == null
            ? null
            : WalletWithdrawResponseData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data,
      };
}

class WalletWithdrawResponseData {
  WalletWithdrawResponseData({
    this.logId,
  });

  int logId;

  factory WalletWithdrawResponseData.fromJson(Map<String, dynamic> json) =>
      WalletWithdrawResponseData(logId: json['id']);

  Map<String, dynamic> toJson() => {
        "id": logId,
      };
}

class WalletWithdrawRuleResponse {
  WalletWithdrawRuleResponse({
    this.message,
    this.data,
  });

  String message;
  List<WalletWithdrawRule> data;

  factory WalletWithdrawRuleResponse.fromJson(Map<String, dynamic> json) =>
      WalletWithdrawRuleResponse(
        message: json["message"],
        data: json["data"] == null
            ? []
            : json["data"].length == 0
                ? []
                : List<WalletWithdrawRule>.from(
                    json["data"].map((x) => WalletWithdrawRule.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {"message": message, "data": data};
}

class WalletWithdrawRule {
  WalletWithdrawRule({
    this.minWithdraw,
  });

  int minWithdraw;

  factory WalletWithdrawRule.fromJson(Map<String, dynamic> json) =>
      WalletWithdrawRule(minWithdraw: json['minimum_withdraw']);

  Map<String, dynamic> toJson() => {
        "minimum_withdraw": minWithdraw,
      };
}