part of 'sign_in_bloc.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

class SignInButtonPressed extends SignInEvent {
  final String phoneNumber;

  const SignInButtonPressed({
    @required this.phoneNumber,
  });

  @override
  List<Object> get props => [phoneNumber];

  @override
  String toString() => 'SignInButtonPressed { username: $phoneNumber, }';
}

class OtpRecieved extends SignInEvent {
  final String phoneNumber;

  const OtpRecieved({
    @required this.phoneNumber,
  });

  @override
  List<Object> get props => [phoneNumber];
}
