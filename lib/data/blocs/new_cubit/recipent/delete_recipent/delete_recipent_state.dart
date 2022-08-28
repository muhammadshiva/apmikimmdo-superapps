part of 'delete_recipent_cubit.dart';

abstract class DeleteRecipentState extends Equatable {
  const DeleteRecipentState();

  @override
  List<Object> get props => [];
}

class DeleteRecipentInitial extends DeleteRecipentState {}

class DeleteRecipentLoading extends DeleteRecipentState {}

class DeleteRecipentSuccess extends DeleteRecipentState {}

class DeleteRecipentFailure extends DeleteRecipentState {
  DeleteRecipentFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}