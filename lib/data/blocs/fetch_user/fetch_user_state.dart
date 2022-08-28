part of 'fetch_user_cubit.dart';

abstract class FetchUserState extends Equatable {
  const FetchUserState();

  @override
  List<Object> get props => [];
}

class FetchUserInitial extends FetchUserState {}

class FetchUserLoading extends FetchUserState {}

class FetchUserSuccess extends FetchUserState {
  FetchUserSuccess({@required this.user});

  final UserResponse user;

  @override
  List<Object> get props => [user];
}

class FetchUserFailure extends FetchUserState {
  final ErrorType type;
  final String message;

  FetchUserFailure({this.type = ErrorType.general, this.message});

  FetchUserFailure.network(String message)
      : this(type: ErrorType.network, message: message);

  FetchUserFailure.general(String message)
      : this(type: ErrorType.general, message: message);

  @override
  List<Object> get props => [type, message];
}
