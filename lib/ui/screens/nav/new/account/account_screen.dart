import 'dart:async';
import 'dart:io';

import 'package:beamer/beamer.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketplace/data/blocs/bottom_nav/bottom_nav_cubit.dart';
import 'package:marketplace/data/blocs/upload_user_avatar/upload_user_avatar_cubit.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/authentication_repository.dart';
import 'package:marketplace/ui/screens/nav/new/account/update_address_screen.dart';
import 'package:marketplace/ui/screens/nav/new/account/widget/account_info_item.dart';
import 'package:marketplace/ui/screens/new_screens/join_user/join_user_add_product_screen.dart';
import 'package:marketplace/ui/screens/new_screens/join_user/join_user_screen.dart';
import 'package:marketplace/ui/screens/screens.dart';
import 'package:marketplace/ui/widgets/bs_confirmation.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/constants.dart' as AppConst;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../new_nav.dart';
import 'widget/account_role_item.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({
    Key key,
  }) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final AuthenticationRepository _authRepo = AuthenticationRepository();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final picker = ImagePicker();

  UploadUserAvatarCubit _uploadUserAvatarCubit;
  List<RoleItem> _roleItem = [];

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  bool isVersionCodeShow;

  @override
  void initState() {
    super.initState();
    _uploadUserAvatarCubit = UploadUserAvatarCubit(
        userDataCubit: BlocProvider.of<UserDataCubit>(context));
    isVersionCodeShow = true;
    _checkUser();
    _initPackageInfo();
  }

  void _checkUser() async {
    if (await _authRepo.hasToken()) {
      await BlocProvider.of<UserDataCubit>(context).loadUser();
    }
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  void _launchUrl(String _url) async {
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      BSFeedback.show(
        context,
        icon: Boxicons.bx_x_circle,
        color: AppColor.red,
        title: "Gagal mengakses halaman",
        description: "Halaman atau koneksi internet bermasalah",
      );
    }
  }

  @override
  void dispose() {
    _uploadUserAvatarCubit.close();
    super.dispose();
  }

  void _handleCopy(String text, String message) {
    Clipboard.setData(new ClipboardData(text: text));
    ScaffoldMessenger.of(_scaffoldKey.currentContext)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        new SnackBar(
          backgroundColor: Colors.grey[900],
          content: new Text(
            message,
          ),
          duration: Duration(seconds: 1),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final Size _screenSize = MediaQuery.of(context).size;

    final userDataCubit = BlocProvider.of<UserDataCubit>(context);
    final bool isCustomerUser = userDataCubit.state.user?.reseller == null &&
        userDataCubit.state.user?.supplier == null;
    final bool condition1 = userDataCubit.state.user?.reseller != null &&
        userDataCubit.state.user?.supplier == null;
    final bool condition2 = userDataCubit.state.user?.reseller != null &&
        userDataCubit.state.user?.supplier != null;
    final bool condition3 = userDataCubit.state.user?.reseller == null &&
        userDataCubit.state.user?.supplier != null;
    // debugPrint("isCust $isCustomerUser isReseller $isReseller isSupplier $isSupplier");

    if (isCustomerUser)
      _roleItem = [
        RoleItem(
            onTap: () {
              AppExt.pushScreen(
                  context, JoinUserScreen(userType: UserType.reseller));
            },
            icon: kIsWeb
                ? WebsafeSvg.asset(
                    AppImg.ic_reseller,
                    height: 40,
                    width: 40,
                  )
                : SvgPicture.asset(
                    AppImg.ic_reseller,
                    height: 40,
                    width: 40,
                  ),
            title: "Reseller",
            subtitle: "Jual produk dan dapatkan keuntungan"),
        RoleItem(
            onTap: () {
              AppExt.pushScreen(
                  context, JoinUserScreen(userType: UserType.supplier));
            },
            icon: kIsWeb
                ? WebsafeSvg.asset(
                    AppImg.ic_supplier,
                    height: 40,
                    width: 40,
                  )
                : SvgPicture.asset(
                    AppImg.ic_supplier,
                    height: 40,
                    width: 40,
                  ),
            title: "Supplier",
            subtitle: "Tawarkan produk anda ke Apmikimmdo"),
      ];
    else if (condition1) {
      _roleItem = [];
      _roleItem.add(
        RoleItem(
          onTap: () {
            AppExt.pushScreen(
                context,
                ProducerDashboardScreen(
                  isReseller: true,
                ));
          },
          icon: SvgPicture.asset(
            AppImg.ic_reseller,
            height: 40,
            width: 40,
          ),
          title: "Reseller",
          subtitle: "Jual produk dan dapatkan keuntungan",
        ),
      );
      _roleItem.add(
        RoleItem(
          onTap: () {
            AppExt.pushScreen(
                context, JoinUserScreen(userType: UserType.supplier));
          },
          icon: SvgPicture.asset(
            AppImg.ic_supplier,
            height: 40,
            width: 40,
          ),
          title: "Supplier",
          subtitle: "Tawarkan produk anda ke Apmikimmdo",
        ),
      );
    } else if (condition2) {
      _roleItem = [];
      _roleItem.add(
        RoleItem(
          onTap: () {
            AppExt.pushScreen(
                context,
                ProducerDashboardScreen(
                  isReseller: true,
                ));
          },
          icon: SvgPicture.asset(
            AppImg.ic_reseller,
            height: 40,
            width: 40,
          ),
          title: "Reseller",
          subtitle: "Jual produk dan dapatkan keuntungan",
        ),
      );
      _roleItem.add(
        RoleItem(
          onTap: () {
            AppExt.pushScreen(
                context,
                ProducerDashboardScreen(
                  isSupplier: true,
                ));
          },
          icon: SvgPicture.asset(
            AppImg.ic_supplier,
            height: 40,
            width: 40,
          ),
          title: "Supplier",
          subtitle: "Tawarkan produk anda ke Apmikimmdo",
        ),
      );
    } else {
      _roleItem = [];
      _roleItem.add(
        RoleItem(
          onTap: () {
            AppExt.pushScreen(
                context, JoinUserScreen(userType: UserType.reseller));
          },
          icon: SvgPicture.asset(
            AppImg.ic_reseller,
            height: 40,
            width: 40,
          ),
          title: "Reseller",
          subtitle: "Jual produk dan dapatkan keuntungan",
        ),
      );
      _roleItem.add(
        RoleItem(
          onTap: () {
            AppExt.pushScreen(
                context,
                ProducerDashboardScreen(
                  isSupplier: true,
                ));
          },
          icon: SvgPicture.asset(
            AppImg.ic_supplier,
            height: 40,
            width: 40,
          ),
          title: "Supplier",
          subtitle: "Tawarkan produk anda ke Apmikimmdo",
        ),
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
      child: GestureDetector(
        onTap: () => AppExt.hideKeyboard(context),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: kIsWeb ? 400 : 1000),
            child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: AppColor.textPrimaryInverted,
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20)
                      .copyWith(bottom: 0),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Center(
                            child: CircleAvatar(
                              backgroundColor: AppColor.navScaffoldBg,
                              radius: _screenSize.width * (12.5 / 100),
                              backgroundImage: userDataCubit
                                          .state.user.avatar !=
                                      null
                                  ? NetworkImage(
                                      "${AppConst.STORAGE_URL}/user/avatar/${userDataCubit.state.user.avatar}")
                                  : AssetImage(
                                      AppImg.img_default_account,
                                    ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${userDataCubit.state.user.name}",
                            style: AppTypo.subtitle1
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "+",
                                style: AppTypo.caption,
                              ),
                              Text(
                                "${userDataCubit.state.user.phonenumber}",
                                style: AppTypo.caption,
                              ),
                            ],
                          ),
                          UiDebugSwitcher(
                            child: Column(
                              children: [
                                Text('user_id: ${userDataCubit.state.user.id}'),
                                Text(
                                    'role_id: ${userDataCubit.state.user.roleId}'),
                                SizedBox(height: 5),
                                Text('token:'),
                                FutureBuilder(
                                  future: AuthenticationRepository().getToken(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData)
                                      return Column(
                                        children: [
                                          SelectableText(snapshot.data),
                                          OutlinedButton.icon(
                                            onPressed: () => _handleCopy(
                                              snapshot.data,
                                              'Copied!',
                                            ),
                                            icon: Icon(Icons.copy),
                                            label: Text("Copy token"),
                                          ),
                                        ],
                                      );
                                    return SelectableText("-");
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      AccountInfoItem(user: userDataCubit.state.user),
                      Column(
                        children: List.generate(
                            _roleItem.length, (index) => _roleItem[index]),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ListTile(
                        title: Text(
                          'Ubah Data Saya',
                          style: AppTypo.subtitle1,
                        ),
                        trailing: Icon(FlutterIcons.chevron_right_mco,
                            color: AppColor.primary),
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        onTap: () {
                          if (kIsWeb) {
                            context.beamToNamed('/account/profile');
                          } else {
                            AppExt.pushScreen(
                                context,
                                UpdateAccountScreen(
                                    user: userDataCubit.state.user));
                          }
                        },
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                      ),
                      Divider(height: 0),
                      ListTile(
                        title: Text(
                          'Daftar Alamat',
                          style: AppTypo.subtitle1,
                        ),
                        trailing: Icon(FlutterIcons.chevron_right_mco,
                            color: AppColor.primary),
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        onTap: () =>
                            AppExt.pushScreen(context, UpdateAddressScreen()),
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                      ),
                      Divider(height: 0),
                      ListTile(
                        title: Text(
                          'Ketentuan Layanan',
                          style: AppTypo.subtitle1,
                        ),
                        trailing: Icon(
                          FlutterIcons.chevron_right_mco,
                          color: AppColor.primary,
                        ),
                        onTap: () =>
                            _launchUrl('https://admasolusi.com/privacy'),
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                      ),
                      Divider(height: 0),
                      ListTile(
                        title: Text(
                          'Kebijakan Privasi',
                          style: AppTypo.subtitle1,
                        ),
                        trailing: Icon(
                          FlutterIcons.chevron_right_mco,
                          color: AppColor.primary,
                        ),
                        onTap: () =>
                            _launchUrl('https://admasolusi.com/privacy'),
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                      ),
                      Divider(height: 0),
                      ListTile(
                        title: Text(
                          'Pusat Bantuan',
                          style: AppTypo.subtitle1,
                        ),
                        trailing: Icon(FlutterIcons.chevron_right_mco,
                            color: AppColor.primary),
                        onTap: () => _launchUrl(
                            'https://api.whatsapp.com/send?phone=6281132271374&text=Halo%20 Apmikimmdo'),
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                      ),
                      Divider(
                        height: 0,
                      ),
                      ListTile(
                        title: Text(
                          'Saran',
                          style: AppTypo.subtitle1,
                        ),
                        trailing: Icon(FlutterIcons.chevron_right_mco,
                            color: AppColor.primary),
                        onTap: () {},
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                      ),
                      Divider(
                        height: 0,
                      ),
                      SizedBox(
                        height: _screenSize.width * (7 / 100),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child: RoundedButton.outlined(
                          key: const Key(
                              'signInScreen_continueWithGoogle_roundedButton'),
                          label: "Keluar",
                          onPressed: () {
                            BsConfirmation().show(
                                context: context,
                                onYes: () {
                                  userDataCubit.logout();
                                  BlocProvider.of<BottomNavCubit>(context)
                                      .navItemTapped(0);
                                },
                                title: "Apakah anda yakin ingin keluar?");
                          },
                          isUpperCase: false,
                          color: AppColor.danger,
                        ),
                      ),
                      GestureDetector(
                        onDoubleTap: () {
                          setState(() {
                            isVersionCodeShow = !isVersionCodeShow;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            "v1.0.0",
                            /*"v${_packageInfo.version}${isVersionCodeShow ? '+' + _packageInfo.buildNumber : ''}",*/
                            style: AppTypo.captionAccent,
                            textAlign: TextAlign.center,
                          ),
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
