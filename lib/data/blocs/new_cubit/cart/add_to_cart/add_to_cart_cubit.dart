import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/repositories/repositories.dart';

part 'add_to_cart_state.dart';

class AddToCartCubit extends Cubit<AddToCartState> {
  final UserDataCubit userDataCubit;
  AddToCartCubit({@required this.userDataCubit}) : super(AddToCartInitial());

  CartRepository _cartRepository = CartRepository();

  Future<void> addToCart({
    @required int productId,
    @required int sellerId,
    @required int variantId,
    @required int isVariant
  }) async {
    emit(AddToCartLoading());
    try {
      await Future.delayed(Duration(milliseconds: 300));
      await _cartRepository.addToCart(productId: productId, sellerId: sellerId, isVariant: isVariant, variantId: variantId);
      await userDataCubit.updateCountCart();
      emit(AddToCartSuccess());
    } catch (error) {
      emit(AddToCartFailure(error.toString()));
    }
  }

  Future<void> addToCartByList({
    @required List<int> productId,
    @required int sellerId,
    @required int variantId,
    @required int isVariant
  }) async {
    emit(AddToCartLoading());
    try {
      await Future.delayed(Duration(milliseconds: 300));
      productId.forEach((id) async {
        await _cartRepository.addToCart(productId: id, sellerId: sellerId, isVariant: isVariant, variantId: variantId);
      });
      await userDataCubit.updateCountCart();
      emit(AddToCartSuccess());
    } catch (error) {
      emit(AddToCartFailure(error.toString()));
    }
  }
}
