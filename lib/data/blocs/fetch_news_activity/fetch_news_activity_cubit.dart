import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:equatable/equatable.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/models/new_models/news_activity.dart';
import 'package:marketplace/data/repositories/new_repositories/news_activity_repository.dart';
part 'fetch_news_activity_state.dart';

class FetchNewsActivityCubit extends Cubit<FetchNewsActivityState> {
  FetchNewsActivityCubit() : super(FetchNewsActivityInitial());

  final NewsActivityRepository _newsActivityRepository =
      NewsActivityRepository();

  void load() async {
    emit(FetchNewsActivityLoading());
    try {
      final response = await _newsActivityRepository.fetchNewsActivity();
      emit(FetchNewsActivitySuccess(response.data));
    } catch (error) {
      if (error is NetworkException) {
        emit(FetchNewsActivityFailure.network(error.toString()));
        return;
      }
      emit(FetchNewsActivityFailure.general(error.toString()));
    }
  }
}
