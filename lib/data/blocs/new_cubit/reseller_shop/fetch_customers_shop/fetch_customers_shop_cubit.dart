import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/repositories.dart';

part 'fetch_customers_shop_state.dart';

class FetchCustomersShopCubit extends Cubit<FetchCustomersShopState> {
  FetchCustomersShopCubit() : super(FetchCustomersShopInitial());

  final JoinUserRepository _shopRepo = JoinUserRepository();

  Future<void> fetchCustomers() async {
    emit(FetchCustomersShopLoading());
    try {
      final response = await _shopRepo.getCustomersList();
      emit(FetchCustomersShopSuccess(response.data));
    } catch (error) {
      emit(FetchCustomersShopFailure(error.toString()));
    }
  }

}
