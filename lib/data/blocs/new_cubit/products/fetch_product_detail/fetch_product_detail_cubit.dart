import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/new_repositories/products_repository.dart';

import 'package:marketplace/data/repositories/repositories.dart';

part 'fetch_product_detail_state.dart';

class FetchProductDetailCubit extends Cubit<FetchProductDetailState> {
  FetchProductDetailCubit() : super(FetchProductDetailInitial());

  final ProductsRepository _productsRepository = ProductsRepository();
  final JoinUserRepository _warungRepo = JoinUserRepository();

  Future<void> load({@required int productId,int isWarung}) async {
    emit(FetchProductDetailLoading());
    await fetchProductDetail(productId: productId,isWarung: isWarung);
  }

  Future<void> reload({@required int productId,int isWarung}) async {
    await fetchProductDetail(productId: productId,isWarung: isWarung);
  }

  Future<void> fetchProductDetail({@required int productId,int isWarung}) async {
    try {
      final response =
          await _productsRepository.fetchProductDetail(productId: productId);
      emit(FetchProductDetailSuccess(response.data));
    } catch (error) {
      if (error is NetworkException) {
        emit(FetchProductDetailFailure.network(error.toString()));
        return;
      }
      emit(FetchProductDetailFailure.general(error.toString()));
    }
  }

  Future<void> fetchProductDetailVariant({@required String slugProduct,
        @required String slugVariant}) async {
    try {
      final response =
          await _productsRepository.fetchProductDetailVariant(slugProduct: slugProduct, slugVariant: slugVariant);
      emit(FetchProductDetailSuccess(response.data));
    } catch (error) {
      if (error is NetworkException) {
        emit(FetchProductDetailFailure.network(error.toString()));
        return;
      }
      emit(FetchProductDetailFailure.general(error.toString()));
    }
  }

  Future<void> fetchProductDetailWarung({@required String slugWarung,@required String slugProduct}) async {
    try {
      final response =
          await _warungRepo.fetchProductWarungDetail(slugWarung: slugWarung, slugProduct: slugProduct);
      emit(FetchProductDetailSuccess(response.data));
    } catch (error) {
      if (error is NetworkException) {
        emit(FetchProductDetailFailure.network(error.toString()));
        return;
      }
      emit(FetchProductDetailFailure.general(error.toString()));
    }
  }
}
