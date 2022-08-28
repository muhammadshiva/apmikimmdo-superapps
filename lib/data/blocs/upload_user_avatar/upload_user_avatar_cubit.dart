import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/repositories/repositories.dart';

part 'upload_user_avatar_state.dart';

class UploadUserAvatarCubit extends Cubit<UploadUserAvatarState> {
  final UserDataCubit userDataCubit;
  UploadUserAvatarCubit({@required this.userDataCubit})
      : super(UploadUserAvatarInitial());

  UserRepository _userRepository = UserRepository();

  Future<void> uploadAvatar({@required String image}) async {
    emit(UploadUserAvatarLoading());
    try {
      await Future.delayed(Duration(milliseconds: 300));
      await _userRepository.uploadAvatar(image: image);
      await userDataCubit.updateUser();
      emit(UploadUserAvatarSuccess());
    } catch (error) {
      emit(UploadUserAvatarFailure(error.toString()));
    }
  }

  Future<void> uploadAvatarWeb(image) async {
    emit(UploadUserAvatarLoading());
    try {
      await Future.delayed(Duration(milliseconds: 300));
      await _userRepository.uploadAvatarWeb(image);
      await userDataCubit.updateUser();
      emit(UploadUserAvatarSuccess());
    } catch (error) {
      emit(UploadUserAvatarFailure(error.toString()));
    }
  }
}
