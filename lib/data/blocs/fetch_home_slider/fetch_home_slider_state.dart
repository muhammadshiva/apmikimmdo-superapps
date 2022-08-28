part of 'fetch_home_slider_cubit.dart';

abstract class FetchHomeSliderState extends Equatable {
  const FetchHomeSliderState();

  @override
  List<Object> get props => [];
}

class FetchHomeSliderInitial extends FetchHomeSliderState {}

class FetchHomeSliderLoading extends FetchHomeSliderState {}

class FetchHomeSliderSuccess extends FetchHomeSliderState {
  FetchHomeSliderSuccess(this.homeSliders);

  final List<HomeSlider> homeSliders;

  @override
  List<Object> get props => [homeSliders];
}

class FetchHomeSliderFailure extends FetchHomeSliderState {
  final ErrorType type;
  final String message;

  FetchHomeSliderFailure({this.type = ErrorType.general, this.message});

  FetchHomeSliderFailure.network(String message)
      : this(type: ErrorType.network, message: message);

  FetchHomeSliderFailure.general(String message)
      : this(type: ErrorType.general, message: message);

  @override
  List<Object> get props => [type, message];
}
