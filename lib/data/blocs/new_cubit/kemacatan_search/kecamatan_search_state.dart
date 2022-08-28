part of 'kecamatan_search_cubit.dart';

abstract class KecamatanSearchState extends Equatable {
  const KecamatanSearchState();

  @override
  List<Object> get props => [];
}

class KecamatanSearchInitial extends KecamatanSearchState {}

class KecamatanSearchLoading extends KecamatanSearchState {}

class KecamatanSearchSuccess extends KecamatanSearchState {
  KecamatanSearchSuccess(this.result);

  final List<SearchKecamatanData> result;

  @override
  List<Object> get props => [result];
}

class KecamatanSearchFailure extends KecamatanSearchState {
  final ErrorType type;
  final String message;

  KecamatanSearchFailure({this.type = ErrorType.general, this.message});

  KecamatanSearchFailure.network(String message)
      : this(type: ErrorType.network, message: message);

  KecamatanSearchFailure.general(String message)
      : this(type: ErrorType.general, message: message);

  @override
  List<Object> get props => [type, message];
}
