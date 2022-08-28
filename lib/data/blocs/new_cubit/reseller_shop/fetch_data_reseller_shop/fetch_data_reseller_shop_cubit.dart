import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:marketplace/data/models/models.dart';

import 'package:marketplace/data/repositories/repositories.dart';

part 'fetch_data_reseller_shop_state.dart';

class FetchDataResellerShopCubit extends Cubit<FetchDataResellerShopState> {
  FetchDataResellerShopCubit() : super(FetchDataResellerShopInitial());

  final JoinUserRepository _resellerShopRepository = JoinUserRepository();

  Future<void> fetchData({
    @required String nameSlugReseller
  }) async {
    emit(FetchDataResellerShopLoading());
    try {
      final response = await _resellerShopRepository.getDataResellerShop(nameSlugReseller: nameSlugReseller);
      emit(FetchDataResellerShopSuccess(reseller: response.data));
    } catch (error) {
      emit(FetchDataResellerShopFailure(error.toString()));
    }
  }

  Future<void> fetchListWarungBySubdistrictId({
    @required int subdistrictId,
    @required String keyword
  }) async {
    emit(FetchDataResellerShopLoading());
    try {
      final response = await _resellerShopRepository.getListWarungBySubdistrict(subdistrictId: subdistrictId,keyword: keyword);
      emit(FetchDataResellerShopSuccess(listWarung: response.data));
    } catch (error) {
      emit(FetchDataResellerShopFailure(error.toString()));
    }
  }

}
