import 'package:beamer/beamer.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/ui/screens/new_screens/new_screens.dart';
import 'package:marketplace/ui/screens/new_screens/notification/widgets/notification_body.dart';
import 'package:marketplace/ui/screens/screens.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/colors.dart' as AppColor;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: kIsWeb ? 450 : double.infinity),
        child: WillPopScope(
          onWillPop: () async {
            if (kIsWeb) {
              context.beamBack();
            } else {
              AppExt.popScreen(context);
            }
            return true;
          },
          child: GestureDetector(
            onTap: () => AppExt.hideKeyboard(context),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: !context.isPhone ? 450 : 1000,
              ),
              child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: AppColor.white,
                  centerTitle: true,
                  elevation: 0.0,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColor.black,
                    ),
                    onPressed: () => AppExt.popScreen(context),
                  ),
                  title: Text('Notifikasi',
                      style: AppTypo.subtitle2.copyWith(color: AppColor.black)),
                  actions: [
                    Stack(
                      children: [
                        IconButton(
                            padding: EdgeInsets.only(right: 10),
                            icon: Icon(EvaIcons.shoppingCart,
                                color: AppColor.black),
                            onPressed: () {
                              AppExt.pushScreen(
                                context,
                                BlocProvider.of<UserDataCubit>(context)
                                            .state
                                            .user !=
                                        null
                                    ? CartScreen()
                                    : SignInScreen(),
                              );
                            }),
                        BlocProvider.of<UserDataCubit>(context)
                                        .state
                                        .countCart !=
                                    null &&
                                BlocProvider.of<UserDataCubit>(context)
                                        .state
                                        .countCart >
                                    0
                            ? Positioned(
                                right: 8,
                                top: -12,
                                child: Chip(
                                  shape: CircleBorder(side: BorderSide.none),
                                  backgroundColor: AppColor.red,
                                  padding: EdgeInsets.zero,
                                  labelPadding:
                                      BlocProvider.of<UserDataCubit>(context)
                                                  .state
                                                  .countCart >
                                              99
                                          ? EdgeInsets.all(2)
                                          : EdgeInsets.all(4),
                                  label: Text(
                                    "${BlocProvider.of<UserDataCubit>(context).state.countCart}",
                                    style: AppTypo.overlineInv
                                        .copyWith(fontSize: 8),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ],
                ),
                body: SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 8,
                        child: Container(
                          color: Colors.grey[100],
                          child: NotificationBody(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
