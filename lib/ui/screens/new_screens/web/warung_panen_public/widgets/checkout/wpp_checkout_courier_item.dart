import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:marketplace/data/blocs/new_cubit/shipping/fetch_shipping_options/fetch_shipping_options_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/models/new_models/new_cart.dart';
import 'package:marketplace/data/repositories/repositories.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/constants.dart' as AppConst;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/transitions.dart' as AppTrans;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class WppCheckoutCourierItem extends StatefulWidget {
  const WppCheckoutCourierItem({
    Key key,
    this.supplierId,
    this.cart,
    this.recipentId,
    this.productId,
    this.onChoose,
    this.enableCourier = true,
  }) : super(key: key);

  final int supplierId, recipentId, productId;
  final List<NewCart> cart;
  final bool enableCourier;
  final Function(int courierId, int shippingPrice, String name) onChoose;

  @override
  _WppCheckoutCourierItemState createState() => _WppCheckoutCourierItemState();
}

class _WppCheckoutCourierItemState extends State<WppCheckoutCourierItem> {
  final RecipentRepository _recipentRepo = RecipentRepository();
  FetchShippingOptionsCubit _fetchShippingOptionsCubit; //For List Kurir

  int _selectedCourierId;

  @override
  void initState() {
    _fetchShippingOptionsCubit = FetchShippingOptionsCubit()
      ..load(
        totalWeight: widget.cart.fold(
          0,
          (previousValue, element) =>
              previousValue +
              element.product.fold(
                  0,
                  (previousValue, element) =>
                      previousValue + element.weight * element.quantity),
        ),
        subdistrictId:
            _recipentRepo.getSelectedRecipentNoAuth()['subdistrict_id'],
        supplierId: widget.supplierId,
        productId: widget.cart[0].product[0].id,
      );
    super.initState();
  }

  // void _loadCourierOptions() {
  //   // product weight --> to be updated
  //   final int totalWeight = widget.cart.fold(
  //     0,
  //     (previousValue, element) =>
  //         previousValue + (element.weight * element.quantity),
  //   );

  //   _fetchShippingOptionsCubit.load(
  //       totalWeight: totalWeight,
  //       recipentId: widget.recipentId,
  //       productId: widget.cart.map((e) => e.id).toList());
  // }

  @override
  void dispose() {
    _fetchShippingOptionsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => _fetchShippingOptionsCubit,
        child: BlocBuilder(
            cubit: _fetchShippingOptionsCubit,
            builder: (context, fetchShippingOptionsState) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Kurir Pengiriman',
                      style: AppTypo.subtitle1
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Stack(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: AppColor.line, width: 1),
                              borderRadius: BorderRadius.circular(7.5),
                            ),
                            child: ListTile(
                              enabled: widget.enableCourier,
                              onTap: fetchShippingOptionsState
                                      is FetchShippingOptionsSuccess
                                  ? () {
                                      _showCourierChoices(context,
                                          items: fetchShippingOptionsState.data,
                                          onSelected: (id, price, name) {
                                        setState(() {
                                          _selectedCourierId = id;
                                        });
                                        widget.onChoose(id, price, name);
                                      });
                                    }
                                  : null,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.5),
                              ),
                              title: Text(
                                _selectedCourierId != null &&
                                        fetchShippingOptionsState
                                            is FetchShippingOptionsSuccess
                                    ? "${fetchShippingOptionsState.data[_selectedCourierId].name}"
                                    : "Pilih Kurir",
                                style: AppTypo.body2.copyWith(
                                  fontWeight: _selectedCourierId == null
                                      ? FontWeight.w500
                                      : FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: kIsWeb ? null : 1,
                              ),
                              subtitle: _selectedCourierId != null &&
                                      fetchShippingOptionsState
                                          is FetchShippingOptionsSuccess
                                  ? fetchShippingOptionsState
                                              .data[_selectedCourierId].etd !=
                                          null
                                      ? Text(
                                          "${fetchShippingOptionsState.data[_selectedCourierId].etd}",
                                          style: AppTypo.overlineAccent,
                                        )
                                      : null
                                  : null,
                              trailing: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _selectedCourierId != null &&
                                          fetchShippingOptionsState
                                              is FetchShippingOptionsSuccess
                                      ? Text(
                                          "Rp ${AppExt.toRupiah(fetchShippingOptionsState.data[_selectedCourierId].price)}",
                                        )
                                      : SizedBox.shrink(),
                                  Icon(Icons.chevron_right),
                                ],
                              ),
                            )),
                        Positioned.fill(
                          child: fetchShippingOptionsState
                                  is FetchShippingOptionsSuccess
                              ? SizedBox.shrink()
                              : Material(
                                  color:
                                      AppColor.navScaffoldBg.withOpacity(0.6),
                                ),
                        ),
                        fetchShippingOptionsState is FetchShippingOptionsLoading
                            ? Positioned.fill(
                                child: Center(
                                  child: SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation(
                                              AppColor.success))),
                                ),
                              )
                            : SizedBox.shrink()
                      ],
                    )
                  ]);
            }));
  }

  void _showCourierChoices(
    context, {
    @required void Function(int id, int price, String name) onSelected,
    @required List<ShippingOptionItem> items,
  }) {
    final double _screenWidth = MediaQuery.of(context).size.width;
    final double _screenHeight = MediaQuery.of(context).size.height;
    final double _statusHeight = MediaQuery.of(context).padding.top;

    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
      builder: (BuildContext bc) {
        return Container(
          padding: EdgeInsets.only(bottom: 15),
          constraints: BoxConstraints(maxHeight: _screenHeight * (75 / 100)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                width: _screenWidth * (15 / 100),
                height: 7,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(7.5 / 2),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Divider(
                height: 0.7,
                thickness: 0.7,
              ),
              Flexible(
                child: ListView.separated(
                    // physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(
                        horizontal: _screenWidth * (5 / 100)),
                    itemBuilder: (context, index) {
                      ShippingOptionItem item = items[index];
                      return ListTile(
                        contentPadding: EdgeInsets.all(0),
                        title: Text(
                          "${item.name}",
                          style: AppTypo.body2
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(
                            "Rp ${AppExt.toRupiah(item.price)}  ${item.etd}",
                            style: AppTypo.overline),
                        trailing: _selectedCourierId == index
                            ? Icon(FlutterIcons.check_mco)
                            : null,
                        onTap: () {
                          onSelected(index, item.price, item.name);
                          Navigator.pop(context);
                        },
                        // visualDensity: VisualDensity.compact,
                      );
                    },
                    separatorBuilder: (_, index) {
                      return Divider(
                        height: 0.5,
                        thickness: 0.5,
                        color: Colors.grey[300],
                      );
                    },
                    itemCount: items.length),
              ),
            ],
          ),
        );
      },
    );
  }
}
