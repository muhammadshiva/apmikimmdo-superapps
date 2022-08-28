import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/repositories.dart';

part 'fetch_user_state.dart';

class FetchUserCubit extends Cubit<FetchUserState> {
  FetchUserCubit() : super(FetchUserInitial());

  final UserRepository _userRepository = UserRepository();

  void load() async {
    emit(FetchUserLoading());
    try {
      final response = await _userRepository.fetchUser();
      emit(FetchUserSuccess(user: response));
    } catch (error) {
      if (error is NetworkException) {
        emit(FetchUserFailure.network(error.toString()));
        return;
      }
      emit(FetchUserFailure.general(error.toString()));
    }
  }
}
