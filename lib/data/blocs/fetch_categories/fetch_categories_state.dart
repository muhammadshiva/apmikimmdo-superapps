part of 'fetch_categories_cubit.dart';

abstract class FetchCategoriesState extends Equatable {
  const FetchCategoriesState();

  @override
  List<Object> get props => [];
}

class FetchCategoriesInitial extends FetchCategoriesState {}

class FetchCategoriesLoading extends FetchCategoriesState {}

class FetchCategoriesSuccess extends FetchCategoriesState {
  FetchCategoriesSuccess(this.categories);

  final List<Category> categories;

  @override
  List<Object> get props => [categories];
}

class FetchCategoriesFailure extends FetchCategoriesState {
  final ErrorType type;
  final String message;

  FetchCategoriesFailure({this.type = ErrorType.general, this.message});

  FetchCategoriesFailure.network(String message)
      : this(type: ErrorType.network, message: message);

  FetchCategoriesFailure.general(String message)
      : this(type: ErrorType.general, message: message);

  @override
  List<Object> get props => [type, message];
}
