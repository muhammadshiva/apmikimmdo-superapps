class SignUpRequest {
  SignUpRequest({
    this.name,
    this.phonenumber,
    this.isUsingWa = true,
  });

  String name;
  String phonenumber;
  bool isUsingWa;

  Map<String, dynamic> toJson() => {
        "name": name,
        "phonenumber": phonenumber,
        "is_using_wa": isUsingWa,
      };
}

class SignUpResponse {
  SignUpResponse({
    this.status,
    this.message,
  });

  String status;
  String message;

  factory SignUpResponse.fromJson(Map<String, dynamic> json) => SignUpResponse(
        status: json["status"],
        message: json["message"],
      );
}
