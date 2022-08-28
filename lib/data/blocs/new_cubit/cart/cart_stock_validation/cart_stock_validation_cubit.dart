import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/repositories/repositories.dart';

part 'cart_stock_validation_state.dart';

class CartStockValidationCubit extends Cubit<CartStockValidationState> {
  CartStockValidationCubit() : super(CartStockValidationInitial());

  CartRepository _cartRepository = CartRepository();

  Future<void> cartStockValidation(
      {@required int sellerId,
      @required List<int> productId,
      @required List<int> quantity}) async {
    emit(CartStockValidationLoading());
    try {
      await _cartRepository.cartStockValidation(
          sellerId: sellerId, productId: productId, quantity: quantity);
      emit(CartStockValidationSuccess());
    } catch (error) {
      if (error is NetworkException) {
        emit(CartStockValidationFailure.network(error.toString()));
        return;
      }
      emit(CartStockValidationFailure.general(error.toString()));
    }
  }
}
