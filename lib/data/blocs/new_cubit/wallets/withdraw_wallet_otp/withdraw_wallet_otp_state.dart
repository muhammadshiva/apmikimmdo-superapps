part of 'withdraw_wallet_otp_bloc.dart';

abstract class WithdrawWalletOtpState extends Equatable {
  const WithdrawWalletOtpState();
  
  @override
  List<Object> get props => [];
}

class WithdrawWalletOtpInitial extends WithdrawWalletOtpState {}

class WithdrawWalletOtpLoading extends WithdrawWalletOtpState {}

class WithdrawWalletOtpSuccess extends WithdrawWalletOtpState {}

class WithdrawWalletOtpFailure extends WithdrawWalletOtpState {
  final ErrorType type;
  final String message;

  WithdrawWalletOtpFailure({this.type = ErrorType.general, this.message});

  WithdrawWalletOtpFailure.network(String message)
      : this(type: ErrorType.network, message: message);

  WithdrawWalletOtpFailure.general(String message)
      : this(type: ErrorType.general, message: message);

  @override
  List<Object> get props => [type, message];
}

class WithdrawWalletResendOtpLoading extends WithdrawWalletOtpState {}

class WithdrawWalletResendOtpSuccess extends WithdrawWalletOtpState {}

class WithdrawWalletResendOtpFailure extends WithdrawWalletOtpState {
  final ErrorType type;
  final String message;

  WithdrawWalletResendOtpFailure({this.type = ErrorType.general, this.message});

  WithdrawWalletResendOtpFailure.network(String message)
      : this(type: ErrorType.network, message: message);

  WithdrawWalletResendOtpFailure.general(String message)
      : this(type: ErrorType.general, message: message);

  @override
  List<Object> get props => [type, message];
}