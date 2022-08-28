import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:marketplace/data/models/app_info.dart';
import 'package:marketplace/data/repositories/app_info_repository.dart';
import 'package:meta/meta.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'app_info_state.dart';

class AppInfoCubit extends Cubit<AppInfoState> {
  AppInfoCubit() : super(AppInfoInitial());

  final AppInfoRepository _appInfoRepo = AppInfoRepository();

  Future<void> load() async {
    emit(AppInfoLoading());
    try {
      final response = await _appInfoRepo.fetchAppInfo();
      final packageInfo = await _appInfoRepo.getAppInfo();
      emit(AppInfoSuccess(data: response.data, packageInfo: packageInfo));
    } catch (error) {
      emit(AppInfoFailure(error.toString()));
    }
  }

  @override
  void onChange(Change<AppInfoState> change) {
    super.onChange(change);
    debugPrint("changing---> " + change.toString());
  }
}
