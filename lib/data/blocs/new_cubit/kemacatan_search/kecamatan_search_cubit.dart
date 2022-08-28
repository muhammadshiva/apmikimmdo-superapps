import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/new_models/search.dart';
import 'package:marketplace/data/models/new_models/search_kecamatan.dart';
import 'package:marketplace/data/repositories/new_repositories/kecamatan_repository.dart';
import 'package:marketplace/data/repositories/new_repositories/products_repository.dart';
import 'package:meta/meta.dart';

part 'kecamatan_search_state.dart';

class KecamatanSearchCubit extends Cubit<KecamatanSearchState> {
  KecamatanSearchCubit() : super(KecamatanSearchInitial());

  final _repository = KecamatanRepository();

  Future<void> search({@required String keyword}) async {
    _reset();
    emit(KecamatanSearchLoading());
    try {
      final response = await _repository.fetchKecamatan(keyword: keyword);
      // debugPrint(response);
      emit(KecamatanSearchSuccess(response.data));
    } catch (error) {
      if (error is NetworkException) {
        emit(KecamatanSearchFailure.network(error.toString()));
        return;
      }
      emit(KecamatanSearchFailure.general(error.toString()));
    }
  }

  void _reset() => emit(KecamatanSearchInitial());

// Future<void> searchProductSellerWeb({@required String keyword,@required int sellerId}) async {
//   emit(SearchLoading());
//   try {
//     final response = await _repository.searchProductSellerWeb(keyword: keyword, sellerId: sellerId);
//     emit(SearchSuccess(response.data));
//   } catch (error) {
//     if (error is NetworkException) {
//       emit(SearchFailure.network(error.toString()));
//       return;
//     }
//     emit(SearchFailure.general(error.toString()));
//   }
// }

}
