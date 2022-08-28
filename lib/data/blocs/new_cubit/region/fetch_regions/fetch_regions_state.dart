part of 'fetch_regions_cubit.dart';

abstract class FetchRegionsState extends Equatable {
  const FetchRegionsState();

  @override
  List<Object> get props => [];
}

class FetchRegionsInitial extends FetchRegionsState {}

class FetchRegionsLoading extends FetchRegionsState {}

class FetchRegionsSuccess extends FetchRegionsState {
  FetchRegionsSuccess(this.regions);

  final List<Region> regions;

  @override
  List<Object> get props => [regions];
}

class FetchRegionsFailure extends FetchRegionsState {
  final ErrorType type;
  final String message;

  FetchRegionsFailure({this.type = ErrorType.general, this.message});

  FetchRegionsFailure.network(String message)
      : this(type: ErrorType.network, message: message);

  FetchRegionsFailure.general(String message)
      : this(type: ErrorType.general, message: message);

  @override
  List<Object> get props => [type, message];
}

