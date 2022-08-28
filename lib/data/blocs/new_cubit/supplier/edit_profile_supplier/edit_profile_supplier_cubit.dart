import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:marketplace/data/repositories/new_repositories/join_user_repository.dart';

part 'edit_profile_supplier_state.dart';

class EditProfileSupplierCubit extends Cubit<EditProfileSupplierState> {
  EditProfileSupplierCubit() : super(EditProfileSupplierInitial());

  final JoinUserRepository _resellerShopRepo = JoinUserRepository();

  Future<void> editProfileSupplier(
      {@required String nameShop,
      @required String phoneNumber,
      @required String logo,
      @required String subdistrictId,
      @required String address}) async {
    emit(EditProfileSupplierLoading());
    try {
      await _resellerShopRepo.updateProfileSupplier(
          name: nameShop,
          phoneNumber: phoneNumber,
          logo: logo,
          subdistrictId: subdistrictId,
          address: address);
      emit(EditProfileSupplierSuccess());
    } catch (error) {
      emit(EditProfileSupplierFailure(error.toString()));
    }
  }

}
