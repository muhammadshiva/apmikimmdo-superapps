part of 'user_data_cubit.dart';

class UserDataState extends Equatable {
  const UserDataState(
      {@required this.user,
      @required this.countCart});

  final User user;
  final int countCart;

  @override
  List<Object> get props => [user,countCart];
}

class UserDataInitial extends UserDataState {}

class UserDataFailure extends UserDataState {
  UserDataFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
