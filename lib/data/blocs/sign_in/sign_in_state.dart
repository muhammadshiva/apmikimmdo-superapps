part of 'sign_in_bloc.dart';

abstract class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignInOtpRequested extends SignInState {
  final String phoneNumber;
  final int otpTimeOut;

  SignInOtpRequested({@required this.phoneNumber, @required this.otpTimeOut});

  @override
  List<Object> get props => [phoneNumber, otpTimeOut];
}

class SignInFailure extends SignInState {
  final String error;

  const SignInFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'LoginFailure { error: $error }';
}
