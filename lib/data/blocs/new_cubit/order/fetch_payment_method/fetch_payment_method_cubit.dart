import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/order_repository.dart';
import 'package:marketplace/data/repositories/repositories.dart';

part 'fetch_payment_method_state.dart';

class FetchPaymentMethodCubit extends Cubit<FetchPaymentMethodState> {
  FetchPaymentMethodCubit() : super(FetchPaymentMethodInitial());

  final OrderRepository _orderRepo = OrderRepository();

  Future<void> load() async {
    emit(FetchPaymentMethodLoading());
    try {
      final response = await _orderRepo.fetchPaymentMethod();
      emit(FetchPaymentMethodSuccess(response.data));
    } catch (error) {
      emit(FetchPaymentMethodFailure(error.toString()));
    }
  }
}
