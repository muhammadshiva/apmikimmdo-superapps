part of 'withdraw_wallet_otp_bloc.dart';

abstract class WithdrawWalletOtpEvent extends Equatable {
  const WithdrawWalletOtpEvent();

  @override
  List<Object> get props => [];
}

class WithdrawWalletOtpSubmitted extends WithdrawWalletOtpEvent {
  const WithdrawWalletOtpSubmitted({@required this.logId, @required this.confirmationCode});

  final int logId;
  final int confirmationCode;

  @override
  List<Object> get props => [logId, confirmationCode];
}

class WithdrawWalletOtpResend extends WithdrawWalletOtpEvent {
  const WithdrawWalletOtpResend({@required this.logId});

  final int logId;

  @override
  List<Object> get props => [logId];
}

