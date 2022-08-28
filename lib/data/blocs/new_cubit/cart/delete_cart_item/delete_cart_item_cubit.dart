import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/repositories/repositories.dart';

part 'delete_cart_item_state.dart';

class DeleteCartItemCubit extends Cubit<DeleteCartItemState> {
  final UserDataCubit userDataCubit;
  DeleteCartItemCubit({@required this.userDataCubit})
      : super(DeleteCartItemInitial());

  CartRepository _cartRepository = CartRepository();

  Future<void> deleteCartItem({
    @required List<int> listCartId,
  }) async {
    emit(DeleteCartItemLoading());
    try {
      final listCart = listCartId.join("&cart_id[]=");
      await _cartRepository.deleteCartItem(cartId: listCart);
      await userDataCubit.updateCountCart();
      emit(DeleteCartItemSuccess());
    } catch (error) {
      if (error is NetworkException) {
        emit(DeleteCartItemFailure.network(error.toString()));
        return;
      }
      emit(DeleteCartItemFailure.general(error.toString()));
    }
  }
}
