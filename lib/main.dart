import 'dart:io';
import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:marketplace/api/api_http_overrides.dart';
import 'package:marketplace/data/blocs/app_info/app_info_cubit.dart';
import 'package:marketplace/data/blocs/debug/ui_debug_switcher/ui_debug_switcher_cubit.dart';
import 'package:marketplace/data/blocs/fetch_subcategories/fetch_subcategories_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/add_product_supplier/add_product_supplier_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/products/filter_products/filter_products_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/recipent/fetch_recipent/fetch_recipent_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/choose_kecamatan/choose_kecamatan_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/fetch_transaction/fetch_transaction_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/fetch_transaction_detail/fetch_transaction_detail_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/fetch_transaction_new/fetch_transaction_new_bloc.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/transaksi_filter_kategori/transaksi_filter_kategori_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/transaksi_filter_kategori_search/transaksi_filter_kategori_search_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/transaksi_filter_tanggal/transaksi_filter_tanggal_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/transaksi_upload_review_photo/transaksi_upload_review_photo_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/wpp_cart/add_to_cart_offline/add_to_cart_offline_cubit.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_strategy/url_strategy.dart';

import 'package:marketplace/data/blocs/bottom_nav/bottom_nav_cubit.dart';
import 'package:marketplace/data/blocs/transaction/handle_transaction_route_web/handle_transaction_route_web_cubit.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/repositories/repositories.dart';
import 'package:marketplace/route/beam_locations.dart';
import 'package:marketplace/ui/screens/screens.dart';
import 'package:marketplace/ui/widgets/a_app_config.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/transitions.dart' as AppTrans;

import 'app_bloc_observer.dart';
import 'data/blocs/new_cubit/bagikan_produk/bagikan_produk_cubit.dart';
import 'data/blocs/new_cubit/cart/fetch_cart/fetch_cart_cubit.dart';
import 'data/blocs/new_cubit/kemacatan_search/kecamatan_search_cubit.dart';
import 'data/blocs/new_cubit/register_supplier_reseller/register_supplier_reseller_cubit.dart';
import 'data/blocs/new_cubit/supplier/get_product_supplier/get_product_supplier_cubit.dart';
import 'data/blocs/new_cubit/supplier/post_product/post_add_product_supplier_cubit.dart';
import 'data/blocs/new_cubit/transaction/delete_bulk_transaction/delete_bulk_transaction_cubit.dart';
import 'data/blocs/new_cubit/transaction/fetch_transaction_menunggu_pembayaran/fetch_transaction_menunggu_pembayaran_bloc.dart';
import 'data/blocs/new_cubit/transaction/fetch_transaction_menunggu_pembayaran_detail/fetch_transaction_menunggu_pembayaran_detail_cubit.dart';
import 'data/blocs/new_cubit/transaction/fetch_transaction_supplier/fetch_transaction_supplier_cubit.dart';
import 'data/blocs/new_cubit/transaction/fetch_transaction_supplier_detail/fetch_transaction_supplier_detail_cubit.dart';
import 'data/blocs/new_cubit/transaction/transaksi_filter_status/transaksi_filter_status_cubit.dart';
import 'data/blocs/new_cubit/transaction/transaksi_filter_supplier_status/transaksi_filter_supplier_status_cubit.dart';
import 'data/blocs/new_cubit/transaction/transaksi_filter_supplier_tanggal/transaksi_filter_supplier_tanggal_cubit.dart';

final appKey = new GlobalKey<_MyAppState>();
final scaffoldMainKey = new GlobalKey<ScaffoldState>();

