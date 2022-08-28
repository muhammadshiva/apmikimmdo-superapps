part of 'edit_user_profile_cubit.dart';

abstract class EditUserProfileState extends Equatable {
  const EditUserProfileState();

  @override
  List<Object> get props => [];
}

class EditUserProfileInitial extends EditUserProfileState {}

class EditUserProfileLoading extends EditUserProfileState {}

class EditUserProfileSuccess extends EditUserProfileState {}

class EditUserProfileFailure extends EditUserProfileState {
  EditUserProfileFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}