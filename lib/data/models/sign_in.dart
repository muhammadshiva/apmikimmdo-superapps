class SignInRequest {
  SignInRequest({
    this.phoneNumber,
    this.isUsingWa=true,
  });

  String phoneNumber;
  bool isUsingWa;

  Map<String, dynamic> toJson() => {
        "phonenumber": phoneNumber,
        "is_using_wa": isUsingWa,
      };
}

class SignInResponse {
  String token;
  String message;

  SignInResponse({
    this.token,
    this.message,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> json) => SignInResponse(
        token: json["token"],
        message: json["message"],
      );
}
