import 'package:bloc/bloc.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/new_models/tracking.dart';
import 'package:marketplace/data/repositories/order_repository.dart';
import 'package:meta/meta.dart';

part 'fetch_transaction_tracking_state.dart';

class FetchTransactionTrackingCubit extends Cubit<FetchTransactionTrackingState> {
  FetchTransactionTrackingCubit() : super(FetchTransactionTrackingInitial());

  final OrderRepository _repo = OrderRepository();

  Future<void> getTrackingOrder({@required int orderId}) async {
    emit(FetchTransactionTrackingLoading());
    try {
      final response =
      await _repo.fetchTrackingOrder(orderId: orderId);
      emit(FetchTransactionTrackingSuccess(response.data));
    } catch (error) {
      if (error is NetworkException) {
        emit(FetchTransactionTrackingFailure.network(error.toString()));
        return;
      }
      emit(FetchTransactionTrackingFailure.general(error.toString()));
    }
  }

}
