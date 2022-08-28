part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class SignedIn extends AuthenticationEvent {
  final String token;

  const SignedIn({@required this.token});

  @override
  List<Object> get props => [token];
}

class OtpRequested extends AuthenticationEvent {
  final int otpTimeout;
  final String phoneNumber;

  OtpRequested({@required this.phoneNumber, @required this.otpTimeout});

  @override
  List<Object> get props => [phoneNumber, otpTimeout];
}

class SetUserData extends AuthenticationEvent {
  final User user;

  SetUserData({@required this.user});

  @override
  List<Object> get props => [user];
}

class SignedOut extends AuthenticationEvent {}
