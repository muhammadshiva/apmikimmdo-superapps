import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/new_repositories/join_user_repository.dart';


part 'fetch_products_reseller_shop_state.dart';

class FetchProductsResellerShopCubit extends Cubit<FetchProductsResellerShopState> {
  FetchProductsResellerShopCubit() : super(FetchProductsResellerShopInitial());

  final JoinUserRepository _resellerShopRepository = JoinUserRepository();

  Future<void> fetchProductsList({
    @required String nameSlugReseller,
    @required int subdistrictId
  }) async {
    emit(FetchProductsResellerShopLoading());
    try {
      final response = await _resellerShopRepository.getProductListResellerShop(nameSlugReseller: nameSlugReseller,subdistrictId:subdistrictId );
      emit(FetchProductsResellerShopSuccess(resellerProducts : response.data));
    } catch (error) {
      if (error is NetworkException) {
        emit(FetchProductsResellerShopFailure.network(error.toString()));
        return;
      }
      emit(FetchProductsResellerShopFailure.general(error.toString()));
    }
  }

  Future<void> fetchProductsListBySubdistrict({
    @required int subdistrictId
  }) async {
    emit(FetchProductsResellerShopLoading());
    try {
      final response = await _resellerShopRepository.getProductListBySubdistrict(subdistrictId: subdistrictId);
      emit(FetchProductsResellerShopSuccess(resellerProducts : response.data));
    } catch (error) {
     if (error is NetworkException) {
        emit(FetchProductsResellerShopFailure.network(error.toString()));
        return;
      }
      emit(FetchProductsResellerShopFailure.general(error.toString()));
    }
  }

  

}
