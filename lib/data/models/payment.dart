import 'package:meta/meta.dart';

enum PaymentType { manual, otomatis }

class PaymentMethodResponse {
  PaymentMethodResponse({
    @required this.message,
    @required this.data,
  });

  final String message;
  final List<PaymentMethod> data;

  factory PaymentMethodResponse.fromJson(Map<String, dynamic> json) =>
      PaymentMethodResponse(
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<PaymentMethod>.from(json["data"].map((x) => PaymentMethod.fromJson(x))),
      );
}

class Payment {
  Payment({
    @required this.id,
    @required this.verificationMethod, 
    @required this.link, 
    @required this.transactionCode, 
    @required this.status, 
    @required this.paymentDate,
    @required this.available,
    @required this.amount,
    @required this.paymentMethod,
  });

  final int id;
  final String verificationMethod;
  final String link;
  final String transactionCode;
  final int available;
  final int status;
  final String paymentDate;
  final int amount;
  final PaymentMethod paymentMethod;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json["id"],
        available: json["available"], 
        link: json['link'], 
        paymentDate: json['payment_date'], 
        status: json["status"].runtimeType == String ? int.parse(json["status"]) : json['status'], 
        transactionCode: json['transaction_code'], 
        verificationMethod: json['verification_method'],
        amount: json["amount"].runtimeType == double
            ? json["amount"].toInt()
            : json["amount"] ?? 0,
        paymentMethod: json['payment_method'] != null ? PaymentMethod.fromJson(json["payment_method"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "available": available,
        "link": link,
        "payment_date": paymentDate,
        "status": status,
        "transaction_code": transactionCode,
        "verification_method": verificationMethod,
        "amount": amount,
        "payment_method": paymentMethod,
      };
}

class PaymentMethod {
  PaymentMethod({
    @required this.id,
    @required this.name,
    @required this.verificationMethod, 
    @required this.accountNumber, 
    @required this.accountName, 
    @required this.handlingCost, 
    @required this.slug, 
    @required this.image
    
  });

  final int id;
  final String name;
  final String verificationMethod;
  final String accountNumber;
  final String accountName;
  final int handlingCost;
  final String slug;
  final String image;
  

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        id: json["id"],
        name: json["name"],
        verificationMethod: json['verification_method'],
        accountName: json['account_name'], 
        accountNumber: json['account_number'], 
        handlingCost: json['handling_cost'], 
        slug: json['slug'], 
        image: json["image"], 
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "verification_method" : verificationMethod,
        "account_name": accountName,
        "account_number" : accountNumber,
        "handling_cost": handlingCost,
        "slug" : slug,
        "image": image,
      };
}

//======================================================================================
//======================================================================================
//======================================================================================
//======================================================================================
//======================================================================================
//======================================================================================
//======================================================================================
//======================================================================================
//======================================================================================
//======================================================================================
//======================================================================================
//======================================================================================
//======================================================================================
//======================================================================================
//======================================================================================
//======================================================================================
//======================================================================================
//======================================================================================
//======================================================================================
//======================================================================================

class PaymentOrder {
  PaymentOrder({
    @required this.orderId,
    @required this.transactionCode,
    @required this.total,
    @required this.image,
    @required this.norek,
    @required this.an,
  });

  final int orderId;
  final String transactionCode;
  final int total;
  final String image;
  final String norek;
  final String an;

  factory PaymentOrder.fromJson(Map<String, dynamic> json) => PaymentOrder(
        orderId: json["order_id"],
        transactionCode: json["transaction_code"] ?? "-",
        total: json["total"],
        image: json["image"],
        norek: json["norek"],
        an: json["an"],
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "total": total,
        "image": image,
        "norek": norek,
        "an": an,
      };
}





class PaymentDetailResponse {
  PaymentDetailResponse({
    @required this.status,
    @required this.data,
  });

  final String status;
  final PaymentDetail data;

  factory PaymentDetailResponse.fromJson(Map<String, dynamic> json) =>
      PaymentDetailResponse(
        status: json["status"],
        data:
            json["data"] == null ? null : PaymentDetail.fromJson(json["data"]),
      );
}



class AddPaymentResponse {
  AddPaymentResponse({
    @required this.status,
    @required this.message,
    @required this.data,
  });

  final String status;
  final String message;
  final PaymentDetail data;

  factory AddPaymentResponse.fromJson(Map<String, dynamic> json) =>
      AddPaymentResponse(
        status: json["status"],
        message: json["message"],
        data: PaymentDetail.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class AddPaymentMidtransResponse {
  AddPaymentMidtransResponse({
    @required this.status,
    @required this.data,
  });

  final String status;
  final String data;

  factory AddPaymentMidtransResponse.fromJson(Map<String, dynamic> json) =>
      AddPaymentMidtransResponse(
        status: json["status"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data,
      };
}

class PaymentDetail {
  PaymentDetail({
    @required this.id,
    @required this.paymentVariant,
    @required this.link,
    @required this.transactionCode,
    @required this.total,
    @required this.paymentMethodId,
    @required this.norek,
    @required this.an,
    @required this.paymentStatusId,
    @required this.paymentStatus,
    @required this.image,
  });

  final int id;
  final int paymentVariant;
  final String link;
  final String transactionCode;
  final int total;
  final int paymentMethodId;
  final String norek;
  final String an;
  final int paymentStatusId;
  final String paymentStatus;
  final String image;

  factory PaymentDetail.fromJson(Map<String, dynamic> json) => PaymentDetail(
        id: json["id"],
        paymentVariant: json["payment_variant"] ?? 0,
        link: json["link"],
        transactionCode: json["transaction_code"] ?? "-",
        total: json["total"],
        paymentMethodId: json["payment_method_id"],
        norek: json["norek"],
        an: json["an"],
        paymentStatusId: json["payment_status_id"],
        paymentStatus: json["payment_status"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "payment_variant": paymentVariant,
        "link": link,
        "transaction_code": transactionCode,
        "total": total,
        "payment_method_id": paymentMethodId,
        "norek": norek,
        "an": an,
        "payment_status_id": paymentStatusId,
        "payment_status": paymentStatus,
        "image": image,
      };
}
class PaymentOrderDetailUser{

  PaymentOrderDetailUser({
    @required this.id,
    @required this.userId, 
    @required this.paymentMethodId, 
    @required this.orderId, 
    @required this.amount,
    @required this.status, 
    @required this.paymentDate, 
    @required this.transactionCode,
    @required this.paymentVariant, 
    this.link
  });

  final int id;
  final int userId;
  final int paymentMethodId;
  final int orderId;
  final int amount;
  final String status;
  final DateTime paymentDate;
  final String transactionCode;
  final int paymentVariant;
  final String link;

  factory PaymentOrderDetailUser.fromJson(Map<String, dynamic> json) => PaymentOrderDetailUser(
        id: json["id"],
        userId: json["user_id"],
        paymentMethodId: json["payment_method_id"],
        orderId: json["order_id"],
        amount: json["amount"],
        status: json["status"],
        paymentDate: DateTime.parse(json["payment_date"]),
        transactionCode: json["transaction_code"],
        paymentVariant: json["payment_variant"],
        link: json["link"] ?? "-",
  );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "payment_method_id": paymentMethodId,
        "order_id": orderId,
        "amount": amount,
        "status": status,
        "payment_date": paymentDate.toIso8601String(),
        "transaction_code": transactionCode,
        "payment_variant": paymentVariant,
        "link": link,
    };
  
}