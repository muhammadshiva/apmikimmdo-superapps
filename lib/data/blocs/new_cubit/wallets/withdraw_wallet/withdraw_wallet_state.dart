part of 'withdraw_wallet_cubit.dart';

abstract class WithdrawWalletState extends Equatable {
  const WithdrawWalletState();

  @override
  List<Object> get props => [];
}

class WithdrawWalletInitial extends WithdrawWalletState {}

class WithdrawWalletLoading extends WithdrawWalletState {}

class WithdrawWalletSuccess extends WithdrawWalletState {
  WithdrawWalletSuccess(this.data);

  final WalletWithdrawResponseData data;

  @override
  List<Object> get props => [data];
}

class WithdrawWalletFailure extends WithdrawWalletState {
  final ErrorType type;
  final String message;

  WithdrawWalletFailure({this.type = ErrorType.general, this.message});

  WithdrawWalletFailure.network(String message)
      : this(type: ErrorType.network, message: message);

  WithdrawWalletFailure.general(String message)
      : this(type: ErrorType.general, message: message);

  @override
  List<Object> get props => [type, message];
}
