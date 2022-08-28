part of 'fetch_news_activity_by_tag_cubit.dart';

abstract class FetchNewsActivityByTagState extends Equatable {
  const FetchNewsActivityByTagState();

  @override
  List<Object> get props => [];
}

class FetchNewsActivityByTagInitial extends FetchNewsActivityByTagState {}

class FetchNewsActivityByTagLoading extends FetchNewsActivityByTagState {}

class FetchNewsActivityByTagSuccess extends FetchNewsActivityByTagState {
  FetchNewsActivityByTagSuccess(this.newsActivity);

  final List<NewsActivity> newsActivity;

  @override
  List<Object> get props => [newsActivity];
}

class FetchNewsActivityByTagFailure extends FetchNewsActivityByTagState {
  final ErrorType type;
  final String message;

  FetchNewsActivityByTagFailure({this.type = ErrorType.general, this.message});

  FetchNewsActivityByTagFailure.network(String message)
      : this(type: ErrorType.network, message: message);

  FetchNewsActivityByTagFailure.general(String message)
      : this(type: ErrorType.general, message: message);

  @override
  List<Object> get props => [type, message];
}
