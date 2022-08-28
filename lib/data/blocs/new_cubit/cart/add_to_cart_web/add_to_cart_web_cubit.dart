import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/repositories.dart';

part 'add_to_cart_web_state.dart';

class AddToCartWebCubit extends Cubit<AddToCartWebState> {
  final UserDataCubit userDataCubit;
  AddToCartWebCubit({@required this.userDataCubit}) : super(AddToCartWebInitial());

  CartRepository _cartRepository = CartRepository();

  Future<void> addCartWeb({
    @required int productId,
    @required int sellerId,
    @required int variantId,
    @required int isVariant
  }) async {
    emit(AddToCartWebLoading());
    try {
      await Future.delayed(Duration(milliseconds: 300));
      final response = await _cartRepository.addToCart(productId: productId, sellerId: sellerId,isVariant: isVariant, variantId: variantId);
       await userDataCubit.updateCountCart();
      emit(AddToCartWebSuccess(response.data));
    } catch (error) {
      emit(AddToCartWebFailure(error.toString()));
    }
  }
  

}
