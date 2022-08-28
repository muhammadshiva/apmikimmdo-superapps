import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/category_repository.dart';

part 'fetch_categories_state.dart';

class FetchCategoriesCubit extends Cubit<FetchCategoriesState> {
  FetchCategoriesCubit() : super(FetchCategoriesInitial());

  final CategoryRepository _categoryRepository = CategoryRepository();

  void load() async {
    emit(FetchCategoriesLoading());
    try {
      final response = await _categoryRepository.fetchCategory();
      emit(FetchCategoriesSuccess(response.data));
    } catch (error) {
      if (error is NetworkException) {
        emit(FetchCategoriesFailure.network(error.toString()));
        return;
      }
      emit(FetchCategoriesFailure.general(error.toString()));
    }
  }

  void categoryMitra() async {
    emit(FetchCategoriesLoading());
    try {
      final response = await _categoryRepository.fetchCategoryMitra();
      emit(FetchCategoriesSuccess(response.data));
    } catch (error) {
      emit(FetchCategoriesFailure());
    }
  }

  void categoryProductRecom() async {
    emit(FetchCategoriesLoading());
    try {
      final response = await _categoryRepository.fetchProductCategoryRecom();
      emit(FetchCategoriesSuccess(response.data));
    } catch (error) {
      emit(FetchCategoriesFailure());
    }
  }

}
