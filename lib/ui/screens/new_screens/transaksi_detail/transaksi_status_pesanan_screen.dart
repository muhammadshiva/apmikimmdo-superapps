import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/fetch_transaction_tracking/fetch_transaction_tracking_cubit.dart';
import 'package:marketplace/data/models/new_models/tracking.dart';
import 'package:marketplace/ui/screens/new_screens/transaksi_detail/widgets/tracking/list_order_tracking_item.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/transitions.dart' as AppTrans;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:timeline_tile/timeline_tile.dart';

class TransaksiStatusPesananScreen extends StatefulWidget {
  final int orderId;

  const TransaksiStatusPesananScreen({Key key, this.orderId}) : super(key: key);

  @override
  _TransaksiStatusPesananScreenState createState() =>
      _TransaksiStatusPesananScreenState();
}

class _TransaksiStatusPesananScreenState
    extends State<TransaksiStatusPesananScreen> {
  FetchTransactionTrackingCubit _fetchTransactionTrackingCubit;

  @override
  void initState() {
    _fetchTransactionTrackingCubit = FetchTransactionTrackingCubit()..getTrackingOrder(orderId: widget.orderId);
    super.initState();
  }

  @override
  void dispose() {
    _fetchTransactionTrackingCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (_) => _fetchTransactionTrackingCubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          shadowColor: Colors.black.withOpacity(0.75),
          title: const Text("Status Pengiriman", style: AppTypo.subtitle2),
          centerTitle: true,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
        ),
        body: BlocBuilder(
          cubit: _fetchTransactionTrackingCubit,
          builder: (context, state) => AppTrans.SharedAxisTransitionSwitcher(
            transitionType: SharedAxisTransitionType.vertical,
            fillColor: Colors.transparent,
            child: state is FetchTransactionTrackingLoading
                ? Center(
                    child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            AppColor.primary)),
                  )
                : state is FetchTransactionTrackingFailure
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FlutterIcons.error_outline_mdi,
                              size: 45,
                              color: AppColor.primaryDark,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: 250,
                              child: Text(
                                "Status pesanan gagal dimuat",
                                style: AppTypo.overlineAccent,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            OutlineButton(
                              child: Text("Coba lagi"),
                              onPressed: () {},
                              textColor: AppColor.primaryDark,
                              color: AppColor.danger,
                            ),
                          ],
                        ),
                      )
                    : state is FetchTransactionTrackingSuccess
                        ?  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(thickness: 10,color: AppColor.silverFlashSale,),
                            Padding(
                              padding:  EdgeInsets.symmetric(horizontal: _screenWidth * (5/100),vertical: 14),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("No. Resi",style: AppTypo.body2Lato,),
                                  Row(
                                    children: [
                                      Text(state.data.airwaybill ?? '-',style: AppTypo.body2Lato.copyWith(fontWeight: FontWeight.bold)),
                                      SizedBox(width: 10,),
                                      Text("SALIN",style: AppTypo.body2Lato.copyWith(fontWeight: FontWeight.bold,color: AppColor.primary))
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Divider(thickness: 10,color: AppColor.silverFlashSale,),
                            Padding(
                              padding:  EdgeInsets.symmetric(horizontal: _screenWidth * (5/100),vertical: 14),
                              child: Text("Status Pemesanan",style: AppTypo.body1Lato,),
                            ),
                            Divider(thickness: 1,),
                            ListView.separated(
                              shrinkWrap: true,
                              separatorBuilder: (context,index)=>SizedBox(), 
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.only(top: 16),
                              itemCount: state.data.logs.length,
                              itemBuilder: (context,index){
                                TrackingOrderLogs data = state.data.logs[index];
                                return ListOrderTrackingItem(trackingOrderLogs: data,isStatused: index == 0,);
                              }, 
                            )
                            
                          ],
                        )
                        : SizedBox.shrink()
          ),
        ),
      ),
    );
  }
}
