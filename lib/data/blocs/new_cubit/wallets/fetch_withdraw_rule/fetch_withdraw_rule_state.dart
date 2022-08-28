part of 'fetch_withdraw_rule_cubit.dart';

abstract class FetchWithdrawRuleState extends Equatable {
  const FetchWithdrawRuleState();

  @override
  List<Object> get props => [];
}

class FetchWithdrawRuleInitial extends FetchWithdrawRuleState {}

class FetchWithdrawRuleLoading extends FetchWithdrawRuleState {}

class FetchWithdrawRuleSuccess extends FetchWithdrawRuleState {
  FetchWithdrawRuleSuccess(this.ruleWithdraw);

  final List<WalletWithdrawRule> ruleWithdraw;

  @override
  List<Object> get props => [ruleWithdraw];
}

class FetchWithdrawRuleFailure extends FetchWithdrawRuleState {
  final ErrorType type;
  final String message;

  FetchWithdrawRuleFailure({this.type = ErrorType.general, this.message});

  FetchWithdrawRuleFailure.network(String message)
      : this(type: ErrorType.network, message: message);

  FetchWithdrawRuleFailure.general(String message)
      : this(type: ErrorType.general, message: message);

  @override
  List<Object> get props => [type, message];
}