void main() async {
  setPathUrlStrategy();
  //For certificate_failed
  HttpOverrides.global = ApiHttpOverrides();

  // check if app run QA
  const bool isQaArgs = bool.fromEnvironment("ISQA");

  WidgetsFlutterBinding.ensureInitialized();

  bool useQaVersion;

  Bloc.observer = AppBlocObserver();

  if (!kIsWeb) {
    useQaVersion = isQaArgs || kDebugMode;
    if (useQaVersion)
      debugPrint(
        "!!! Running app in QA version, only for testing purposes !!!",
      );
  }

  if (kReleaseMode) {
    debugPrint = (String message, {int wrapWidth}) {};
  }

  // pass data to selected app flavor
  String appName;
  AppType appType;

  await DotEnv.load(fileName: ".env");
  appName = "Apmikimmdo";
  appType = AppType.apmikimmdo;

  Widget configuredApp = AAppConfig(
    appName: appName,
    appType: appType,
    isQA: useQaVersion ??= false,
    child: MyApp(),
  );

  // debug app token
  // jangan di comment
  // if (kDebugMode) {
  //   final _authRepo = AuthenticationRepository();
  //   await _authRepo.persistToken(
  //       "1|0vwmMjWZQv8RkrMo8rzAqf3DgFzCmZc05nxlGAaB" /* Farhan */
  //       // "18|UfR7YzPlx1SBbSHvrQYsVe141C4CXBSl7HOwufJl" /* Yoga */
  //       );
  // }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  await GetStorage.init();

  await initializeDateFormatting('id_ID', null)
      .then((_) => runApp(configuredApp));
}

class MyApp extends StatefulWidget {
  MyApp() : super(key: appKey);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final RecipentRepository recipentRepo = RecipentRepository();

  UserDataCubit userDataCubit;
  BottomNavCubit bottomNavCubit;
  FetchRecipentCubit fetchRecipentCubit;
  HandleTransactionRouteWebCubit handleTransactionRouteWebCubit;
  AppInfoCubit appInfoCubit;
  UiDebugSwitcherCubit uiDebugSwitcherCubit;
  bool initialized;

  @override
  void initState() {
    super.initState();

    initialized = false;

    if (!kIsWeb) {
      OneSignal.shared.setNotificationReceivedHandler(
        (OSNotification notification) {},
      );

      OneSignal.shared.setNotificationOpenedHandler(
        (OSNotificationOpenedResult result) {},
      );
    }

    appInfoCubit = AppInfoCubit()..load();
    uiDebugSwitcherCubit = UiDebugSwitcherCubit();

    userDataCubit = UserDataCubit()..appStarted();
    fetchRecipentCubit = FetchRecipentCubit();

    handleTransactionRouteWebCubit = HandleTransactionRouteWebCubit();
  }

  @override
  void didChangeDependencies() {
    if (!initialized) {
      debugPrint("initialized");

      bottomNavCubit = BottomNavCubit(
        appType: AAppConfig.of(context).appType,
      )..appLoaded();

      setState(() {
        initialized = true;
      });
    }

    super.didChangeDependencies();
  }

  final _beamerKey = GlobalKey<BeamerState>();

