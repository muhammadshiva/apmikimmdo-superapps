part of 'product_coverage_validation_cubit.dart';

abstract class ProductCoverageValidationState extends Equatable {
  const ProductCoverageValidationState();

  @override
  List<Object> get props => [];
}

class ProductCoverageValidationInitial extends ProductCoverageValidationState {}

class ProductCoverageValidationLoading extends ProductCoverageValidationState {}

class ProductCoverageValidationSuccess extends ProductCoverageValidationState {
  ProductCoverageValidationSuccess(this.status);

  final bool status;

  @override
  List<Object> get props => [status];
}

class ProductCoverageValidationFailure extends ProductCoverageValidationState {
  final ErrorType type;
  final String message;

  ProductCoverageValidationFailure({this.type = ErrorType.general, this.message});

  ProductCoverageValidationFailure.network(String message)
      : this(type: ErrorType.network, message: message);

  ProductCoverageValidationFailure.general(String message)
      : this(type: ErrorType.general, message: message);

  @override
  List<Object> get props => [type, message];
}