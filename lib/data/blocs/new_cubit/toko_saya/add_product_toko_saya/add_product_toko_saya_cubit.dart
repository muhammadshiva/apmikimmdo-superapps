import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:marketplace/data/repositories/repositories.dart';

part 'add_product_toko_saya_state.dart';

class AddProductTokoSayaCubit extends Cubit<AddProductTokoSayaState> {
  AddProductTokoSayaCubit() : super(AddProductTokoSayaInitial());

  final JoinUserRepository _shopRepository = JoinUserRepository();

  Future<void> addProduct({@required int productId}) async {
    emit(AddProductTokoSayaLoading());
    try {
      final response = await _shopRepository.addProduct(productId: productId);
      emit(AddProductTokoSayaSuccess(response.message));
    } catch (error) {
      emit(AddProductTokoSayaFailure(error.toString()));
    }
  }
  
}
