part of 'direct_sign_in_cubit.dart';

abstract class DirectSignInState extends Equatable {
  const DirectSignInState();

  @override
  List<Object> get props => [];
}

class DirectSignInInitial extends DirectSignInState {}

class DirectSignInLoading extends DirectSignInState {}

class DirectSignInSuccess extends DirectSignInState {
  // DirectSignInSuccess(this.data);

  // final Type data;

  // @override
  // List<Object> get props => [data];
}

class DirectSignInFailure extends DirectSignInState {
  DirectSignInFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
