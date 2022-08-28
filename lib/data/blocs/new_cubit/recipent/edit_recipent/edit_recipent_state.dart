part of 'edit_recipent_cubit.dart';

abstract class EditRecipentState extends Equatable {
  const EditRecipentState();

  @override
  List<Object> get props => [];
}

class EditRecipentInitial extends EditRecipentState {}

class EditRecipentLoading extends EditRecipentState {}

class EditRecipentSuccess extends EditRecipentState {
  final Recipent data;

  EditRecipentSuccess(this.data);

  @override
  List<Object> get props => [data];
}

class EditRecipentFailure extends EditRecipentState {
  EditRecipentFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
