import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/new_models/news_activity.dart';
import 'package:marketplace/data/repositories/new_repositories/news_activity_repository.dart';

part 'fetch_news_activity_by_tag_state.dart';

class FetchNewsActivityByTagCubit extends Cubit<FetchNewsActivityByTagState> {
  FetchNewsActivityByTagCubit() : super(FetchNewsActivityByTagInitial());

  final NewsActivityRepository _newsActivityRepository =
      NewsActivityRepository();

  Future<void> fetchNewsActivityByTag({@required int tagId}) async {
    emit(FetchNewsActivityByTagLoading());
    try {
      final response =
          await _newsActivityRepository.fetchNewsActivityByTag(tagId: tagId);
      emit(FetchNewsActivityByTagSuccess(response.data));
    } catch (error) {
      if (error is NetworkException) {
        emit(FetchNewsActivityByTagFailure.network(error.toString()));
      }
      emit(FetchNewsActivityByTagFailure.general(error.toString()));
    }
  }
}
