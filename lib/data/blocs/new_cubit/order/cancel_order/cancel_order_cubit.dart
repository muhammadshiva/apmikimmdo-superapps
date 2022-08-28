import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/data/repositories/order_repository.dart';

part 'cancel_order_state.dart';

class CancelOrderCubit extends Cubit<CancelOrderState> {
  CancelOrderCubit() : super(CancelOrderInitial());

  final OrderRepository _orderRepository = new OrderRepository();

  Future<void> cancelOrder({@required int paymentId}) async {
    emit(CancelOrderLoading());
    try {
      await _orderRepository.cancelOrder(paymentId: paymentId);
      emit(CancelOrderSuccess());
    } catch (error) {
      emit(CancelOrderFailure(message: error.toString()));
    }
  }
}
