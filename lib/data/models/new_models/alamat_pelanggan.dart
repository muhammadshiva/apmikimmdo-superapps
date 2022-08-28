import 'package:marketplace/data/models/models.dart';

class AlamatPelanggan {
  final String nama;
  final String telepon;
  final String alamat;
  final String email;
  final String kecamatan;
  final int idKecamatan;

  const AlamatPelanggan({
    this.nama,
    this.telepon,
    this.alamat,
    this.email,
    this.kecamatan,
    this.idKecamatan,
  });

  factory AlamatPelanggan.fromJson(Map<String, dynamic> json) => AlamatPelanggan(
    nama: json["nama"],
    telepon: json["telepon"],
    alamat: json["alamat"],
    email: json["email"],
    kecamatan: json["kecamatan"],
    idKecamatan: json["idKecamatan"],
  );

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'telepon': telepon,
      'alamat': alamat,
      'email':email,
      'kecamatan':kecamatan,
      'idKecamatan':idKecamatan
    };
  }

}


class AlamatPelangganWithCart {
  final String nama;
  final String telepon;
  final String alamat;
  final String email;
  final String kecamatan;
  final int idKecamatan;
  final List<NewCart> newCart;

  const AlamatPelangganWithCart({
    this.nama,
    this.telepon,
    this.alamat,
    this.email,
    this.kecamatan,
    this.idKecamatan,
    this.newCart
  });

  factory AlamatPelangganWithCart.fromJson(Map<String, dynamic> json) => AlamatPelangganWithCart(
    nama: json["nama"],
    telepon: json["telepon"],
    alamat: json["alamat"],
    email: json["email"],
    kecamatan: json["kecamatan"],
    idKecamatan: json["id_Kecamatan"],
    newCart: json["new_cart"] == null ?
    [] : List<NewCart>.from(
                    json["new_cart"].map((x) => NewCart.fromJson(x))),
  );

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'telepon': telepon,
      'alamat': alamat,
      'email':email,
      'kecamatan':kecamatan,
      'id_Kecamatan':idKecamatan,
      'new_cart':newCart
    };
  }

}