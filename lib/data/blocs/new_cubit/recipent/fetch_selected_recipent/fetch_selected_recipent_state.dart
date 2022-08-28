part of 'fetch_selected_recipent_cubit.dart';

abstract class FetchSelectedRecipentState extends Equatable {
  const FetchSelectedRecipentState();

  @override
  List<Object> get props => [];
}

class FetchSelectedRecipentInitial extends FetchSelectedRecipentState {}

class FetchSelectedRecipentLoading extends FetchSelectedRecipentState {}

class FetchSelectedRecipentSuccess extends FetchSelectedRecipentState {
  final Recipent recipent;

  FetchSelectedRecipentSuccess(this.recipent);

  List<Object> get props => [recipent];
}

class FetchSelectedRecipentFailure extends FetchSelectedRecipentState {
  final ErrorType type;
  final String message;

  FetchSelectedRecipentFailure({this.type = ErrorType.general, this.message});

  FetchSelectedRecipentFailure.network(String message)
      : this(type: ErrorType.network, message: message);

  FetchSelectedRecipentFailure.general(String message)
      : this(type: ErrorType.general, message: message);

  @override
  List<Object> get props => [type, message];
}

