part of 'entry_shop_cubit.dart';

abstract class EntryShopState extends Equatable {
  const EntryShopState();

  @override
  List<Object> get props => [];
}

class EntryShopInitial extends EntryShopState {}

class EntryShopLoading extends EntryShopState {}

class EntryShopSuccess extends EntryShopState {}

class EntryShopFailure extends EntryShopState {
  EntryShopFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
