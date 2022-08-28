import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/repositories.dart';

part 'fetch_selected_recipent_state.dart';

class FetchSelectedRecipentCubit extends Cubit<FetchSelectedRecipentState> {
  FetchSelectedRecipentCubit() : super(FetchSelectedRecipentInitial());

  RecipentRepository _recipentRepository = RecipentRepository();

  void fetchSelectedRecipent() async {
    emit(FetchSelectedRecipentLoading());
    try {
      final response = await _recipentRepository.getMainAddress();
      // Recipent recipent = Recipent(
      //   id: response != null ? response : null,
      //   name: response != null ? response['name'] : null,
      //   phone: response != null ? response['phonenumber'] : null,
      //   address: response != null ? response['address'] : null,
      //   postalCode: response != null ? response['postal_code'] : null,
      //   subdistrictId: response != null ? response['subdistrict_id'] : null,
      //   subdistrict: response != null ? response['subdistrict'] : null,
      //   isMainAddress: response != null ? response['is_main_address'] : null,
      //   note:  response != null ? response['note'] : null,
      //   email: response != null ? response['email'] : null,
      // );
      emit(FetchSelectedRecipentSuccess(response != null ? response.data : null));
    } catch (error) {
      if (error is NetworkException) {
        emit(FetchSelectedRecipentFailure.network(error.toString()));
        return;
      }
      emit(FetchSelectedRecipentFailure.general(error.toString()));
    }
  }

  void fetchSelectedRecipentUserNoAuth() {
    emit(FetchSelectedRecipentLoading());
    try {
      final response = _recipentRepository.getSelectedRecipentNoAuth();
      if (response != null) {
        Recipent recipent = Recipent(
          id: null,
          name: response['name'] ?? null,
          phone: response['phonenumber'] ?? null,
          address: response['address'] ?? null,
          postalCode: null,
          subdistrictId: response['subdistrict_id'] ?? null,
          subdistrict: response['subdistrict'] ?? null,
          city: response['city'] ?? null,
          province: response['province'] ?? null,
          isMainAddress: null,
          note: null,
          email: null,
        );
        emit(FetchSelectedRecipentSuccess(recipent));
      } else {
        _recipentRepository.setRecipentUserNoAuth(
            subdistrictId: null, subdistrict: '');
        Recipent recipent = Recipent(
          id: null,
          name: null,
          phone: null,
          address: null,
          postalCode: null,
          subdistrictId: null,
          subdistrict: '',
          isMainAddress: null,
          note: null,
          email: null,
        );
        emit(FetchSelectedRecipentSuccess(recipent));
      }
    } catch (error) {
      emit(FetchSelectedRecipentFailure.general(error.toString()));
    }
  }

  void fetchSelectedrecipentUserNoAuthDashboard() {
    emit(FetchSelectedRecipentLoading());
    try {
      final response = _recipentRepository.getSelectedRecipentNoAuthDashboard();
      if (response != null) {
        Recipent recipent = Recipent(
          id: null,
          name: response['name'] ?? null,
          phone: response['phonenumber'] ?? null,
          address: response['address'] ?? null,
          postalCode: null,
          subdistrictId: response['subdistrict_id'] ?? null,
          subdistrict: response['subdistrict'] ?? null,
          city: response['city'] ?? null,
          province: response['province'] ?? null,
          isMainAddress: null,
          note: null,
          email: null,
        );
        emit(FetchSelectedRecipentSuccess(recipent));
      } else {
        _recipentRepository.setRecipentUserNoAuthDashboard(
            subdistrictId: null, subdistrict: '');
        Recipent recipent = Recipent(
          id: null,
          name: null,
          phone: null,
          address: null,
          postalCode: null,
          subdistrictId: null,
          subdistrict: '',
          isMainAddress: null,
          note: null,
          email: null,
        );
        emit(FetchSelectedRecipentSuccess(recipent));
      }
    } catch (error) {
      emit(FetchSelectedRecipentFailure.general(error.toString()));
    }
  }

  void fetchSelectedrecipentUserNoAuthDetailProduct() {
    emit(FetchSelectedRecipentLoading());
    try {
      final response = _recipentRepository.getSelectedRecipentNoAuthDetailProduct();
      if (response != null) {
        Recipent recipent = Recipent(
          id: null,
          name: response['name'] ?? null,
          phone: response['phonenumber'] ?? null,
          address: response['address'] ?? null,
          postalCode: null,
          subdistrictId: response['subdistrict_id'] ?? null,
          subdistrict: response['subdistrict'] ?? null,
          city: response['city'] ?? null,
          province: response['province'] ?? null,
          isMainAddress: null,
          note: null,
          email: null,
        );
        emit(FetchSelectedRecipentSuccess(recipent));
      } else {
        _recipentRepository.setRecipentUserNoAuthDashboard(
            subdistrictId: null, subdistrict: '');
        Recipent recipent = Recipent(
          id: null,
          name: null,
          phone: null,
          address: null,
          postalCode: null,
          subdistrictId: null,
          subdistrict: '',
          isMainAddress: null,
          note: null,
          email: null,
        );
        emit(FetchSelectedRecipentSuccess(recipent));
      }
    } catch (error) {
      emit(FetchSelectedRecipentFailure.general(error.toString()));
    }
  }

}
