import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marketplace/data/models/new_models/category.dart';
import 'package:marketplace/data/repositories/category_repository.dart';
import 'package:meta/meta.dart';

part 'fetch_subcategories_state.dart';

class FetchSubcategoriesCubit extends Cubit<FetchSubcategoriesState> {
  FetchSubcategoriesCubit() : super(FetchSubcategoriesInitial());

  final CategoryRepository _categoryRepository = CategoryRepository();

  void fetchSubcategories(int id) async {
    emit(FetchSubcategoriesLoading());
    try {
      final response = await _categoryRepository.fetchSubcategory(id);
      emit(FetchSubcategoriesSuccess(response.data));
    } catch (error) {
      emit(FetchSubcategoriesFailure());
    }
  }
}