  @override
  Widget build(BuildContext context) {
    var config = AAppConfig.of(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => appInfoCubit),
        BlocProvider(create: (_) => uiDebugSwitcherCubit),
        BlocProvider(create: (_) => userDataCubit),
        BlocProvider(create: (_) => bottomNavCubit),
        BlocProvider(create: (_) => fetchRecipentCubit),
        BlocProvider(create: (_) => handleTransactionRouteWebCubit),
        BlocProvider(create: (ctx) => TransaksiFilterStatusCubit()),
        BlocProvider(create: (ctx) => TransaksiFilterTanggalCubit()),
        BlocProvider(create: (ctx) => TransaksiFilterKategoriCubit()),
        BlocProvider(create: (ctx) => TransaksiFilterKategoriSearchCubit()),
        BlocProvider(create: (ctx) => TransaksiUploadReviewPhotoCubit()),
        BlocProvider(create: (ctx) => FetchTransactionCubit()),
        BlocProvider(create: (ctx) => FilterProductsCubit()),
        BlocProvider(create: (ctx) => BagikanProdukCubit()),
        BlocProvider(create: (ctx) => RegisterSupplierResellerCubit()),
        BlocProvider(create: (ctx) => KecamatanSearchCubit()),
        BlocProvider(create: (ctx) => ChooseKecamatanCubit()),
        BlocProvider(create: (ctx) => AddProductSupplierCubit()),
        BlocProvider(create: (ctx) => FetchSubcategoriesCubit()),
        BlocProvider(create: (ctx) => PostAddProductSupplierCubit()),
        BlocProvider(create: (ctx) => GetProductSupplierCubit()),
        BlocProvider(create: (ctx) => FetchCartCubit()),
        BlocProvider(create: (ctx) => AddToCartOfflineCubit()),
        BlocProvider(create: (ctx) => FetchTransactionDetailCubit()),
        BlocProvider(create: (ctx) => FetchTransactionSupplierCubit()),
        BlocProvider(create: (ctx) => TransaksiFilterSupplierStatusCubit()),
        BlocProvider(create: (ctx) => TransaksiFilterSupplierTanggalCubit()),
        BlocProvider(create: (ctx) => FetchTransactionSupplierDetailCubit()),
        BlocProvider(create: (ctx) => FetchTransactionNewBloc()),
        BlocProvider(create: (ctx) => FetchTransactionMenungguPembayaranBloc()),
        BlocProvider(
            create: (ctx) => FetchTransactionMenungguPembayaranDetailCubit()),
        BlocProvider(create: (ctx) => DeleteBulkTransactionCubit()),
      ],
      child: kIsWeb
          ? GetMaterialApp.router(
              routeInformationParser: BeamerRouteInformationParser(),
              routerDelegate: RootRouterDelegate(
                guards: [
                  BeamGuard(
                    pathBlueprints: ['wpp/payment/*'],
                    check: (context, location) => false,
                    beamToNamed: '/',
                  ),
                  BeamGuard(
                    pathBlueprints: ['wpp/paymentdetail/*'],
                    check: (context, location) => false,
                    beamToNamed: '/',
                  ),
                  //=============================================================
                  //Untuk sekarang BeamGuard Payment digunakan untuk Web mode Mobile
                  // BeamGuard(
                  //   pathBlueprints: ['choosepayment/*'],
                  //   check: (context, location) =>
                  //       BlocProvider.of<HandleTransactionRouteWebCubit>(context)
                  //           .state
                  //           .checkChoosePayment,
                  //   beamToNamed: '/cart',
                  // ),
                  // BeamGuard(
                  //   pathBlueprints: ['payment/*'],
                  //   check: (context, location) =>
                  //       BlocProvider.of<HandleTransactionRouteWebCubit>(context)
                  //           .state
                  //           .checkPayment,
                  //   beamToNamed: '/cart',
                  // ),
                  // BeamGuard(
                  //   pathBlueprints: ['checkout/*'],
                  //   check: (context, location) =>
                  //       BlocProvider.of<HandleTransactionRouteWebCubit>(context)
                  //           .state
                  //           .checkCheckout,
                  //   beamToNamed: '/',
                  // ),
                  // BeamGuard(
                  //   pathBlueprints: ['paymentweb/*'],
                  //   check: (context, location) =>
                  //       BlocProvider.of<HandleTransactionRouteWebCubit>(context)
                  //           .state
                  //           .checkPaymentWeb,
                  //   beamToNamed: '/',
                  // ),
                ],
                homeBuilder: (context, uri) => Scaffold(
                  key: scaffoldMainKey,
                  body: Beamer(
                    key: _beamerKey,
                    beamLocations: [
                      HomeLocation(),
                      WarungPanenPublicLocation(),

                      // ProductDetailLocation(),
                      // AddressLocation(),
                      // CheckoutLocation(),
                      // PaymentLocation(),
                      // ============================
                      // ============================
                      // ============================
                      // AuthenticationLocation(),
                      // ProductLocation(),
                      // CartLocation(),
                      // SearchLocation(),
                      // // TransactionLocation(),
                      // CheckoutSuccessLocation(),
                      // AccountLocation(),
                      // WpHomeLocation(),
                      // WpHostLocation(),
                      // WpCartLocation(),
                      // WpShippingLocation(),
                      // InvoiceLocation(),
                    ],
                  ),
                ),
              ),
              title: config.appName,
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.pink,
                primaryColor: AppColor.DefTheme.primary,
                primaryColorBrightness: Brightness.light,
                scaffoldBackgroundColor: Colors.white,
                textSelectionTheme: TextSelectionThemeData(
                    cursorColor: AppColor.DefTheme.editTextCursor),
                visualDensity: VisualDensity.adaptivePlatformDensity,
                fontFamily: 'Poppins',
              ),
              builder: (context, child) => BlocBuilder(
                cubit: userDataCubit,
                builder: (context, state) =>
                    AppTrans.FadeThroughTransitionSwitcher(
                  fillColor: Colors.white,
                  child: state is UserDataInitial ? SplashScreen() : child,
                ),
              ),
            )
          : MaterialApp(
              title: config.appName,
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.pink,
                primaryColor: AppColor.DefTheme.primary,
                primaryColorBrightness: Brightness.dark,
                scaffoldBackgroundColor: Colors.white,
                textSelectionTheme: TextSelectionThemeData(
                    cursorColor: AppColor.DefTheme.editTextCursor),
                visualDensity: VisualDensity.adaptivePlatformDensity,
                fontFamily: 'Poppins',
              ),
              builder: (context, child) {
                return Stack(
                  children: [
                    child,
                    /* BlocBuilder<AppInfoCubit, AppInfoState>(
                      cubit: appInfoCubit,
                      builder: (context, state) => UpdateAppOverlay(
                        isShowed:
                            state is AppInfoSuccess && state.isVersionOutdated,
                      ),
                    ), */
                    if (config.isQA)
                      Overlay(
                        initialEntries: [
                          OverlayEntry(
                            builder: (context) => StatefulDragArea(
                              initialPosition: Offset(
                                Get.size.width - 50,
                                Get.size.height / 2,
                              ),
                              child: BlocBuilder<UiDebugSwitcherCubit, bool>(
                                cubit: uiDebugSwitcherCubit,
                                builder: (context, statenya) {
                                  return FloatingActionButton(
                                    elevation: statenya ? 5 : 15,
                                    backgroundColor: statenya
                                        ? AppColor.warning
                                        : Colors.white,
                                    child: Text(
                                      statenya ? "🙉 " : "🙊",
                                      style: TextStyle(fontSize: 25),
                                      textAlign: TextAlign.center,
                                    ),
                                    tooltip: "Show debug component",
                                    onPressed: uiDebugSwitcherCubit.toggle,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                );
              },
              home: BlocBuilder(
                cubit: userDataCubit,
                builder: (context, state) =>
                    AppTrans.FadeThroughTransitionSwitcher(
                  fillColor: Colors.white,
                  child:
                      state is UserDataInitial ? SplashScreen() : MainScreen(),
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    userDataCubit.close();
    bottomNavCubit.close();
    fetchRecipentCubit.close();
    handleTransactionRouteWebCubit.close();
    uiDebugSwitcherCubit.close();
    super.dispose();
  }
}

class Config {
  static final String baseUrl =
      kDebugMode ? env['BASE_URL_DEBUG'] : env['BASE_URL'];
  static final String adsKey = kDebugMode ? env['ADS_KEY'] : env['ADS_KEY'];
}

class StatefulDragArea extends StatefulWidget {
  const StatefulDragArea(
      {Key key, @required this.child, @required this.initialPosition})
      : super(key: key);

  final Widget child;
  final Offset initialPosition;

  @override
  _DragAreaStateStateful createState() => _DragAreaStateStateful();
}

class _DragAreaStateStateful extends State<StatefulDragArea> {
  Offset position;

  @override
  void initState() {
    super.initState();
    position = widget.initialPosition;
  }

  void updatePosition(Offset newPosition) =>
      setState(() => position = newPosition);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Draggable(
        maxSimultaneousDrags: 1,
        feedback: widget.child,
        childWhenDragging: SizedBox(),
        onDragEnd: (details) => updatePosition(details.offset),
        child: widget.child,
      ),
    );
  }
}
