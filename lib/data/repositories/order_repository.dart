import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/checkout.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/models/new_models/tracking.dart';
import 'package:marketplace/data/repositories/repositories.dart';
import 'package:meta/meta.dart';
import 'package:marketplace/utils/constants.dart' as AppConst;

class OrderRepository {
  final ApiProvider _provider = ApiProvider();
  final AuthenticationRepository _authenticationRepository =
      AuthenticationRepository();
  final String _baseUrl = AppConst.API_URL;
  final String _adsKey = AppConst.API_ADS_KEY;
  Dio dio = new Dio();

  Future<GeneralOrderResponse> addOrder({
    @required List<int> itemId,
    @required int recipientId,
    @required List<String> shippingCode,
    @required List<int> ongkir,
    @required List<String> note,
    @required String verificationMethod,
    @required int paymentMethodId,
    }) async {
    
    final token = await _authenticationRepository.getToken();
    var formData = new FormData.fromMap({
      "item_id": itemId,
      "recipient_id": recipientId,
      "shipping_code": shippingCode,
      "ongkir": ongkir,
      "note": note,
      "verification_method": verificationMethod,
      "payment_method_id": paymentMethodId,
    });

    debugPrint("formdata ${formData.fields}");

   var response = await dio.post(
      "$_baseUrl/order/store",
      data: formData,
      options: Options(
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json',
          'ADS-Key':_adsKey
        },
        validateStatus: (status) => true
      ),
    );

    // debugPrint("status code ${response.statusCode}");
    debugPrint("response $response");

    if (response.statusCode == 200) {
      final statusCode = response.data['status'];
      final message = response.data['message'] ?? 'Terjadi Kesalahan';

      return GeneralOrderResponse.fromJson(response.data);
    } else {
      debugPrint("myresponse ${response}");
      throw GeneralException(response.data.toString());
    }
  }

  Future<GeneralOrderResponse> addOrderNoAuth({
    @required String slug,
    @required String name,
    @required String phoneNumber,
    @required String email,
    @required String address,
    @required int subdistrictId,
    @required String verificationMethod,
    @required int paymentMethodId,
    @required List<NewCart> carts,
     List<NoteTemp> notes,
     List<OngkirTemp> ongkirs,
     List<ShippingCodeTemp> shppingCodes
    }) async {    


      debugPrint("CHECK NOTES" + notes.toString());
      debugPrint("CHECK ONGKIRS" + ongkirs.toString());
      debugPrint("CHECK SHIPPINGCODES" + shppingCodes.toString());
      debugPrint("CHECK PRODUCTS" + carts[0].product.map((e) => ProductAddOrderNoAuth(productId: e.id, isVariant: e.variantSelected != null ? 1 : 0  , variantId: e.variantSelected != null ? e.variantSelected.id : 0,quantity: e.quantity)).toList().toString());

    List<CartTempAddOrderNoAuth> cartsTemp = [];
    debugPrint("COK 1");
    for (int i = 0; i < carts.length; i++) {
        cartsTemp.add(CartTempAddOrderNoAuth(
          supplierId: carts[i].sellerId, 
          ongkir: ongkirs[i].ongkir, 
          shippingCode: shppingCodes[i].shippingCode, 
          note: notes[i].note, 
          products: carts[i].product.map((e) => ProductAddOrderNoAuth(productId: e.id, isVariant: e.variantSelected != null ? 1 : 0, variantId: e.variantSelected != null ? e.variantSelected.id : 0 , quantity: e.quantity)).toList()));
    }
    debugPrint("COK 2");
    Map<String, dynamic> body = {
      "slug": slug,
      "name": name,
      "phonenumber": phoneNumber,
      "email": email,
      "address": address,
      "subdistrict_id": subdistrictId,
      "verification_method": verificationMethod,
      "payment_method_id": paymentMethodId,
      "carts": cartsTemp,
    };
    debugPrint("COK 3");
    final response = await _provider
        .post("/order/noauth/store", body: jsonEncode(body), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      'ADS-Key':_adsKey
    });
    debugPrint("COK 4");
    return GeneralOrderResponse.fromJson(response);
  }

  Future<PaymentMethodResponse> fetchPaymentMethod() async {
    final token = await _authenticationRepository.getToken();

    final response = await _provider.get("/payment/show/method", headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: 'application/json',
      'ADS-Key':_adsKey
    });
    return PaymentMethodResponse.fromJson(response);
  }

  Future<GeneralOrderResponse> changePaymentMethod({
    @required int paymentId,
    @required int paymentMethodId,
  }) async {
    var formData = new FormData.fromMap({
      "payment_method_id": paymentMethodId,
    });
    final token = await _authenticationRepository.getToken();
    var response = await dio.post(
      "$_baseUrl/payment/change/$paymentId",
      data: formData,
      options: Options(
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json',
          'ADS-Key':_adsKey
        },
        validateStatus: (status) => true
      ),
    );

    // debugPrint("status code ${response.statusCode}");
    debugPrint("response $response");

    if (response.statusCode == 200) {
      final statusCode = response.data['status'];
      final message = response.data['message'] ?? 'Terjadi Kesalahan';

      return GeneralOrderResponse.fromJson(response.data);
    } else {
      debugPrint("myresponse ${response}");
      throw GeneralException(response.data.toString());
    }
    
  }

  Future<GeneralResponse> cancelOrder({@required int paymentId}) async {
    final token = await _authenticationRepository.getToken();
    final response =
        await _provider.post("/order/$paymentId/cancel-order", headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: 'application/json',
      'ADS-Key':_adsKey
    });
    return GeneralResponse.fromJson(response);
  }

  Future<TrackingOrderResponse> fetchTrackingOrder(
      {@required int orderId}) async {
    final token = await _authenticationRepository.getToken();
    final response = await _provider.get("/order/$orderId/logs", headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: 'application/json',
      'ADS-Key': _adsKey
    });
    return TrackingOrderResponse.fromJson(response);
  }

  //======================================================================
  //======================================================================
  //======================================================================
  //======================================================================
  //======================================================================
  //======================================================================
  //======================================================================

  Future<CheckoutResponse> getPaymentOrder({@required orderId}) async {
    final token = await _authenticationRepository.getToken();
    final response =
        await _provider.get("/order/get/$orderId", headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: 'application/json',
      'ADS-Key':_adsKey
    });
    return CheckoutResponse.fromJson(response);
  }

  
}
