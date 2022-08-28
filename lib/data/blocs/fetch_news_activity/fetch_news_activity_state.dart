part of 'fetch_news_activity_cubit.dart';

abstract class FetchNewsActivityState extends Equatable {
  const FetchNewsActivityState();

  @override
  List<Object> get props => [];
}

class FetchNewsActivityInitial extends FetchNewsActivityState {}

class FetchNewsActivityLoading extends FetchNewsActivityState {}

class FetchNewsActivitySuccess extends FetchNewsActivityState {
  FetchNewsActivitySuccess(this.newsActivity);

  final List<NewsActivity> newsActivity;

  @override
  List<Object> get props => [newsActivity];
}

class FetchNewsActivityFailure extends FetchNewsActivityState {
  final ErrorType type;
  final String message;

  FetchNewsActivityFailure({this.type = ErrorType.general, this.message});

  FetchNewsActivityFailure.network(String message)
      : this(type: ErrorType.network, message: message);

  FetchNewsActivityFailure.general(String message)
      : this(type: ErrorType.general, message: message);

  @override
  List<Object> get props => [type, message];
}
