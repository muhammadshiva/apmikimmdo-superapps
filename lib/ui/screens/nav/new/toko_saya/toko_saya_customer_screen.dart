import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/new_cubit/reseller_shop/fetch_customers_shop/fetch_customers_shop_cubit.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/ui/screens/nav/new/toko_saya/widget/list_customer_item.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/constants.dart' as AppConst;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/transitions.dart' as AppTrans;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class MyShopCustomerScreen extends StatefulWidget {
  const MyShopCustomerScreen({Key key}) : super(key: key);

  @override
  State<MyShopCustomerScreen> createState() => _MyShopCustomerScreenState();
}

class _MyShopCustomerScreenState extends State<MyShopCustomerScreen> {
  FetchCustomersShopCubit _fetchCustomersShopCubit;

  //Dummy Data
  // List<TokoSayaCustomer> customers = [
  //   TokoSayaCustomer(name: "Budi", phone: "628223514213", subdistrict: "Madyopuro"),
  //   TokoSayaCustomer(name: "Ani", phone: "628223514213", subdistrict: "Madyopuro"),
  //   TokoSayaCustomer(name: "Didi", phone: "628223514213", subdistrict: "Madyopuro"),
  //   TokoSayaCustomer(name: "Siti", phone: "628223514213", subdistrict: "Madyopuro"),
  // ];

  @override
  void initState() {
    _fetchCustomersShopCubit = FetchCustomersShopCubit()..fetchCustomers();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;
    final userDataCubit = BlocProvider.of<UserDataCubit>(context).state.user;

    return BlocProvider(
      create: (context) => _fetchCustomersShopCubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Daftar Pelanggan",
            style: AppTypo.body1Lato,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: BlocBuilder<FetchCustomersShopCubit, FetchCustomersShopState>(
          builder: (context, state) {
            return
            state is FetchCustomersShopLoading ?
            Center(child: CircularProgressIndicator(),) :
            state is FetchCustomersShopFailure ?
            Center(child: Text("Terjadi kesalahan"),) :
            state is FetchCustomersShopSuccess  ? 
             Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: ListView.separated(
                    padding: EdgeInsets.only(
                        top: 10,
                        left: _screenWidth * (5 / 100),
                        right: _screenWidth * (5 / 100)),
                    physics: BouncingScrollPhysics(),
                    separatorBuilder: (ctx, idx) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 2),
                      child: Divider(),
                    ),
                    itemCount: state.customers.length,
                    itemBuilder: (ctx, idx) {
                      return ListCustomerItem(
                        customer: state.customers[idx],
                      );
                    },
                  ),
                ),
                //Header
                Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: _screenWidth * (5 / 100)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Warung - ${userDataCubit.reseller.name}",
                                style: AppTypo.subtitle2.copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w700)),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              "Kec. ${userDataCubit.reseller.subdistrict}, ${userDataCubit.reseller.city}, ${userDataCubit.reseller.province}",
                              style: AppTypo.body1Lato,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: _screenWidth * (5 / 100), vertical: 6),
                        color: AppColor.navScaffoldBg,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Pelanggan",
                              style: AppTypo.subtitle2
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(state.customers.length.toString(),
                                style: AppTypo.subtitle2
                                    .copyWith(fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ) : SizedBox();
          },
        ),
      ),
    );
  }
}
