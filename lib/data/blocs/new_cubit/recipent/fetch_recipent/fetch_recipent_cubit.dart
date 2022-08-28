import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/repositories.dart';

part 'fetch_recipent_state.dart';

class FetchRecipentCubit extends Cubit<FetchRecipentState> {
  FetchRecipentCubit() : super(FetchRecipentInitial());

  final RecipentRepository _recipentRepository = RecipentRepository();

  Future<void> fetchRecipents() async {
    emit(FetchRecipentLoading());
    try {
      final response = await _recipentRepository.getRecipents();
      emit(FetchRecipentSuccess(response.data));
    } catch (error) {
      // if (error is NetworkException) {
      //   emit(FetchRecipentFailure.network(error.toString()));
      //   return;
      // }
      emit(FetchRecipentFailure.general(error.toString()));
    }
  }

}
