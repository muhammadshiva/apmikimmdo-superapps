import 'package:meta/meta.dart';

class AppInfoRes {
  AppInfoRes({
    @required this.status,
    @required this.data,
  });

  final String status;
  final AppInfo data;

  factory AppInfoRes.fromJson(Map<String, dynamic> json) => AppInfoRes(
        status: json["status"],
        data: AppInfo.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class AppInfo {
  AppInfo({
    @required this.id,
    @required this.appName,
    @required this.versionCode,
    @required this.versionName,
    @required this.endVersion,
    @required this.language,
  });

  final int id;
  final String appName;
  final String versionCode;
  final String versionName;
  final String endVersion;
  final String language;

  factory AppInfo.fromJson(Map<String, dynamic> json) => AppInfo(
        id: json["id"],
        appName: json["app_name"],
        versionCode: json["version_code"],
        versionName: json["version_name"],
        endVersion: json["end_version"],
        language: json["language"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "app_name": appName,
        "version_code": versionCode,
        "version_name": versionName,
        "end_version": endVersion,
        "language": language,
      };
}
