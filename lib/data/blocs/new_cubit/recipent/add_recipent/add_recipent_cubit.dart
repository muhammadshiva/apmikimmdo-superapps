import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/repositories.dart';

part 'add_recipent_state.dart';

class AddRecipentCubit extends Cubit<AddRecipentState> {
  AddRecipentCubit() : super(AddRecipentInitial());

  final RecipentRepository _recipentRepository = RecipentRepository();

  Future<void> addRecipent({
    @required String name,
    @required int phone,
    @required String address,
    @required String email,
    @required int subdistrictId,
    @required int postalCode,
    @required String note,
  }) async {
    emit(AddRecipentLoading());
    try {
      final response = await _recipentRepository.addRecipent(
          name: name,
          phone: phone,
          address: address,
          email: email,
          subdistrictId: subdistrictId,
          postalCode: postalCode,
          note: note);
      emit(AddRecipentSuccess(response.data));
    } catch (error) {
      // if (error is NetworkException) {
      //   emit(FetchRecipentFailure.network(error.toString()));
      //   return;
      // }
      emit(AddRecipentFailure.general(error.toString()));
    }
  }
}
