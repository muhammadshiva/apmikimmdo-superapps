part of 'fetch_wallet_detail_cubit.dart';

abstract class FetchWalletDetailState extends Equatable {
  const FetchWalletDetailState();

  @override
  List<Object> get props => [];
}

class FetchWalletDetailInitial extends FetchWalletDetailState {}

class FetchWalletDetailLoading extends FetchWalletDetailState {}

class FetchWalletDetailSuccess extends FetchWalletDetailState {
  FetchWalletDetailSuccess(this.wallet);

  final WalletHistoryDetailNonWithdrawal wallet;

  @override
  List<Object> get props => [wallet];
}

class FetchWalletDetailFailure extends FetchWalletDetailState {
  final ErrorType type;
  final String message;

  FetchWalletDetailFailure({this.type = ErrorType.general, this.message});

  FetchWalletDetailFailure.network(String message)
      : this(type: ErrorType.network, message: message);

  FetchWalletDetailFailure.general(String message)
      : this(type: ErrorType.general, message: message);

  @override
  List<Object> get props => [type, message];
}
