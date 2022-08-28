part of 'otp_bloc.dart';

abstract class OtpState extends Equatable {
  const OtpState();

  @override
  List<Object> get props => [];
}

class OtpInitial extends OtpState {}

class OtpLoading extends OtpState {}

class OtpSuccess extends OtpState {}

class OtpFailure extends OtpState {
  final String message;

  OtpFailure(this.message);

  @override
  List<Object> get props => [message];
}

class OtpRetryLoading extends OtpState {}

class OtpRetrySuccess extends OtpState {}

class OtpRetryFailure extends OtpState {
  final String message;

  OtpRetryFailure(this.message);

  @override
  List<Object> get props => [message];
}
