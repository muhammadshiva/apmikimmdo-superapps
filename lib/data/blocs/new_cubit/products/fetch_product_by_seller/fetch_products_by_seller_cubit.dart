import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/repositories.dart';

part 'fetch_products_by_seller_state.dart';

class FetchProductsBySellerCubit extends Cubit<FetchProductsBySellerState> {
  FetchProductsBySellerCubit() : super(FetchProductsBySellerInitial());

  final ProductsRepository _productsRepository = ProductsRepository();

  // Future<void> load({@required int sellerId}) async {
  //   emit(FetchProductsBySellerLoading());
  //   try {
  //     final response =
  //         await _productsRepository.fetchProductsBySeller(sellerId: sellerId);
  //     emit(FetchProductsBySellerSuccess(response.data));
  //   } catch (error) {
  //     if (error is NetworkException) {
  //       emit(FetchProductsBySellerFailure.network(error.toString()));
  //       return;
  //     }
  //     emit(FetchProductsBySellerFailure.general(error.toString()));
  //   }
  // }

  // Future<void> fetchBestProductBySeller({@required int sellerId}) async {
  //   emit(FetchProductsBySellerLoading());
  //   try {
  //     final response =
  //         await _productsRepository.fetchBestProductBySeller(sellerId: sellerId);
  //     emit(FetchProductsBySellerSuccess(response.data));
  //   } catch (error) {
  //     if (error is NetworkException) {
  //       emit(FetchProductsBySellerFailure.network(error.toString()));
  //       return;
  //     }
  //     emit(FetchProductsBySellerFailure.general(error.toString()));
  //   }
  // }
  
}
