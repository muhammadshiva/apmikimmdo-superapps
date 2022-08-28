import 'package:flutter/foundation.dart';

class TrackingOrderResponse {
  TrackingOrderResponse({
    @required this.data,
    @required this.message,
  });

  final TrackingOrder data;
  final String message;

  factory TrackingOrderResponse.fromJson(Map<String, dynamic> json) =>
      TrackingOrderResponse(
        data: TrackingOrder.fromJson(json["data"]),
        message: json["message"],
      );
}

class TrackingOrder {
  TrackingOrder({
    @required this.airwaybill,
    @required this.logs,
  });

  final String airwaybill;
  final List<TrackingOrderLogs> logs;

  factory TrackingOrder.fromJson(Map<String, dynamic> json) => TrackingOrder(
        airwaybill: json["airway_bill"],
        logs: List<TrackingOrderLogs>.from(
            json["logs"].map((x) => TrackingOrderLogs.fromJson(x))),
      );
}

class TrackingOrderLogs {
  int id;
  int orderId;
  String note;
  String status;
  String date;
  String time;

  TrackingOrderLogs({
    this.id,
    this.orderId,
    this.note,
    this.status,
    this.date,
    this.time,
  });

  factory TrackingOrderLogs.fromJson(Map<String, dynamic> json) =>
      TrackingOrderLogs(
        id: json["id"],
        orderId: json["order_id"],
        note: json["note"] ?? "-",
        status: json["status"] ?? "-",
        date: json["date"],
        time: json["time"],
      );
}
