import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/new_cubit/products/filter_products/filter_products_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/region/fetch_regions/fetch_regions_cubit.dart';
import 'package:marketplace/ui/widgets/edit_text.dart';
import 'package:marketplace/ui/widgets/rounded_button.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;

import 'dialog_filter_all_location.dart';

class BSFilterProduct {
  const BSFilterProduct();

  static Future show(BuildContext context,
      {bool isDismissible = true,
      Function(String sortBy, String lowPriceRange, String highPriceRange,
              String cityId)
          onFilter}) async {
    double _screenWidth = MediaQuery.of(context).size.width;
    AppExt.hideKeyboard(context);
    await showModalBottomSheet(
        isDismissible: isDismissible,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
        context: context,
        builder: (BuildContext bc) {
          return BSFilterProductItem(
            onFilter: onFilter,
          );
        });
    return;
  }
}

//Item

class BSFilterProductItem extends StatefulWidget {
  const BSFilterProductItem({Key key, @required this.onFilter})
      : super(key: key);

  final Function(String sortBy, String lowPriceRange, String highPriceRange,
      String cityId) onFilter;

  @override
  _BSFilterProductItemState createState() => _BSFilterProductItemState();
}

class _BSFilterProductItemState extends State<BSFilterProductItem> {
  final lowestPriceCtrl = TextEditingController();
  final highestPriceCtrl = TextEditingController();

  List<String> listSort = [
    "Harga Terendah",
    "Harga Tertinggi",
    "Ulasan",
    "Terbaru"
  ];

  String indexSortBySelected;
  String cityIdSelected;

  bool enableHighestPriceCtrl = false;
  bool isHighestPriceCtrlValid = true;

  @override
  void initState() {
    // _getProvince();
    super.initState();
  }

  lowestPriceCtrlOnChanged(String keyword) {
    if (lowestPriceCtrl.text.isNotEmpty) {
      setState(() {
        enableHighestPriceCtrl = true;
      });
    } else {
      setState(() {
        enableHighestPriceCtrl = false;
      });
    }
  }

  highestPriceCtrlOnChanged(String keyword) {
    if (highestPriceCtrl.text.isNotEmpty) {
      if (int.parse(highestPriceCtrl.text) < int.parse(lowestPriceCtrl.text)) {
        setState(() {
          isHighestPriceCtrlValid = false;
        });
      } else {
        setState(() {
          isHighestPriceCtrlValid = true;
        });
      }
    } else {
      isHighestPriceCtrlValid = false;
    }
  }

  bool disableButton() {
    //harus false
    final filter =
        BlocProvider.of<FilterProductsCubit>(context).state;
    final cityIdNull = filter.cityId == null;
    final sortIdNull = filter.sortId == null;

    if (isHighestPriceCtrlValid == false) {
      return true;
    } else if (lowestPriceCtrl.text.isNotEmpty) {
      return false;
    } else if (sortIdNull != null) {
      return false;
    } else if (cityIdNull != null) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: SingleChildScrollView(
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 8,
            ),
            Center(
              child: Container(
                width: _screenWidth * (15 / 100),
                height: 7,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(7.5 / 2),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Filter",
                  style: AppTypo.LatoBold,
                ),
                TextButton(
                    onPressed: () =>
                        context.read<FilterProductsCubit>().reset(),
                    child: Text(
                      "Reset",
                      style: AppTypo.LatoBold.copyWith(
                          fontSize: 12, color: AppColor.primary),
                    ))
              ],
            ),
            SizedBox(
              height: 27,
            ),
            Text("Urutkan", style: AppTypo.body1Lato),
            SizedBox(
              height: 10,
            ),
            Wrap(
              direction: Axis.horizontal,
              runSpacing: 5.0,
              spacing: 5.0,
              alignment: WrapAlignment.spaceBetween,
              children: List.generate(
                  listSort.length,
                  (index) =>
                      BlocBuilder<FilterProductsCubit, FilterProductsState>(
                        builder: (context, state) {
                          return FilterSortBy(
                            sortDataTitle: listSort[index],
                            sortDataIndex: index,
                            isSelected: index.toString() == state.sortId.toString(),
                            onTap: (data) {
                              context
                                  .read<FilterProductsCubit>()
                                  .selectUrutkan(data, listSort[index]);
                              debugPrint(data.toString());
                              setState(() {
                                indexSortBySelected = data.toString();
                              });
                            },
                          );
                        },
                      )),
            ),
            SizedBox(
              height: 15,
            ),
            Text("Harga", style: AppTypo.body1Lato),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      EditText(
                        controller: lowestPriceCtrl,
                        hintText: "",
                        inputType: InputType.price,
                        keyboardType: TextInputType.phone,
                        onChanged: lowestPriceCtrlOnChanged,
                      ),
                      //  Text("Harga lebih dari harga tertinggi")
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    width: _screenWidth * (10 / 100),
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.15),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      EditText(
                        enabled: enableHighestPriceCtrl,
                        controller: highestPriceCtrl,
                        hintText: "",
                        inputType: InputType.price,
                        keyboardType: TextInputType.phone,
                        onChanged: highestPriceCtrlOnChanged,
                      ),
                      !isHighestPriceCtrlValid
                          ? Text("Harga kurang dari harga terendah")
                          : SizedBox()
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Lokasi", style: AppTypo.body1Lato),
                // Text("Lihat Semua",
                //     style: AppTypo.LatoBold.copyWith(
                //         fontSize: 10, color: AppColor.primary)),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            FilterLocation(
              citySelected: (cityId) {
                setState(() {
                  cityIdSelected = cityId.toString();
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            RoundedButton.contained(
                label: "Tampilkan",
                disabled: disableButton(),
                textColor: AppColor.textPrimaryInverted,
                isUpperCase: false,
                onPressed: () {
                  final filter = BlocProvider.of<FilterProductsCubit>(context)
                      .state;
                  final cityId = filter.cityId;
                  final sortId = filter.sortId;
                  widget.onFilter(
                      sortId.toString(),
                      lowestPriceCtrl.text ?? '',
                      highestPriceCtrl.text ?? '',
                      cityId.toString());
                  AppExt.popScreen(context);
                }),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}

// Widget

class FilterSortBy extends StatefulWidget {
  const FilterSortBy(
      {Key key,
      this.sortDataTitle,
      this.onTap,
      this.isSelected = false,
      this.sortDataIndex})
      : super(key: key);

  final String sortDataTitle;
  final int sortDataIndex;
  final bool isSelected;
  final Function(int data) onTap;

  @override
  _FilterSortByState createState() => _FilterSortByState();
}

class _FilterSortByState extends State<FilterSortBy> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap(widget.sortDataIndex);
      },
      child: Container(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                widget.sortDataTitle,
                style: AppTypo.body1.copyWith(
                    fontSize: 10,
                    color:
                        widget.isSelected ? AppColor.primary : AppColor.grey),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
                color: widget.isSelected
                    ? AppColor.primary
                    : AppColor.silverFlashSale,
                width: 1)),
      ),
    );
  }
}

