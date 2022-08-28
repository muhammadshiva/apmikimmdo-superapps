import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/bottom_nav/bottom_nav_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/fetch_transaction_menunggu_pembayaran/fetch_transaction_menunggu_pembayaran_bloc.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/models/new_models/order.dart';
import 'package:marketplace/ui/screens/nav/new/transaksi/widgets/transaction_menunggu_pembayaran_item.dart';
import 'package:marketplace/ui/screens/new_screens/cart_screen/cart_screen.dart';
import 'package:marketplace/ui/screens/new_screens/search/search_screen.dart';
import 'package:marketplace/ui/widgets/edit_text.dart';
import 'package:marketplace/ui/widgets/fetch_conditions.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;

import '../../../sign_in_screen.dart';

class TransaksiMenungguPembayaranScreen extends StatefulWidget {
  const TransaksiMenungguPembayaranScreen({Key key}) : super(key: key);

  @override
  _TransaksiMenungguPembayaranScreenState createState() =>
      _TransaksiMenungguPembayaranScreenState();
}

class _TransaksiMenungguPembayaranScreenState
    extends State<TransaksiMenungguPembayaranScreen> {

  @override
  void initState() {
    context
        .read<FetchTransactionMenungguPembayaranBloc>()
        .add(TransactionMenungguPembayaranFetched());
    super.initState();
  }

  Future<void> _refresh(BuildContext context) async {
    context
        .read<FetchTransactionMenungguPembayaranBloc>()
        .add(TransactionMenungguPembayaranFetched());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // brightness: Brightness.dark,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: Padding(
            padding:
                const EdgeInsets.only(bottom: 11, top: 4, left: 10, right: 10),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                AppExt.popScreen(context);
              },
            )),
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
                  iconSize: 28,
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
                  padding: EdgeInsets.only(top: 10, right: 12),
                  constraints: BoxConstraints(),
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                  ),
                  iconSize: 28,
                  onPressed: () {
                    AppExt.pushScreen(
                      context,
                      BlocProvider.of<UserDataCubit>(context).state.user != null
                          ? CartScreen()
                          : SignInScreen(),
                    );
                  }),
              BlocProvider.of<UserDataCubit>(context).state.countCart != null &&
                      BlocProvider.of<UserDataCubit>(context).state.countCart >
                          0
                  ? new Positioned(
                      right: 8,
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: BlocBuilder<FetchTransactionMenungguPembayaranBloc,
              FetchTransactionMenungguPembayaranState>(
            builder: (context, state) {
              if (state is FetchTransactionMenungguPembayaranSuccess) {
                final order = state.order;
                if (order.isEmpty) {
                  return _emptyData(context);
                }
                return _body(context, order);
              }
              if (state
                  is FetchTransactionMenungguPembayaranSuccessAfterDelete) {
                final order = state.order;
                if (order.isEmpty) {
                  return _emptyData(context);
                }
                return _body(context, order);
              }
              if (state is FetchTransactionMenungguPembayaranLoading) {
                return Center(child: CircularProgressIndicator());
              }
              return SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Center _emptyData(BuildContext context) {
    return Center(
      child: EmptyData(
        title: "Transaksi anda kosong",
        subtitle: "Silahkan pilih produk yang anda inginkan untuk mengisinya",
        labelBtn: "Mulai Belanja",
        onClick: () {
          BlocProvider.of<BottomNavCubit>(context).navItemTapped(0);
          AppExt.popUntilRoot(context);
        },
      ),
    );
  }

  Widget _body(BuildContext context, List<OrderMenungguPembayaranData> order) {
    return RefreshIndicator(
      onRefresh: () => _refresh(context),
      child: ListView.separated(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: order.length,
        itemBuilder: (context, index) {
          return TransaksiMenungguPembayaranItem(
            item: order[index],
          );
        },
        separatorBuilder: (context, _) => SizedBox(
          height: 16,
        ),
      ),
    );
  }
}
