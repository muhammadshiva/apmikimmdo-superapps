import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/new_models/region.dart';
import 'package:marketplace/data/repositories/new_repositories/region_repository.dart';

part 'fetch_regions_state.dart';

class FetchRegionsCubit extends Cubit<FetchRegionsState> {
  FetchRegionsCubit() : super(FetchRegionsInitial());

  final RegionRepository regionRepo = RegionRepository();

  Future<void> fetchProvince() async {
    emit(FetchRegionsLoading());
    try {
      final response = await regionRepo.fetchProvinces();
      emit(FetchRegionsSuccess(response.data));
    } catch (error) {
      if (error is NetworkException) {
        emit(FetchRegionsFailure.network(error.toString()));
        return;
      }
      emit(FetchRegionsFailure.general(error.toString()));
    }
  }

  Future<void> fetchCities({@required int provinceId}) async {
    emit(FetchRegionsLoading());
    try {
      final response = await regionRepo.fetchCities(provinceId: provinceId);
      emit(FetchRegionsSuccess(response.data));
    } catch (error) {
      if (error is NetworkException) {
        emit(FetchRegionsFailure.network(error.toString()));
        return;
      }
      emit(FetchRegionsFailure.general(error.toString()));
    }
  }
}