class FilterLocation extends StatefulWidget {
  const FilterLocation({Key key, this.citySelected}) : super(key: key);

  final Function(int cityId) citySelected;

  @override
  _FilterLocationState createState() => _FilterLocationState();
}

class _FilterLocationState extends State<FilterLocation> {
  int selectedProvince = 0;
  int selectedCity = 0;

  bool showProvinceSelected = false;
  String provinceNameSelected;

  bool showCitySelected = false;
  String cityNameSelected;

  FetchRegionsCubit _fetchProvinceCubit, _fetchCitiesCubit;

  @override
  void initState() {
    _fetchCitiesCubit = FetchRegionsCubit();
    _fetchProvinceCubit = FetchRegionsCubit()..fetchProvince();
    super.initState();
  }

  @override
  void dispose() {
    _fetchProvinceCubit.close();
    _fetchCitiesCubit.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provinceId =
        BlocProvider.of<FilterProductsCubit>(context).state.provinceId;
    if (provinceId != null) {
      _fetchCitiesCubit.fetchCities(provinceId: provinceId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => _fetchProvinceCubit),
        BlocProvider(create: (_) => _fetchCitiesCubit)
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Province
          BlocBuilder(
            cubit: _fetchProvinceCubit,
            builder: (context, state) {
              return state is FetchRegionsLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : state is FetchRegionsFailure
                      ? Center(
                          child: Text(state.message),
                        )
                      : state is FetchRegionsSuccess
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Provinsi", style: AppTypo.body1Lato),
                                    BlocBuilder<FilterProductsCubit,
                                        FilterProductsState>(
                                      builder: (context, filter) {
                                        return Stack(
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                DialogFilterAllLocation()
                                                    .showProvince(context,
                                                        data: state.regions,
                                                        onSelected: (_,
                                                            regionId,
                                                            regionName) {
                                                  context
                                                      .read<
                                                          FilterProductsCubit>()
                                                      .selectProvince(
                                                          regionId, regionName);
                                                  _fetchCitiesCubit.fetchCities(
                                                      provinceId: regionId);
                                                });
                                              },
                                              child: Text("Lihat Semua",
                                                  style:
                                                      AppTypo.LatoBold.copyWith(
                                                          fontSize: 12,
                                                          color: AppColor
                                                              .primary)),
                                            ),
                                            Positioned(
                                              top: 16,
                                              right: 0,
                                              child: filter.provinceId != null
                                                  ? Icon(
                                                      Icons.circle,
                                                      color: Colors.red,
                                                      size: 10,
                                                    )
                                                  : SizedBox(),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                BlocBuilder<FilterProductsCubit,
                                    FilterProductsState>(
                                  builder: (context, filter) {
                                    if (filter.provinceId != null) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Text(
                                            "Provinsi yang dipilih : ${filter.provinceName}"),
                                      );
                                    }
                                    return SizedBox(
                                      height: 10,
                                    );
                                  },
                                ),
                                GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: state.regions.length <= 12
                                        ? state.regions.length
                                        : 12,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            childAspectRatio: 3.5,
                                            crossAxisSpacing: 8,
                                            mainAxisSpacing: 8),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          if (state.regions[index].id !=
                                              selectedProvince) {
                                            context
                                                .read<FilterProductsCubit>()
                                                .selectProvince(
                                                    state.regions[index].id,
                                                    state.regions[index].name);
                                            _fetchCitiesCubit.fetchCities(
                                                provinceId:
                                                    state.regions[index].id);
                                          }
                                          setState(() {
                                            selectedProvince =
                                                state.regions[index].id;
                                            showProvinceSelected = true;
                                            provinceNameSelected =
                                                state.regions[index].name;
                                            showCitySelected = false;
                                          });
                                        },
                                        child: BlocBuilder<FilterProductsCubit,
                                            FilterProductsState>(
                                          builder: (context, filter) {
                                            return Container(
                                              padding: EdgeInsets.all(8),
                                              child: Center(
                                                child: Text(
                                                  state.regions[index].name,
                                                  style: AppTypo.body1.copyWith(
                                                      fontSize: 10,
                                                      color:
                                                          filter.provinceId ==
                                                                  state
                                                                      .regions[
                                                                          index]
                                                                      .id
                                                              ? AppColor.primary
                                                              : AppColor.grey),
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  border: Border.all(
                                                      color: filter
                                                                  .provinceId ==
                                                              state
                                                                  .regions[
                                                                      index]
                                                                  .id
                                                          ? AppColor.primary
                                                          : AppColor
                                                              .silverFlashSale,
                                                      width: 1)),
                                            );
                                          },
                                        ),
                                      );
                                    }),
                              ],
                            )
                          : SizedBox.shrink();
            },
          ),
          SizedBox(
            height: 20,
          ),
          //Cities
          BlocBuilder(
            cubit: _fetchCitiesCubit,
            builder: (context, state) {
              return state is FetchRegionsLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : state is FetchRegionsFailure
                      ? Center(
                          child: Text(state.message),
                        )
                      : state is FetchRegionsSuccess
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Kota", style: AppTypo.body1Lato),
                                    TextButton(
                                        onPressed: () {
                                          DialogFilterAllLocation().showCities(
                                              context,
                                              data: state.regions, onSelected:
                                                  (_, regionId, regionName) {
                                            context
                                                .read<FilterProductsCubit>()
                                                .selectCity(
                                                    regionId, regionName);
                                            AppExt.popScreen(context);
                                          });
                                        },
                                        child: Text("Lihat Semua",
                                            style: AppTypo.LatoBold.copyWith(
                                                fontSize: 10,
                                                color: AppColor.primary))),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: BlocBuilder<FilterProductsCubit,
                                      FilterProductsState>(
                                    builder: (context, state) {
                                      if (state.cityId != null) {
                                        return Text(
                                            "Kota yang dipilih : ${state.cityName}");
                                      }
                                      return SizedBox();
                                    },
                                  ),
                                ),
                                GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: state.regions.length <= 12
                                        ? state.regions.length
                                        : 12,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            childAspectRatio: 3.5,
                                            crossAxisSpacing: 8,
                                            mainAxisSpacing: 8),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          context
                                              .read<FilterProductsCubit>()
                                              .selectCity(
                                                  state.regions[index].id,
                                                  state.regions[index].name);
                                          setState(() {
                                            selectedCity =
                                                state.regions[index].id;
                                            showCitySelected = true;
                                            cityNameSelected =
                                                state.regions[index].name;
                                          });
                                          widget.citySelected(
                                              state.regions[index].id);
                                        },
                                        child: BlocBuilder<FilterProductsCubit,
                                            FilterProductsState>(
                                          builder: (context, filter) {
                                            return Container(
                                              padding: EdgeInsets.all(8),
                                              child: Center(
                                                child: Text(
                                                  AppExt.kabupatenToKab(state
                                                      .regions[index].name),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: AppTypo.body1.copyWith(
                                                      fontSize: 10,
                                                      color: filter.cityId ==
                                                              state
                                                                  .regions[
                                                                      index]
                                                                  .id
                                                          ? AppColor.primary
                                                          : AppColor.grey),
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  border: Border.all(
                                                      color: filter.cityId ==
                                                              state
                                                                  .regions[
                                                                      index]
                                                                  .id
                                                          ? AppColor.primary
                                                          : AppColor
                                                              .silverFlashSale,
                                                      width: 1)),
                                            );
                                          },
                                        ),
                                      );
                                    }),
                              ],
                            )
                          : SizedBox.shrink();
            },
          )
        ],
      ),
    );
  }
}

//  setState(() {
//                 if (value) {
//                   locationSelected.add(listLocation[index]);
//                 } else {
//                   locationSelected.remove(listLocation[index]);
//                 }
//               });
