import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/repositories.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  final ProductsRepository _productsRepository = ProductsRepository();

  Future<void> search({@required String keyword}) async {
    emit(SearchLoading());
    try {
      final response = await _productsRepository.search(keyword: keyword);
      emit(SearchSuccess(response.data));
    } catch (error) {
      if (error is NetworkException) {
        emit(SearchFailure.network(error.toString()));
        return;
      }
      emit(SearchFailure.general(error.toString()));
    }
  }

  // Future<void> searchProductSellerWeb({@required String keyword,@required int sellerId}) async {
  //   emit(SearchLoading());
  //   try {
  //     final response = await _productsRepository.searchProductSellerWeb(keyword: keyword, sellerId: sellerId);
  //     emit(SearchSuccess(response.data));
  //   } catch (error) {
  //     if (error is NetworkException) {
  //       emit(SearchFailure.network(error.toString()));
  //       return;
  //     }
  //     emit(SearchFailure.general(error.toString()));
  //   }
  // }

}
