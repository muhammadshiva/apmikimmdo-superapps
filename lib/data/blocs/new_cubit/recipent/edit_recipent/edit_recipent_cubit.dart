import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/repositories.dart';

part 'edit_recipent_state.dart';

class EditRecipentCubit extends Cubit<EditRecipentState> {
  EditRecipentCubit() : super(EditRecipentInitial());

  final RecipentRepository _recipentRepository = RecipentRepository();

  Future<void> editMainAddress({@required int recipentId}) async {
    emit(EditRecipentLoading());
    try {
      final response = await _recipentRepository.updateMainAddress(recipentId: recipentId);
      emit(EditRecipentSuccess(response.data));
    } catch (error) {
      emit(EditRecipentFailure(error.toString()));
    }
  }

  Future<void> editRecipentAddress({
    @required int recipentId,
    @required String name,
    @required int phone,
    @required String address,
    @required String email,
    @required int subdistrictId,
    @required int postalCode,
    @required String note,
    @required int isMainAddress
  }) async {
    emit(EditRecipentLoading());
    try {
      final response = await _recipentRepository.updateAddressRecipent(recipentId: recipentId, name: name, phone: phone, address: address, email: email, subdistrictId: subdistrictId, postalCode: postalCode, note: note,isMainAddress: isMainAddress);
      emit(EditRecipentSuccess(response.data));
    } catch (error) {
      emit(EditRecipentFailure(error.toString()));
    }
  }
  
}
