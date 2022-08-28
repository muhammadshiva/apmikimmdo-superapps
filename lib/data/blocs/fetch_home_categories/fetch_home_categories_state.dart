part of 'fetch_home_categories_cubit.dart';

abstract class FetchHomeCategoriesState extends Equatable {
  const FetchHomeCategoriesState();

  @override
  List<Object> get props => [];
}

class FetchHomeCategoriesInitial extends FetchHomeCategoriesState {}

class FetchHomeCategoriesLoading extends FetchHomeCategoriesState {}

class FetchHomeCategoriesSuccess extends FetchHomeCategoriesState {
  FetchHomeCategoriesSuccess(this.homeCategories);

  final List<HomeCategory> homeCategories;

  @override
  List<Object> get props => [homeCategories];
}

class FetchHomeCategoriesFailure extends FetchHomeCategoriesState {
  final ErrorType type;
  final String message;

  FetchHomeCategoriesFailure({this.type = ErrorType.general, this.message});

  FetchHomeCategoriesFailure.network(String message)
      : this(type: ErrorType.network, message: message);

  FetchHomeCategoriesFailure.general(String message)
      : this(type: ErrorType.general, message: message);

  @override
  List<Object> get props => [type, message];
}
