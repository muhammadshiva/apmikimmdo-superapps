import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class UiDebugSwitcherCubit extends Cubit<bool> {
  UiDebugSwitcherCubit() : super(false);

  void toggle() => emit(!state);

  void show() => emit(true);

  void hide() => emit(false);

  @override
  void onChange(Change<bool> change) {
    super.onChange(change);
    debugPrint(change.nextState.toString());
  }
}
