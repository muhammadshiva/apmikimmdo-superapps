part of 'app_info_cubit.dart';

abstract class AppInfoState extends Equatable {
  const AppInfoState();

  @override
  List<Object> get props => [];
}

class AppInfoInitial extends AppInfoState {}

class AppInfoLoading extends AppInfoState {}

class AppInfoSuccess extends AppInfoState {
  AppInfoSuccess({
    @required this.data,
    @required this.packageInfo,
  });

  final AppInfo data;
  final PackageInfo packageInfo;

  bool get isVersionOutdated =>
      int.tryParse(packageInfo.buildNumber) < int.tryParse(data.versionCode);

  @override
  List<Object> get props => [data];
}

class AppInfoFailure extends AppInfoState {
  AppInfoFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
