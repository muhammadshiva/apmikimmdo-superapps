import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/new_repositories/join_user_repository.dart';
import 'package:marketplace/ui/widgets/bs_feedback.dart';
import 'package:meta/meta.dart';

part 'register_supplier_reseller_state.dart';

class RegisterSupplierResellerCubit
    extends Cubit<RegisterSupplierResellerState> {
  RegisterSupplierResellerCubit() : super(RegisterSupplierResellerInitial());

  final _shopRepository = JoinUserRepository();

  Future<void> register(
      {@required UserType userType,
      String shopName,
      bool isAlsoRegisterSeller = true,
      @required String addressSeller,
      @required int subDistrictId}) async {
    emit(RegisterSupplierResellerLoading());
    try {
      await _shopRepository.createShop(
          userType: userType,
          shopName: shopName,
          isAlsoRegisterAsSeller: isAlsoRegisterSeller,
          addressSeller: addressSeller,
          subDistrictId: subDistrictId);
      emit(RegisterSupplierResellerSuccess());
    } catch (error) {
      if (error is NetworkException) {
        emit(RegisterSupplierResellerFailure.network(error.toString()));
        return;
      }
      debugPrint("error ${error.toString()}");
      emit(RegisterSupplierResellerFailure.general(error.toString()));
    }
  }
}
