part of 'otp_bloc.dart';

abstract class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object> get props => [];
}

class OtpSubmited extends OtpEvent {
  const OtpSubmited({@required this.otp, @required this.phoneNumber});

  final String otp;
  final String phoneNumber;

  @override
  List<Object> get props => [otp, phoneNumber];
}

class OtpRetry extends OtpEvent {
  const OtpRetry({@required this.phoneNumber});

  final String phoneNumber;

  @override
  List<Object> get props => [phoneNumber];
}

class OtpTimedOut extends OtpEvent {}
