import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/debug/ui_debug_switcher/ui_debug_switcher_cubit.dart';
import 'package:marketplace/ui/widgets/a_app_config.dart';

class UiDebugSwitcher extends StatelessWidget {
  const UiDebugSwitcher({Key key, @required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    var config = AAppConfig.of(context);
    var data = BlocProvider.of<UiDebugSwitcherCubit>(context);

    return BlocBuilder(
      cubit: data,
      builder: (context, state) {
        if (!config.isQA) return SizedBox();
        if (!state) return SizedBox();
        return child;
      },
    );
  }
}
