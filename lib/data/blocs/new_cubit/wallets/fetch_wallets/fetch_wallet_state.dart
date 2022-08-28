part of 'fetch_wallet_cubit.dart';

abstract class FetchWalletState extends Equatable {
  const FetchWalletState();

  @override
  List<Object> get props => [];
}

class FetchWalletInitial extends FetchWalletState {}

class FetchWalletLoading extends FetchWalletState {}

class FetchWalletSuccess extends FetchWalletState {
  FetchWalletSuccess(this.wallets);

  final List<WalletHistory> wallets;

  @override
  List<Object> get props => [wallets];
}

class FetchWalletFailure extends FetchWalletState {
  final ErrorType type;
  final String message;

  FetchWalletFailure({this.type = ErrorType.general, this.message});

  FetchWalletFailure.network(String message)
      : this(type: ErrorType.network, message: message);

  FetchWalletFailure.general(String message)
      : this(type: ErrorType.general, message: message);

  @override
  List<Object> get props => [type, message];
}
