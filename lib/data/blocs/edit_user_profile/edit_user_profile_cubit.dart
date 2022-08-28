import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/repositories/repositories.dart';

part 'edit_user_profile_state.dart';

class EditUserProfileCubit extends Cubit<EditUserProfileState> {
  final UserDataCubit userDataCubit;
  EditUserProfileCubit({@required this.userDataCubit})
      : super(EditUserProfileInitial());

  UserRepository _userRepository = UserRepository();

  Future<void> editProfile({@required String name}) async {
    emit(EditUserProfileLoading());
    try {
      await Future.delayed(Duration(milliseconds: 300));
      await _userRepository.editProfile(name: name);
      await userDataCubit.updateUser();
      emit(EditUserProfileSuccess());
    } catch (error) {
      emit(EditUserProfileFailure(error.toString()));
    }
  }
}
