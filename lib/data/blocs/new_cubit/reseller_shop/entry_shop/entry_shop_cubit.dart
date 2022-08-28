import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'package:marketplace/data/repositories/repositories.dart';

part 'entry_shop_state.dart';

class EntryShopCubit extends Cubit<EntryShopState> {
  EntryShopCubit() : super(EntryShopInitial());

  final JoinUserRepository _resellerShopRepo = JoinUserRepository();

  Future<void> editProfileShop(
      {@required String nameShop,
      @required String phoneNumber,
      @required String logo,
      @required String subdistrictId,
      @required String address}) async {
    emit(EntryShopLoading());
    try {
      await _resellerShopRepo.updateProfileShop(
          name: nameShop,
          phoneNumber: phoneNumber,
          logo: logo,
          subdistrictId: subdistrictId,
          address: address);
      emit(EntryShopSuccess());
    } catch (error) {
      emit(EntryShopFailure(error.toString()));
    }
  }
}
