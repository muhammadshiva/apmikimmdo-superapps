part of 'search_news_activity_cubit.dart';

abstract class SearchNewsActivityState {
  const SearchNewsActivityState();

  @override
  List<Object> get props => [];
}

class SearchNewsActivityInitial extends SearchNewsActivityState {}

class SearchNewsActivityLoading extends SearchNewsActivityState {}

class SearchNewsActivitySuccess extends SearchNewsActivityState {
  SearchNewsActivitySuccess(this.result);

  final List<NewsActivity> result;

  @override
  List<Object> get props => [result];
}

class SearchNewsActivityFailure extends SearchNewsActivityState {
  final ErrorType type;
  final String message;

  SearchNewsActivityFailure({this.type = ErrorType.general, this.message});

  SearchNewsActivityFailure.network(String message)
      : this(type: ErrorType.network, message: message);

  SearchNewsActivityFailure.general(String message)
      : this(type: ErrorType.general, message: message);

  @override
  List<Object> get props => [type, message];
}
