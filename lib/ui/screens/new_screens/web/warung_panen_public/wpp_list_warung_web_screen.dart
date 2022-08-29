import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/new_cubit/reseller_shop/fetch_data_reseller_shop/fetch_data_reseller_shop_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/repositories.dart';

import 'package:marketplace/ui/widgets/fetch_conditions.dart';
import 'package:beamer/beamer.dart';
import 'package:get/get.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/images.dart' as AppImg;

class WppListWarungWebScreen extends StatefulWidget {
  const WppListWarungWebScreen({Key key, this.subdistrictId}) : super(key: key);

  final int subdistrictId;

  @override
  State<WppListWarungWebScreen> createState() => _WppListWarungWebScreenState();
}

class _WppListWarungWebScreenState extends State<WppListWarungWebScreen> {
  FetchDataResellerShopCubit _fetchDataResellerShopCubit;
  JoinUserRepository _repo = JoinUserRepository();

  TextEditingController _searchController = TextEditingController(text: "");
  FocusNode _focusNode = FocusNode();
  Timer _debounce;

  @override
  void initState() {
    _fetchDataResellerShopCubit = FetchDataResellerShopCubit()
      ..fetchListWarungBySubdistrictId(subdistrictId: widget.subdistrictId,keyword: null);
    super.initState();
  }

  @override
  void dispose() {
    _fetchDataResellerShopCubit.close();
    super.dispose();
  }

  _onSearchChanged(String keyword) {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () {
      AppExt.hideKeyboard(context);
      if (keyword.isNotEmpty) {
        _fetchDataResellerShopCubit.fetchListWarungBySubdistrictId(subdistrictId: widget.subdistrictId,keyword: keyword);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _fetchDataResellerShopCubit,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: !context.isPhone ? 450 : 1000),
          child: Scaffold(
            backgroundColor: Color(0xFFF7F7F7),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => context.beamToNamed('/'),
                  child: Icon(Icons.arrow_back)),
              ),
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text("Reseller",style: AppTypo.LatoBold.copyWith(fontSize: 18)),
              elevation: 2,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(80),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: EditText(
                          controller: _searchController,
                          hintText: "Cari reseller ...",
                          inputType: InputType.search,
                          focusNode: _focusNode,
                          onChanged: this._onSearchChanged,
                        ),
                      ),
                    ),
                    SizedBox(height: 20,)
                  ],
                ),
              ),
            ),
            body: Container(
                child: BlocBuilder(
                    cubit: _fetchDataResellerShopCubit,
                    builder: (context, state) => state
                            is FetchDataResellerShopLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : state is FetchDataResellerShopFailure
                            ? Center(
                                child: Text("terjadi kesalahan"),
                              )
                            : state is FetchDataResellerShopSuccess
                                ? state.listWarung.length > 0
                                    ? ListView.separated(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 18),
                                        separatorBuilder: (ctx, idx) => SizedBox(height: 8,),
                                        itemCount: state.listWarung.length,
                                        itemBuilder: (context, index) {
                                          Reseller warung = state.listWarung[index];
                                          return MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: GestureDetector(
                                                onTap: () {
                                                  _repo.setSlugReseller(slug: warung.slug);
                                                  context.beamToNamed(
                                                      '/wpp/dashboard/${warung.slug}',data: {
                                                        'isFromListWarung' : true
                                                      });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(15),
                                                  child: buildCardItem(warung),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(10)
                                                  ),
                                                )),
                                          );
                                        })
                                    : Center(
                                        child: EmptyData(
                                            title: "Reseller tidak ditemukan",
                                            subtitle:
                                                "Belum ada reseller pada wilayah ini"))
                                : SizedBox())),
          ),
        ),
      ),
    );
  }

  Widget buildCardItem(Reseller data){
     return Row(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(data.logo),radius: 30,),
          SizedBox(width: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data.name,style: AppTypo.LatoBold,),
              SizedBox(height: 6,),
              Text("${data.subdistrict}, ${data.city}",style: AppTypo.body1Lato.copyWith(color: AppColor.grey),),
              SizedBox(height: 6,),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 8),
                    child: Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        SizedBox(width: 5),
                        Text(data.rating.toString())
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border(
            left: BorderSide(width: 1, color:AppColor.silverFlashSale),
            right: BorderSide(width: 1  , color: AppColor.silverFlashSale),
          ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.storage, color: AppColor.grey, size: 18),
                        SizedBox(width: 5),
                        Text(data.totalProduct.toString())
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Icon(Icons.group, color: AppColor.grey, size: 18),
                        SizedBox(width: 5),
                        Text(data.customer.toString())
                      ],
                    ),
                  )
                ],
              )
            ],
          )
        ],
      );
  }
}
