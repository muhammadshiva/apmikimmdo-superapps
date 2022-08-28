import 'dart:convert';
import 'dart:io';

import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/repositories.dart';
import 'package:meta/meta.dart';
import 'package:marketplace/utils/constants.dart' as AppConst;

class ShippingRepository {
  final ApiProvider _provider = ApiProvider();
  final AuthenticationRepository _authenticationRepository =
      AuthenticationRepository();
  final String _adsKey = AppConst.API_ADS_KEY;

  Future<FetchShippingOptionsResponse> fetchShippingOptions({
    @required int totalWeight,
    @required int subdistrictId,
    @required int supplierId,
    @required int productId,
  }) async {
    final Map<String, dynamic> body = {
      "total_weight": totalWeight,
      "subdistrict_id": subdistrictId,
      "supplier_id": supplierId,
      "product_id": productId,
    };

    final response = await _provider.post(
      "/order/shipping/cost",
      body: jsonEncode(body),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'ADS-Key': _adsKey
      },
    );
    return FetchShippingOptionsResponse.fromJson(response);
  }
}
