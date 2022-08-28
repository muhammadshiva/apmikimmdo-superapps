import 'package:flutter/material.dart';

enum AppType { panenpanen, sumedang, bisnisomarket, bisnisogrosir, apmikimmdo }

extension AppTypeExt on AppType {
  String get val => this.toString().split('.').last;
}

class AAppConfig extends InheritedWidget {
  final String appName;
  final AppType appType;
  final bool isQA;
  final Widget child;

  AAppConfig({
    @required this.appType,
    @required this.appName,
    @required this.isQA,
    @required this.child,
  });

  static AAppConfig of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
