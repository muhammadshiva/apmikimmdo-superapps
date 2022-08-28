import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/new_models/tracking.dart';
import 'package:marketplace/data/repositories/order_repository.dart';
import 'package:meta/meta.dart';

part 'fetch_tracking_order_state.dart';

class FetchTrackingOrderCubit extends Cubit<FetchTrackingOrderState> {
  FetchTrackingOrderCubit() : super(FetchTrackingOrderInitial());

  final OrderRepository _repository = OrderRepository();

  Future<void> fetchTracking({@required int orderId}) async {
    try {
      debugPrint("id $orderId");
      final response = await _repository.fetchTrackingOrder(orderId: orderId);
      emit(FetchTrackingOrderSuccess(response.data));
    } catch (error) {
      if (error is NetworkException) {
        emit(FetchTrackingOrderFailure.network(error.toString()));
        return;
      }
      emit(FetchTrackingOrderFailure.general(error.toString()));
    }
  }
}
