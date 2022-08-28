part of 'fetch_tracking_order_cubit.dart';

abstract class FetchTrackingOrderState extends Equatable {
  const FetchTrackingOrderState();

  @override
  List<Object> get props => [];
}

class FetchTrackingOrderInitial extends FetchTrackingOrderState {}

class FetchTrackingOrderLoading extends FetchTrackingOrderState {}

class FetchTrackingOrderSuccess extends FetchTrackingOrderState {
  FetchTrackingOrderSuccess(this.logs);

  final TrackingOrder logs;

  @override
  List<Object> get props => [logs];
}

class FetchTrackingOrderFailure extends FetchTrackingOrderState {
  final ErrorType type;
  final String message;

  FetchTrackingOrderFailure({this.type = ErrorType.general, this.message});

  FetchTrackingOrderFailure.network(String message)
      : this(type: ErrorType.network, message: message);

  FetchTrackingOrderFailure.general(String message)
      : this(type: ErrorType.general, message: message);

  @override
  List<Object> get props => [type, message];
}
