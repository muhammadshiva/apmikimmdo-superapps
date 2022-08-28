part of 'tag_news_activity_cubit.dart';

abstract class FetchTagNewsActivityState extends Equatable {
  const FetchTagNewsActivityState();

  @override
  List<Object> get props => [];
}

class FetchTagNewsActivityInitial extends FetchTagNewsActivityState {}

class FetchTagNewsActivityLoading extends FetchTagNewsActivityState {}

class FetchTagNewsActivitySuccess extends FetchTagNewsActivityState {
  FetchTagNewsActivitySuccess(this.tagNewsActivity);

  final List<TagNewsActivity> tagNewsActivity;

  @override
  List<Object> get props => [tagNewsActivity];
}

class FetchTagNewsActivityFailure extends FetchTagNewsActivityState {
  final ErrorType type;
  final String message;

  FetchTagNewsActivityFailure({this.type = ErrorType.general, this.message});

  FetchTagNewsActivityFailure.network(String message)
      : this(type: ErrorType.network, message: message);

  FetchTagNewsActivityFailure.general(String message)
      : this(type: ErrorType.general, message: message);

  @override
  List<Object> get props => [type, message];
}
