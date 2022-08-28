import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/new_models/tag_news_activity.dart';
import 'package:marketplace/data/repositories/new_repositories/tag_news_activity_repository.dart';

part 'tag_news_activity_state.dart';

class FetchTagNewsActivityCubit extends Cubit<FetchTagNewsActivityState> {
  FetchTagNewsActivityCubit() : super(FetchTagNewsActivityInitial());

  final TagNewsActivityRepository _tagNewsActivityRepository =
      TagNewsActivityRepository();

  void load() async {
    emit(FetchTagNewsActivityLoading());
    try {
      final response = await _tagNewsActivityRepository.fetchTagNewsActivity();
      emit(FetchTagNewsActivitySuccess(response.data));
    } catch (error) {
      if (error is NetworkException) {
        emit(FetchTagNewsActivityFailure.network(error.toString()));
        return;
      }
      emit(FetchTagNewsActivityFailure.general(error.toString()));
    }
  }
}
