import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/repositories.dart';

part 'fetch_withdraw_rule_state.dart';

class FetchWithdrawRuleCubit extends Cubit<FetchWithdrawRuleState> {
  FetchWithdrawRuleCubit() : super(FetchWithdrawRuleInitial());

  final WalletRepository _walletRepository = WalletRepository();

  Future<void> fetchRuleWithdraw() async {
    emit(FetchWithdrawRuleLoading());
    try {
      final response = await _walletRepository.fetchWihtdrawRule();
      emit(FetchWithdrawRuleSuccess(response.data));
    } catch (error) {
      if (error is NetworkException) {
        emit(FetchWithdrawRuleFailure.network(error.toString()));
        return;
      }
      emit(FetchWithdrawRuleFailure.general(error.toString()));
    }
  }
}
