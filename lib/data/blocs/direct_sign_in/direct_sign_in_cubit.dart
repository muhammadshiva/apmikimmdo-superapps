import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/repositories/repositories.dart';

part 'direct_sign_in_state.dart';

class DirectSignInCubit extends Cubit<DirectSignInState> {
  DirectSignInCubit(this.userDataCubit) : super(DirectSignInInitial());

  final UserDataCubit userDataCubit;

  final AuthenticationRepository _authenticationRepo =
      AuthenticationRepository();

  Future<void> signInWithToken(String token) async {
    emit(DirectSignInLoading());
    try {
      await _authenticationRepo.persistToken(token);
      await userDataCubit.appStarted();
      emit(DirectSignInSuccess());
    } catch (error) {
      emit(DirectSignInFailure(error.toString()));
    }
  }

  Future<void> signInWithPhone(String phone) async {
    emit(DirectSignInLoading());
    try {
      final response =
          await _authenticationRepo.direct(phoneNumber: '62$phone');
      await _authenticationRepo.persistToken(response.token);
      await userDataCubit.appStarted();
      emit(DirectSignInSuccess());
    } catch (error) {
      emit(DirectSignInFailure(error.toString()));
    }
  }
}
