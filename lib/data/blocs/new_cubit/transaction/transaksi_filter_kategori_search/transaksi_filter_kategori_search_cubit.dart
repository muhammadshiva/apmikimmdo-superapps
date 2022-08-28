import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'transaksi_filter_kategori_search_state.dart';

class TransaksiFilterKategoriSearchCubit extends Cubit<Map<String, String>> {
  TransaksiFilterKategoriSearchCubit() : super(init);

  static Map<String, String> init = {
    "images/icons/ic_bisniso_category.svg": "Semua Kategori",
    "images/icons/ic_tshirt.svg": "Fashion",
    "images/icons/ic_kerajinan.svg": "Kerajinan",
    "images/icons/ic_rumah_tangga.svg": "Rumah Tangga",
    "images/icons/ic_perawatan.svg": "Perawatan Tubuh",
    "images/icons/ic_fashion_wanita.svg": "Fashion Wanita",
    "images/icons/ic_fashion_muslim.svg": "Fashion Muslim",
    "images/icons/ic_fashion_anak.svg": "Fashion Anak",
    "images/icons/ic_kecantikan.svg": "Kecantikan",
    "images/icons/ic_makanan_minuman.svg": "Makanan & Minuman"
  };

  void reset() => emit(init);

  void search(String search) {
   if (search.isEmpty){
   } else {
     emit(Map<String, String>.from(init)
       ..removeWhere(
               (key, value) => !value.toLowerCase().contains(search.toLowerCase())));
   }
  }
}
