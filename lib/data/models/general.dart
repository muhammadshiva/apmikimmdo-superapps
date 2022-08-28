import 'package:meta/meta.dart';

class GeneralResponse {
  GeneralResponse({
    @required this.status,
    @required this.message,
  });

  final String status;
  final String message;

  factory GeneralResponse.fromJson(Map<String, dynamic> json) =>
      GeneralResponse(
        status: json["status"],
        message: json["message"],
      );
}
