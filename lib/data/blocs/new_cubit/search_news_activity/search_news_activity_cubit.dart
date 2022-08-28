import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/models/new_models/news_activity.dart';
import 'package:marketplace/data/repositories/new_repositories/news_activity_repository.dart';
import 'package:marketplace/data/repositories/repositories.dart';

part 'search_news_activity_state.dart';

class SearchNewsActivityCubit extends Cubit<SearchNewsActivityState> {
  SearchNewsActivityCubit() : super(SearchNewsActivityInitial());

  final NewsActivityRepository _newsActivityRepository =
      NewsActivityRepository();

  Future<void> search({@required String keyword}) async {
    emit(SearchNewsActivityLoading());
    try {
      final response = await _newsActivityRepository.search(keyword: keyword);
      emit(SearchNewsActivitySuccess(response.data));
    } catch (error) {
      if (error is NetworkException) {
        emit(SearchNewsActivityFailure.network(error.toString()));
        return;
      }
      emit(SearchNewsActivityFailure.general(error.toString()));
    }
  }
}
