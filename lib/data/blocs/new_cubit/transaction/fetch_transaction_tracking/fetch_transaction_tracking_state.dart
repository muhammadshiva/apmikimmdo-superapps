part of 'fetch_transaction_tracking_cubit.dart';

@immutable
abstract class FetchTransactionTrackingState {}

class FetchTransactionTrackingInitial extends FetchTransactionTrackingState {}

class FetchTransactionTrackingLoading extends FetchTransactionTrackingState {}

class FetchTransactionTrackingSuccess extends FetchTransactionTrackingState {
  FetchTransactionTrackingSuccess(this.data);

  final TrackingOrder data;

  @override
  List<Object> get props => [data];
}

class FetchTransactionTrackingFailure extends FetchTransactionTrackingState {
  final ErrorType type;
  final String message;

  FetchTransactionTrackingFailure({this.type = ErrorType.general, this.message});

  FetchTransactionTrackingFailure.network(String message)
      : this(type: ErrorType.network, message: message);

  FetchTransactionTrackingFailure.general(String message)
      : this(type: ErrorType.general, message: message);

  @override
  List<Object> get props => [type, message];
}
