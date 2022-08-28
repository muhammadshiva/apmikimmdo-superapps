import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:marketplace/data/blocs/bottom_nav/bottom_nav_cubit.dart';
import 'package:marketplace/data/blocs/edit_user_profile/edit_user_profile_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/recipent/delete_recipent/delete_recipent_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/recipent/edit_recipent/edit_recipent_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/recipent/fetch_recipent/fetch_recipent_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/recipent/fetch_selected_recipent/fetch_selected_recipent_cubit.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/repositories.dart';
import 'package:marketplace/ui/screens/nav/new/account/address_entry_screen.dart';
import 'package:marketplace/ui/screens/nav/new/account/widget/update_account_list_recipent_item.dart';
import 'package:marketplace/ui/widgets/bs_confirmation.dart';
import 'package:marketplace/ui/widgets/edit_text.dart';
import 'package:marketplace/ui/widgets/loading_dialog.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/transitions.dart' as AppTrans;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class UpdateAddressScreen extends StatefulWidget {
  final bool isFromCheckout;

  const UpdateAddressScreen({Key key, this.isFromCheckout = false})
      : super(key: key);

  @override
  _UpdateAddressScreenState createState() => _UpdateAddressScreenState();
}

class _UpdateAddressScreenState extends State<UpdateAddressScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final RecipentRepository _recipentRepository = RecipentRepository();

  int recipentIdForCheckout;
  int selectedRecipentId;
  bool _isRecipentSelected;

  DeleteRecipentCubit _deleteRecipentCubit;
  EditRecipentCubit _editRecipentCubit;
  FetchRecipentCubit _fetchRecipentCubit;
  FetchSelectedRecipentCubit _fetchSelectedRecipentCubit;

  Recipent recipentMainAddress;

  TextEditingController _searchController;


  @override
  void initState() {
    _isRecipentSelected = false;
    _deleteRecipentCubit = DeleteRecipentCubit();
    _editRecipentCubit = EditRecipentCubit();
    _fetchRecipentCubit = FetchRecipentCubit()..fetchRecipents();
    _fetchSelectedRecipentCubit = FetchSelectedRecipentCubit()..fetchSelectedRecipent();
    super.initState();
  }

  void _handleAddress() async {
    int recipentID = await AppExt.pushScreen(
      context,
      AddressEntryScreen(),
    );
    if (recipentID != null) {
      _fetchRecipentCubit..fetchRecipents();
      setState(() {
        recipentIdForCheckout = recipentID;
      });
    }
  }

  void _handleDeleteAddress({@required int recipentId}) {
    AppExt.hideKeyboard(context);
    BsConfirmation().show(
        context: context,
        onYes: () {
          LoadingDialog.show(context);
          _deleteRecipentCubit.deleteRecipent(recipentId: recipentId);
        },
        title: "Apakah anda yakin akan menghapus alamat?");
  }

   @override
  void dispose() {
    _fetchRecipentCubit.close();
    _deleteRecipentCubit.close();
    _searchController.dispose();
    _fetchSelectedRecipentCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;
    // TODO: implement build
    return WillPopScope(
      onWillPop: () async {
        if (widget.isFromCheckout == true) {
          if (recipentIdForCheckout != null) {
            AppExt.popScreen(context, recipentIdForCheckout);
          } else {
            AppExt.popScreen(context, null);
          }
        } else {
          if (kIsWeb) {
            return false;
          } else {
            AppExt.popUntilRoot(context);
            BlocProvider.of<BottomNavCubit>(context).navItemTapped(3);
          }
        }
        return true;
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
        child: GestureDetector(
          onTap: () => AppExt.hideKeyboard(context),
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => _fetchSelectedRecipentCubit),
            ],
            child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: AppColor.white,
              extendBody: true,
              body: MultiBlocListener(
                listeners: [
                  BlocListener(
                    cubit: _deleteRecipentCubit,
                    listener: (context, state) {
                      if (state is DeleteRecipentFailure) {
                        AppExt.popScreen(context);
                        _scaffoldKey.currentState
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            new SnackBar(
                              duration: Duration(seconds: 1),
                              backgroundColor: AppColor.danger,
                              content: new Text(
                                "${state.message}",
                              ),
                            ),
                          );
                        return;
                      }
                      if (state is DeleteRecipentSuccess) {
                        AppExt.popScreen(context);
                        _fetchRecipentCubit.fetchRecipents();
                        return;
                      }
                    },
                  ),
                  BlocListener(
                    cubit: _editRecipentCubit,
                    listener: (context, state) {
                      if (state is EditRecipentSuccess) {
                        if (widget.isFromCheckout) {
                          AppExt.popScreen(context, state.data.id);
                        } else {
                          AppExt.popUntilRoot(context);
                          BlocProvider.of<BottomNavCubit>(context)
                              .navItemTapped(3);
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(
                                margin: EdgeInsets.zero,
                                duration: Duration(seconds: 2),
                                content: Text(
                                  "Alamat pengiriman utama telah diubah",
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                        }
                      }
                      if (state is EditRecipentFailure) {
                        debugPrint(state.message);
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
                      if (state is FetchSelectedRecipentFailure) {
                        ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(
                                margin: EdgeInsets.zero,
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.red,
                                content: Text(
                                  "Terjadi Kesalahan",
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                      }
                    },
                  ),
                ],
                child: SafeArea(
                  child: Stack(
                    children: [
                      NestedScrollView(
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverAppBar(
                              textTheme:
                                  TextTheme(headline6: AppTypo.subtitle2),
                              iconTheme: IconThemeData(color: AppColor.black),
                              backgroundColor: AppColor.white,
                              centerTitle: true,
                              forceElevated: false,
                              pinned: true,
                              shadowColor: Colors.black54,
                              floating: true,
                              title: Text("Daftar Alamat"),
                              brightness: Brightness.dark,
                            ),
                          ];
                        },
                        body: SingleChildScrollView(
                          physics: new BouncingScrollPhysics(),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: _screenWidth * (5 / 100),
                                vertical: _screenWidth * (3 / 100)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                EditText(
                                  hintText: "Cari Alamat",
                                  inputType: InputType.text,
                                  controller: this._searchController,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      borderRadius: BorderRadius.circular(7),
                                      onTap: () => _handleAddress(),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: Text(
                                          "Tambah Alamat",
                                          style: AppTypo.overline.copyWith(
                                              fontSize: 12,
                                              decoration:
                                                  TextDecoration.underline,
                                              color: AppColor.primary,
                                              fontWeight: FontWeight.w900),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                BlocBuilder(
                                  cubit: _fetchRecipentCubit,
                                  builder: (context, state) =>
                                      AppTrans.SharedAxisTransitionSwitcher(
                                    transitionType:
                                        SharedAxisTransitionType.vertical,
                                    fillColor: Colors.transparent,
                                    child: state is FetchRecipentLoading
                                        ? ListView.separated(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: 2,
                                            separatorBuilder:
                                                (context, index) => SizedBox(
                                              height: 15,
                                            ),
                                            itemBuilder: (context, index) =>
                                                UpdateAccountListRecipentItemLoading(),
                                          )
                                        : state is FetchRecipentFailure
                                            ? Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      height:
                                                          _screenWidth * 0.2,
                                                    ),
                                                    Icon(
                                                      FlutterIcons
                                                          .error_outline_mdi,
                                                      size: 45,
                                                      color:
                                                          AppColor.primaryDark,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    SizedBox(
                                                      width: 250,
                                                      child: Text(
                                                        state.message,
                                                        style: AppTypo
                                                            .overlineAccent,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 7,
                                                    ),
                                                    OutlineButton(
                                                      child: Text("Coba lagi"),
                                                      onPressed: () =>
                                                          _fetchRecipentCubit
                                                              .fetchRecipents(),
                                                      textColor:
                                                          AppColor.primaryDark,
                                                      color: AppColor.danger,
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          _screenWidth * 0.2,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : state is FetchRecipentSuccess
                                                ? state.recipent.length > 0
                                                    ? UpdateAccountListRecipentItem(
                                                        recipent:
                                                            state.recipent,
                                                        recipentMainAddress: recipentMainAddress,
                                                        onSelected: (value,
                                                            recipentId) {
                                                          setState(() {
                                                            _isRecipentSelected =
                                                                value;
                                                            selectedRecipentId =
                                                                recipentId;
                                                          });
                                                        },
                                                        onDelete: (id) {
                                                          _handleDeleteAddress(
                                                              recipentId: id);
                                                        },
                                                        triggerRefresh: () {
                                                          _fetchRecipentCubit
                                                              .fetchRecipents();
                                                              _fetchSelectedRecipentCubit.fetchSelectedRecipent();
                                                        })
                                                    : Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                              height:
                                                                  _screenWidth *
                                                                      0.2,
                                                            ),
                                                            Icon(
                                                              FlutterIcons
                                                                  .map_marker_plus_mco,
                                                              size: 45,
                                                              color: AppColor
                                                                  .primary,
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                              "Belum ada alamat",
                                                              style: AppTypo
                                                                  .overlineAccent,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            SizedBox(
                                                              height:
                                                                  _screenWidth *
                                                                      0.2,
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                : SizedBox.shrink(),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                RoundedButton.contained(
                                  label: "Pilih Alamat",
                                  textColor: AppColor.white,
                                  isUpperCase: false,
                                  onPressed: _isRecipentSelected
                                      ? () {
                                          if (selectedRecipentId != null) {
                                            _editRecipentCubit.editMainAddress(
                                                recipentId: selectedRecipentId);
                                          }
                                        }
                                      : null,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
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
