import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/repositories.dart';

part 'fetch_home_slider_state.dart';

class FetchHomeSliderCubit extends Cubit<FetchHomeSliderState> {
  FetchHomeSliderCubit() : super(FetchHomeSliderInitial());

  final HomeSliderRepository _homeSliderRepository = HomeSliderRepository();

  Future<void> fetchHomeSlider() async {
    emit(FetchHomeSliderLoading());
    try {
      final response = await _homeSliderRepository.fetchHomeSlider();
      emit(FetchHomeSliderSuccess(response.data));
    } catch (error) {
      if (error is NetworkException) {
        emit(FetchHomeSliderFailure.network(error.toString()));
        return;
      }
      emit(FetchHomeSliderFailure.general(error.toString()));
    }
  }
}
