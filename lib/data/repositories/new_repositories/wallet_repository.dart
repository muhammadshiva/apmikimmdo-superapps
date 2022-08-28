import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/new_models/wallets.dart';
import 'package:marketplace/data/repositories/repositories.dart';
import 'package:marketplace/utils/constants.dart' as AppConst;

class WalletRepository {
  final ApiProvider _provider = ApiProvider();
  final AuthenticationRepository _authenticationRepository =
      AuthenticationRepository();
  final String _adsKey = AppConst.API_ADS_KEY;
  final String _baseUrl = AppConst.API_URL;
  Dio dio = new Dio();

  Future<WalletHistoryResponse> getWalletHistoryList() async {
    final _token = await _authenticationRepository.getToken();
    final response = await _provider.get("/user/wallet/logs", headers: {
      HttpHeaders.authorizationHeader: 'Bearer $_token',
      'ADS-Key': _adsKey
    });

    return WalletHistoryResponse.fromJson(response);
  }

  Future<WalletHistoryDetailResponse> fetchHistoryDetail(
      {@required int historyId}) async {
    final _token = await _authenticationRepository.getToken();
    final response = await _provider.get("/user/wallet/logs/$historyId",
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $_token',
          'ADS-Key': _adsKey
        });

    return WalletHistoryDetailResponse.fromJson(response);
  }

  Future<WalletWithdrawRuleResponse> fetchWihtdrawRule() async {
    final _token = await _authenticationRepository.getToken();
    final response = await _provider.get("/master/general",
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $_token',
          'ADS-Key': _adsKey
        });

    return WalletWithdrawRuleResponse.fromJson(response);
  }

  Future<WalletWithdrawResponse> withdrawWallet({
    @required int amount,
    @required int paymentMethodId,
    @required int accountNumber,
    @required String accountName,
  }) async {
    final token = await _authenticationRepository.getToken();
    var formData = new FormData.fromMap({
      "amount": amount,
      "payment_method_id": paymentMethodId,
      "account_number": accountNumber,
      "account_name": accountName,
    });
    debugPrint("formdata ${formData.fields}");
    var response = await dio.post(
      "$_baseUrl/user/wallet/withdraw",
      data: formData,
      options: Options(
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'text/plain',
          'ADS-Key':_adsKey
        },
        validateStatus: (status) => true
      ),
    );
    debugPrint("response $response");
    if (response.statusCode == 200) {
      final statusCode = response.data['status'];
      final message = response.data['message'] ?? 'Terjadi Kesalahan';
      return WalletWithdrawResponse.fromJson(response.data);
    } else {
      debugPrint("myresponse ${response}");
      throw GeneralException(response.data.toString());
    }
  }

  Future<void> withdrawWalletConfirmation({
    @required int logId,
    @required int confirmationCode,
  }) async {
    final token = await _authenticationRepository.getToken();
    var formData = new FormData.fromMap({
      "log_id": logId,
      "confirmation_code": confirmationCode,
    });
    debugPrint("formdata ${formData.fields}");
    var response = await dio.post(
      "$_baseUrl/user/wallet/withdraw/confirm",
      data: formData,
      options: Options(
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'text/plain',
          'ADS-Key':_adsKey
        },
        validateStatus: (status) => true
      ),
    );
    debugPrint("response $response");
    if (response.statusCode == 200) {
      final statusCode = response.data['status'];
      final message = response.data['message'] ?? 'Terjadi Kesalahan';
      debugPrint("myresponsesuccess ${response.data}");
    } else {
      debugPrint("myresponsefailure ${response}");
      throw GeneralException(response.data['message'].toString());
    }
  }

  Future<void> withdrawWalletResendOTP({
    @required int logId,
  }) async {
    final token = await _authenticationRepository.getToken();
    var formData = new FormData.fromMap({
      "log_id": logId,
    });
    debugPrint("formdata ${formData.fields}");
    var response = await dio.post(
      "$_baseUrl/user/wallet/withdraw",
      data: formData,
      options: Options(
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'text/plain',
          'ADS-Key':_adsKey
        },
        validateStatus: (status) => true
      ),
    );
    debugPrint("response $response");
    if (response.statusCode == 200) {
      final statusCode = response.data['status'];
      final message = response.data['message'] ?? 'Terjadi Kesalahan';
      debugPrint("myresponse ${response.data}");
    } else {
      debugPrint("myresponse ${response}");
      throw GeneralException(response.data.toString());
    }
  }

}
