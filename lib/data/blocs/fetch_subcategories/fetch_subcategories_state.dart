part of 'fetch_subcategories_cubit.dart';

abstract class FetchSubcategoriesState extends Equatable {
  const FetchSubcategoriesState();

  @override
  List<Object> get props => [];
}

class FetchSubcategoriesInitial extends FetchSubcategoriesState {}

class FetchSubcategoriesLoading extends FetchSubcategoriesState {}

class FetchSubcategoriesSuccess extends FetchSubcategoriesState {
  FetchSubcategoriesSuccess(this.subcategories);

  final List<Subcategory> subcategories;

  @override
  List<Object> get props => [subcategories];
}

class FetchSubcategoriesFailure extends FetchSubcategoriesState {}
