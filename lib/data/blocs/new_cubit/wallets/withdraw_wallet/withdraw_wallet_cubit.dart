import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/repositories.dart';

part 'withdraw_wallet_state.dart';

class WithdrawWalletCubit extends Cubit<WithdrawWalletState> {
  WithdrawWalletCubit() : super(WithdrawWalletInitial());

  final WalletRepository _walletRepository = WalletRepository();

  Future<void> withDrawWallet({
    @required int amount,
    @required int paymentMethodId,
    @required int accountNumber,
    @required String accountName,
  }) async {
    emit(WithdrawWalletLoading());
    try {
      final response = await _walletRepository.withdrawWallet(
          amount: amount,
          paymentMethodId: paymentMethodId,
          accountNumber: accountNumber,
          accountName: accountName);
      emit(WithdrawWalletSuccess(response.data));
    } catch (error) {
      if (error is NetworkException) {
        emit(WithdrawWalletFailure.network(error.toString()));
        return;
      }
      emit(WithdrawWalletFailure.general(error.toString()));
    }
  }
}
