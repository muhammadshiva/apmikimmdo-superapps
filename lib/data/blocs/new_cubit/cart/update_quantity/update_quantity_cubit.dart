import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/repositories.dart';

part 'update_quantity_state.dart';

class UpdateQuantityCubit extends Cubit<UpdateQuantityState> {
  UpdateQuantityCubit() : super(UpdateQuantityInitial());

  CartRepository _cartRepository = CartRepository();

  Future<void> updateQuantity({
    @required List<int> cartId,
    @required List<int> quantity,
  }) async {
    emit(UpdateQuantityLoading());
    try {
      await _cartRepository.updateQuantity(cartId: cartId, quantity: quantity);
      emit(UpdateQuantitySuccess());
    } catch (error) {
      if (error is NetworkException) {
        emit(UpdateQuantityFailure.network(error.toString()));
        return;
      }
      emit(UpdateQuantityFailure.general(error.toString()));
    }
  }
}
