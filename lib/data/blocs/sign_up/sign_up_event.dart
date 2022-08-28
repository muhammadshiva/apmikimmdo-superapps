part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpButtonPressed extends SignUpEvent {
  final String name;
  final String phoneNumber;

  SignUpButtonPressed({@required this.name, @required this.phoneNumber});

  @override
  List<Object> get props => [name, phoneNumber];
}
