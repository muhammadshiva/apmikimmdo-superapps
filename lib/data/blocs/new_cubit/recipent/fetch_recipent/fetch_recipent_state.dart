part of 'fetch_recipent_cubit.dart';

abstract class FetchRecipentState extends Equatable {
  const FetchRecipentState();

  @override
  List<Object> get props => [];
}

class FetchRecipentInitial extends FetchRecipentState {}

class FetchRecipentLoading extends FetchRecipentState {}

class FetchRecipentSuccess extends FetchRecipentState {
  final List<Recipent> recipent;

  FetchRecipentSuccess(this.recipent);

  List<Object> get props => [recipent];
}

class FetchRecipentFailure extends FetchRecipentState {
  final ErrorType type;
  final String message;

  FetchRecipentFailure({this.type = ErrorType.general, this.message});

  FetchRecipentFailure.network(String message)
      : this(type: ErrorType.network, message: message);

  FetchRecipentFailure.general(String message)
      : this(type: ErrorType.general, message: message);

  @override
  List<Object> get props => [type, message];
}
