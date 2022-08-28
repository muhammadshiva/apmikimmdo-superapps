import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/blocs/bottom_nav/bottom_nav_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/fetch_transaction_supplier/fetch_transaction_supplier_cubit.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/ui/screens/new_screens/transaksi_supplier/widgets/filter_supplier_list.dart';
import 'package:marketplace/ui/screens/new_screens/cart_screen/cart_screen.dart';
import 'package:marketplace/ui/screens/new_screens/search/search_screen.dart';
import 'package:marketplace/ui/screens/new_screens/transaksi_supplier/widgets/transaksi_supplier_item.dart';
import 'package:marketplace/ui/screens/sign_in_screen.dart';
import 'package:marketplace/ui/widgets/edit_text.dart';
import 'package:marketplace/ui/widgets/fetch_conditions.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/colors.dart' as AppColor;


class TransaksiSupplierScreen extends StatefulWidget {
  const TransaksiSupplierScreen({Key key}) : super(key: key);

  @override
  _TransaksiSupplierScreenState createState() => _TransaksiSupplierScreenState();
}

class _TransaksiSupplierScreenState extends State<TransaksiSupplierScreen> {

  @override
  void initState() {
    super.initState();
    context.read<FetchTransactionSupplierCubit>().fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: Padding(
            padding: const EdgeInsets.only(
                bottom: 11, top: 4, left: 10, right: 10),
            child: Icon(Icons.arrow_back, color: Colors.black)),
        titleSpacing: 0,
        title: Container(
          height: 50,
          alignment: Alignment.center,
          child: EditText(
            hintText: "Cari Transaksi",
            inputType: InputType.search,
            readOnly: true,
            onTap: () => AppExt.pushScreen(context, SearchScreen()),
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                  padding: EdgeInsets.only(left: 5, top: 10, right: 12),
                  constraints: BoxConstraints(),
                  icon: Icon(Icons.notifications, color: Colors.black),
                  splashRadius: 2,
                  onPressed: () {
                    // AppExt.pushScreen(
                    //   context,
                    //   BlocProvider.of<UserDataCubit>(context).state.user != null
                    //       ? CartScreen()
                    //       : SignInScreen(),
                    // );
                  }),
            ],
          ),
          Stack(
            children: [
              IconButton(
                  padding: EdgeInsets.only(top: 10, right: 10),
                  constraints: BoxConstraints(),
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    AppExt.pushScreen(
                      context,
                      BlocProvider.of<UserDataCubit>(context).state.user !=
                          null
                          ? CartScreen()
                          : SignInScreen(),
                    );
                  }),
              BlocProvider.of<UserDataCubit>(context).state.countCart !=
                  null &&
                  BlocProvider.of<UserDataCubit>(context)
                      .state
                      .countCart >
                      0
                  ? new Positioned(
                right: 6,
                top: -10,
                child: Chip(
                  shape: CircleBorder(side: BorderSide.none),
                  backgroundColor: AppColor.red,
                  padding: EdgeInsets.zero,
                  labelPadding: BlocProvider.of<UserDataCubit>(context)
                      .state
                      .countCart >
                      99
                      ? EdgeInsets.all(2)
                      : EdgeInsets.all(4),
                  label: Text(
                    "${BlocProvider.of<UserDataCubit>(context).state.countCart}",
                    style: AppTypo.overlineInv.copyWith(fontSize: 8),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
                  : SizedBox.shrink(),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              SizedBox(
                height: 50,
                child: FilterSupplierList(),
              ),
              Expanded(
                child:
                BlocBuilder<FetchTransactionSupplierCubit, FetchTransactionSupplierState>(
                  builder: (context, state) {
                    if (state is FetchTransactionSupplierSuccess) {
                      if (state.order.isEmpty) {
                        return Center(
                          child: EmptyData(
                            title: "Transaksi anda kosong",
                            subtitle:
                            "Silahkan pilih produk yang anda inginkan untuk mengisinya",
                            labelBtn: "Mulai Belanja",
                            onClick: () {
                              BlocProvider.of<BottomNavCubit>(context)
                                  .navItemTapped(0);
                              AppExt.popUntilRoot(context);
                            },
                          ),
                        );
                      }
                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<FetchTransactionSupplierCubit>().fetch();
                        },
                        child: ListView.separated(
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: state.order.length,
                          itemBuilder: (context, index) {
                            return TransaksiSupplierItem(
                              isSupplier: true,
                              item: state.order[index],
                            );
                          },
                          separatorBuilder: (context, _) => SizedBox(
                            height: 16,
                          ),
                        ),
                      );
                    }
                    if (state is FetchTransactionSupplierFailure) {
                      if (state.type == ErrorType.server)
                        return Center(
                          child: ErrorFetch(
                            message: state.message,
                            onButtonPressed: () {
                              context.read<FetchTransactionSupplierCubit>().fetch();
                            },
                          ),
                        );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}