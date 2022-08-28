import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:marketplace/data/repositories/repositories.dart';

part 'remove_product_toko_saya_state.dart';

class RemoveProductTokoSayaCubit extends Cubit<RemoveProductTokoSayaState> {
  RemoveProductTokoSayaCubit() : super(RemoveProductTokoSayaInitial());

  final JoinUserRepository _shopRepository = JoinUserRepository();

  Future<void> deleteProduct({@required int productId}) async {
    emit(RemoveProductTokoSayaLoading());
    try {
      final response = await _shopRepository.removeProduct(productId: productId);
      emit(RemoveProductTokoSayaSuccess(response.message));
    } catch (error) {
      emit(RemoveProductTokoSayaFailure(error.toString()));
    }
  }

}
