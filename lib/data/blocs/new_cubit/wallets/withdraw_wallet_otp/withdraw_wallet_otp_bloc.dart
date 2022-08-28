import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/repositories/new_repositories/wallet_repository.dart';

part 'withdraw_wallet_otp_event.dart';
part 'withdraw_wallet_otp_state.dart';

class WithdrawWalletOtpBloc
    extends Bloc<WithdrawWalletOtpEvent, WithdrawWalletOtpState> {
  WithdrawWalletOtpBloc() : super(WithdrawWalletOtpInitial());

  final WalletRepository _walletRepository = WalletRepository();

  @override
  Stream<WithdrawWalletOtpState> mapEventToState(
      WithdrawWalletOtpEvent event) async* {
    if (event is WithdrawWalletOtpSubmitted) {
      yield WithdrawWalletOtpLoading();
      try {
        final response = await _walletRepository.withdrawWalletConfirmation(
            logId: event.logId, confirmationCode: event.confirmationCode);
        yield WithdrawWalletOtpSuccess();
      } catch (error) {
        if (error is NetworkException) {
          yield WithdrawWalletOtpFailure.network(error.toString());
          return;
        }
        yield WithdrawWalletOtpFailure.general(error.toString());
      }
    } else if (event is WithdrawWalletOtpResend) {
      yield WithdrawWalletResendOtpLoading();
      try {
        final response =
            await _walletRepository.withdrawWalletResendOTP(logId: event.logId);
        yield WithdrawWalletResendOtpSuccess();
      } catch (error) {
        if (error is NetworkException) {
          yield WithdrawWalletOtpFailure.network(error.toString());
          return;
        }
        yield WithdrawWalletOtpFailure.general(error.toString());
      }
    }
  }
}
