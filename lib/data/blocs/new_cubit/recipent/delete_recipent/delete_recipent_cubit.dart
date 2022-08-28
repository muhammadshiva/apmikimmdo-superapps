import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:marketplace/data/repositories/repositories.dart';

part 'delete_recipent_state.dart';

class DeleteRecipentCubit extends Cubit<DeleteRecipentState> {
  DeleteRecipentCubit() : super(DeleteRecipentInitial());

  final RecipentRepository _recipentRepository = RecipentRepository();

  Future<void> deleteRecipent({@required int recipentId}) async {
    emit(DeleteRecipentLoading());
    try {
      await Future.delayed(Duration(milliseconds: 500));
      await _recipentRepository.deleteRecipent(recipentId: recipentId);
      emit(DeleteRecipentSuccess());
    } catch (error) {
      emit(DeleteRecipentFailure(error.toString()));
    }
  }
}
