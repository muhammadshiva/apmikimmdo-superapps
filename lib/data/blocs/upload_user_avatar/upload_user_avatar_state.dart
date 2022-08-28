part of 'upload_user_avatar_cubit.dart';

abstract class UploadUserAvatarState extends Equatable {
  const UploadUserAvatarState();

  @override
  List<Object> get props => [];
}

class UploadUserAvatarInitial extends UploadUserAvatarState {}

class UploadUserAvatarLoading extends UploadUserAvatarState {}

class UploadUserAvatarSuccess extends UploadUserAvatarState {}

class UploadUserAvatarFailure extends UploadUserAvatarState {
  UploadUserAvatarFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}