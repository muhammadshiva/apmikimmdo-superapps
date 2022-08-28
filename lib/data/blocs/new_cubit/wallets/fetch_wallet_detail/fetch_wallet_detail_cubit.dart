import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/new_repositories/wallet_repository.dart';

part 'fetch_wallet_detail_state.dart';

class FetchWalletDetailCubit extends Cubit<FetchWalletDetailState> {
  FetchWalletDetailCubit() : super(FetchWalletDetailInitial());

  final WalletRepository _walletRepository = WalletRepository();

  Future<void> fetchWalletDetail({@required int historyId}) async {
    emit(FetchWalletDetailLoading());
    try {
      final response =
          await _walletRepository.fetchHistoryDetail(historyId: historyId);
      emit(FetchWalletDetailSuccess(response.data));
    } catch (error) {
      if (error is NetworkException) {
        emit(FetchWalletDetailFailure.network(error.toString()));
        return;
      }
      emit(FetchWalletDetailFailure.general(error.toString()));
    }
  }
}
