import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/order_repository.dart';

part 'add_order_state.dart';

class AddOrderCubit extends Cubit<AddOrderState> {
  AddOrderCubit() : super(AddOrderInitial());

  final OrderRepository _orderRepo = OrderRepository();

  Future<void> addOrder({
    @required List<int> itemId,
    @required int recipientId,
    @required List<String> shippingCode,
    @required List<int> ongkir,
    @required List<String> note,
    @required String verificationMethod,
    @required int paymentMethodId,
  }) async {
    emit(AddOrderLoading());
    try {
      final response = await _orderRepo.addOrder(
          itemId: itemId,
          recipientId: recipientId,
          shippingCode: shippingCode,
          ongkir: ongkir,
          note: note,
          verificationMethod: verificationMethod,
          paymentMethodId: paymentMethodId);
      emit(AddOrderSuccess(response.data));
    } catch (error) {
      // if (error is NetworkException) {
      //   emit(AddOrderFailure.network(error.toString()));
      //   return;
      // }
      emit(AddOrderFailure(error.toString()));
    }
  }

  Future<void> addOrderNoAuth({
   @required String slug,
    @required String name,
    @required String phoneNumber,
    @required String email,
    @required String address,
    @required int subdistrictId,
    @required String verificationMethod,
    @required int paymentMethodId,
    @required List<NewCart> carts,
     List<NoteTemp> notes,
     List<OngkirTemp> ongkirs,
     List<ShippingCodeTemp> shippingCodes
  }) async {
    emit(AddOrderLoading());
    try {
      final response = await _orderRepo.addOrderNoAuth(
        slug: slug, 
        name: name, 
        phoneNumber: phoneNumber, 
        email: email, 
        address: address, 
        subdistrictId: subdistrictId, 
        verificationMethod: verificationMethod, 
        paymentMethodId: paymentMethodId, 
        carts: carts,
        notes: notes,
        ongkirs: ongkirs,
        shppingCodes: shippingCodes
      );
      emit(AddOrderSuccess(response.data));
    } catch (error) {
      // if (error is NetworkException) {
      //   emit(AddOrderFailure.network(error.toString()));
      //   return;
      // }
      emit(AddOrderFailure(error.toString()));
    }
  }
}
