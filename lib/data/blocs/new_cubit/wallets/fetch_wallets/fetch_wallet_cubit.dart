import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/new_repositories/wallet_repository.dart';

part 'fetch_wallet_state.dart';

class FetchWalletCubit extends Cubit<FetchWalletState> {
  FetchWalletCubit() : super(FetchWalletInitial());

  final WalletRepository _walletRepository = WalletRepository();

  Future<void> fetchWalletHistory() async {
    emit(FetchWalletLoading());
    try {
      final response = await _walletRepository.getWalletHistoryList();
      emit(FetchWalletSuccess(response.data));
    } catch (error) {
      if (error is NetworkException) {
        emit(FetchWalletFailure.network(error.toString()));
        return;
      }
      emit(FetchWalletFailure.general(error.toString()));
    }
  }
}
