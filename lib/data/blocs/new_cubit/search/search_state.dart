part of 'search_cubit.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  SearchSuccess(this.result);

  final List<Products> result;

  @override
  List<Object> get props => [result];
}

class SearchFailure extends SearchState {
  final ErrorType type;
  final String message;

  SearchFailure({this.type = ErrorType.general, this.message});

  SearchFailure.network(String message)
      : this(type: ErrorType.network, message: message);

  SearchFailure.general(String message)
      : this(type: ErrorType.general, message: message);

  @override
  List<Object> get props => [type, message];
}
