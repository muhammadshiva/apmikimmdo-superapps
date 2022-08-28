part of 'sign_up_bloc.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {
  final String phoneNumber;
  final int otpTimeOut;

  SignUpSuccess({@required this.phoneNumber, @required this.otpTimeOut});

  @override
  List<Object> get props => [phoneNumber, otpTimeOut];
}

class SignUpFailure extends SignUpState {
  final String error;

  SignUpFailure({@required this.error});

  @override
  List<Object> get props => [error];
}
