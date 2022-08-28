import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/new_cubit/products/filter_products/filter_products_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/region/fetch_regions/fetch_regions_cubit.dart';
import 'package:marketplace/data/models/new_models/region.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:meta/meta.dart';

class DialogFilterAllLocation {
  void showProvince(BuildContext context,
      {List<Region> data, Function(bool, int, String) onSelected}) {
    showDialog(
        context: context,
        builder: (context) {
          return _DialogFilterAllLocationProvince(
            regions: data,
            onSelected: onSelected,
          );
        });
  }

  void showCities(BuildContext context,
      {List<Region> data, Function(bool, int, String) onSelected}) {
    showDialog(
        context: context,
        builder: (context) {
          return _DialogFilterAllLocationCities(
            regions: data,
            onSelected: onSelected,
          );
        });
  }
}

class _DialogFilterAllLocationProvince extends StatelessWidget {
  const _DialogFilterAllLocationProvince(
      {Key key, @required this.regions, @required this.onSelected})
      : super(key: key);

  final List<Region> regions;
  final Function(bool, int, String) onSelected;


  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pilih Lokasi Provinsi", style: AppTypo.body1.copyWith(fontSize: 14, fontWeight: FontWeight.w800),),
            SizedBox(height: 16,),
            Wrap(
              spacing: 8,
              children: [
                for (var region in regions)
                  BlocBuilder<FilterProductsCubit,
                      FilterProductsState>(
                    builder: (context, filter) {
                      return ChoiceChip(
                        backgroundColor: Colors.white,
                        shape: StadiumBorder(side: BorderSide(color: AppColor.appPrimary)),
                        label: Text(
                          region.name,
                          style: AppTypo.body1.copyWith(fontSize: 10,),
                        ),
                        selected: filter.provinceId == region.id,
                        onSelected: (value) => onSelected(value, region.id, region.name),
                      );
                    },
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogFilterAllLocationCities extends StatelessWidget {
  const _DialogFilterAllLocationCities(
      {Key key, @required this.regions, @required this.onSelected})
      : super(key: key);

  final List<Region> regions;
  final Function(bool, int, String) onSelected;


  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pilih Lokasi Kota", style: AppTypo.body1.copyWith(fontSize: 14, fontWeight: FontWeight.w800),),
            SizedBox(height: 16,),
            Wrap(
              spacing: 8,
              children: [
                for (var region in regions)
                  BlocBuilder<FilterProductsCubit,
                      FilterProductsState>(
                    builder: (context, filter) {
                      return ChoiceChip(
                        backgroundColor: Colors.white,
                        shape: StadiumBorder(side: BorderSide(color: AppColor.appPrimary)),
                        label: Text(
                          region.name,
                          style: AppTypo.body1.copyWith(fontSize: 10,),
                        ),
                        selected: filter.cityId == region.id,
                        onSelected: (value) => onSelected(value, region.id, region.name),
                      );
                    },
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
