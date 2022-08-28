import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/repositories.dart';

part 'fetch_product_toko_saya_state.dart';

class FetchProductTokoSayaCubit extends Cubit<FetchProductTokoSayaState> {
  FetchProductTokoSayaCubit() : super(FetchProductTokoSayaInitial());

  final JoinUserRepository _shopRepository = JoinUserRepository();

  Future<void> load() async {
    emit(FetchProductTokoSayaLoading());
    try {
      final response = await _shopRepository.getProductList();
      emit(FetchProductTokoSayaSuccess(response.data));
    } catch (error) {
      if (error is NetworkException) {
        emit(FetchProductTokoSayaFailure.network(error.toString()));
        return;
      }
      emit(FetchProductTokoSayaFailure.general(error.toString()));
    }
  }
}
