part of 'add_recipent_cubit.dart';

abstract class AddRecipentState extends Equatable {
  const AddRecipentState();

  @override
  List<Object> get props => [];
}

class AddRecipentInitial extends AddRecipentState {}

class AddRecipentLoading extends AddRecipentState {}

class AddRecipentSuccess extends AddRecipentState {
  final Recipent data;

  AddRecipentSuccess(this.data);

  @override
  List<Object> get props => [data];
}

class AddRecipentFailure extends AddRecipentState {
  final ErrorType type;
  final String message;

  AddRecipentFailure({this.type = ErrorType.general, this.message});

  AddRecipentFailure.network(String message)
      : this(type: ErrorType.network, message: message);

  AddRecipentFailure.general(String message)
      : this(type: ErrorType.general, message: message);

  @override
  List<Object> get props => [type, message];
}


