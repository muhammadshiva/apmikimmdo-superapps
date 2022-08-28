import 'package:animations/animations.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';

import 'package:marketplace/data/blocs/bottom_nav/bottom_nav_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/recipent/fetch_recipent/fetch_recipent_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/recipent/fetch_selected_recipent/fetch_selected_recipent_cubit.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/new_repositories/recipent_repository.dart';
import 'package:marketplace/ui/screens/nav/nav.dart';
import 'package:marketplace/ui/screens/nav/new/account/account_screen.dart';
import 'package:marketplace/ui/screens/nav/new/home/widgets/handling_recipent_overlay.dart';
import 'package:marketplace/ui/screens/nav/new/new_nav.dart';
import 'package:marketplace/ui/screens/nav/new/toko_saya/toko_saya_screen.dart';
import 'package:marketplace/ui/screens/screens.dart';
import 'package:marketplace/ui/widgets/a_app_config.dart';
import 'package:marketplace/ui/widgets/web/web.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/transitions.dart' as AppTrans;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/extensions.dart' as AppExt;

import 'nav/new/transaksi/transaksi_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    Key key,
  }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldRootKey =
      new GlobalKey<ScaffoldState>();
  final RecipentRepository _recipentRepo = RecipentRepository();
  FetchRecipentCubit _fetchRecipentCubit = FetchRecipentCubit()
    ..fetchRecipents();
  FetchSelectedRecipentCubit _fetchSelectedRecipentCubit =
      FetchSelectedRecipentCubit()..fetchSelectedRecipent();

  int recipentId = 0;
  int recipentIdFromGs;

  BottomNavCubit _bottomNavCubit;
  DateTime currentBackPressTime;

  Recipent recipentMainAddress;

  @override
  void initState() {
    super.initState();
    _bottomNavCubit = BlocProvider.of<BottomNavCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldRootKey,
      body: MultiBlocListener(
        listeners: [
          BlocListener(
            cubit: BlocProvider.of<UserDataCubit>(context),
            listener: (context, state) {
              if (state is UserDataFailure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      margin: EdgeInsets.zero,
                      duration: Duration(seconds: 2),
                      content: Text('${state.message}'),
                      backgroundColor: Colors.grey[900],
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                return;
              }
            },
          ),
          BlocListener(
            cubit: _fetchSelectedRecipentCubit,
            listener: (context, state) {
              if (state is FetchSelectedRecipentSuccess) {
                setState(() {
                  recipentMainAddress = state.recipent;
                });
              }
            },
          ),
        ],
        child:
            // SafeArea(
            //   child: Column(
            //     children: [
            //       RoundedButton.contained(
            //         label: "Masuk",
            //         onPressed: () {},
            //       ),
            //       RoundedButton.outlined(
            //         label: "Keluar",
            //         color: AppColor.red,
            //         onPressed: () {},
            //       ),
            //     ],
            //   ),
            // ),
            BlocBuilder(
          cubit: _bottomNavCubit,
          builder: (context, state) => AppTrans.SharedAxisTransitionSwitcher(
            transitionType: SharedAxisTransitionType.vertical,
            fillColor: AppColor.navScaffoldBg,
            child: state is BottomNavHomeLoaded
                ? 
                // _recipentRepo.getRecipents() == null
                //     ? HandlingRecipentOverlay(
                //         onTap: () => Navigator.pushReplacement(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => HomeNav(
                //                       bottomNavCubit: _bottomNavCubit,
                //                     ))),
                //       )
                //     : 
                    HomeNav(bottomNavCubit: _bottomNavCubit)
                : state is BottomNavMyShopLoaded
                    ? BlocProvider.of<UserDataCubit>(context).state.user != null
                        // ? TransactionNav()
                        ? TokoSayaScreen()
                        : SignInScreen(isFromRoot: true)
                    : state is BottomNavTransactionLoaded
                        ? BlocProvider.of<UserDataCubit>(context).state.user !=
                                null
                            // ? TransactionNav()
                            ? TransaksiScreen()
                            : SignInScreen(isFromRoot: true)
                        : state is BottomNavAccountLoaded
                            ? BlocProvider.of<UserDataCubit>(context)
                                        .state
                                        .user !=
                                    null
                                ? AccountScreen()
                                : SignInScreen(isFromRoot: true)
                            : SizedBox.shrink(),
          ),
        ),
      ),
      bottomNavigationBar: !context.isPhone
          ? null
          : BlocBuilder<BottomNavCubit, BottomNavState>(
              cubit: _bottomNavCubit,
              builder: (context, state) => Theme(
                data: ThemeData(
                  splashFactory: InkRipple.splashFactory,
                  splashColor: AppColor.primaryDark.withOpacity(0.07),
                  highlightColor: AppColor.primary.withOpacity(0.07),
                ),
                child: BottomNavigationBar(
                  backgroundColor: AppColor.bottomNavBg,
                  selectedItemColor: AppColor.primary,
                  unselectedItemColor: AppColor.bottomNavIconInactive,
                  selectedFontSize: 13,
                  unselectedFontSize: 13,
                  selectedLabelStyle:
                      AppTypo.overline.copyWith(fontWeight: FontWeight.w700),
                  unselectedLabelStyle:
                      AppTypo.overline.copyWith(fontWeight: FontWeight.w700),
                  type: BottomNavigationBarType.fixed,
                  elevation: 8,
                  onTap: (index) => _bottomNavCubit.navItemTapped(index),
                  currentIndex: _bottomNavCubit.currentIndex,
                  items: _bottomNavCubit.navItem
                      .map(
                        (e) => BottomNavigationBarItem(
                          icon: e.icon,
                          activeIcon: e.activeIcon,
                          label: e.label,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _fetchRecipentCubit.close();
    _fetchSelectedRecipentCubit.close();
    super.dispose();
  }
}
