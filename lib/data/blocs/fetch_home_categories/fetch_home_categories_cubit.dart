import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/new_models/home_category.dart';
import 'package:marketplace/data/repositories/category_repository.dart';

part 'fetch_home_categories_state.dart';

class FetchHomeCategoriesCubit extends Cubit<FetchHomeCategoriesState> {
  FetchHomeCategoriesCubit() : super(FetchHomeCategoriesInitial());

  final CategoryRepository _categoryRepository = CategoryRepository();

  void load() async {
    emit(FetchHomeCategoriesLoading());
    try {
      final response = await _categoryRepository.fetchHomeCategory();
      emit(FetchHomeCategoriesSuccess(response.data));
    } catch (error) {
      if (error is NetworkException) {
        emit(FetchHomeCategoriesFailure.network(error.toString()));
        return;
      }
      emit(FetchHomeCategoriesFailure.general(error.toString()));
    }
  }
}
