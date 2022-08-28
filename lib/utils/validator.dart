class ValidatorCustom {
// Add product catering
  String vNameCatering(String value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Nama paket harus diisi";
    }
    return null;
  }

  String vUnit(String value) {
    if (value.length == 0) {
      return "Unit harus diisi";
    }
    return null;
  }

  String vPrice(String value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Harga harus diisi";
    } else if (!regExp.hasMatch(value)) {
      return "Harga harus berupa angka";
    }
    return null;
  }

  String vStock(String value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Stok harus diisi";
    } else if (!regExp.hasMatch(value)) {
      return "Stok harus berupa angka";
    }
    return null;
  }

  String vWeight(String value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Berat harus diisi";
    } else if (!regExp.hasMatch(value)) {
      return "Berat harus berupa angka";
    }
    return null;
  }

//SHOP ADD PRODUCT
  String vNameShopProduct(String value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Nama produk harus diisi";
    }
    // else if (!regExp.hasMatch(value)) {
    //   return "Nama produk harus memiliki bentuk a-z atau A-Z";
    // }
    return null;
  }

  String vUnitShopProduct(String value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Unit produk harus diisi";
    }
    // else if (!regExp.hasMatch(value)) {
    //   return "Nama produk harus memiliki bentuk a-z atau A-Z";
    // }
    return null;
  }

  String vCategoryShopProduct(String value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Kategori harus diisi";
    }
    // else if (!regExp.hasMatch(value)) {
    //   return "Nama produk harus memiliki bentuk a-z atau A-Z";
    // }
    return null;
  }

  String vPriceShopProduct(String value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Harga produk harus diisi";
    } else if (!regExp.hasMatch(value)) {
      return "Harga produk harus berupa angka";
    }
    return null;
  }

  String vStockShopProduct(String value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Stok produk harus diisi";
    } else if (!regExp.hasMatch(value)) {
      return "Stok produk harus berupa angka";
    }
    return null;
  }

  String vWeightShopProduct(String value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Berat produk harus diisi";
    } else if (!regExp.hasMatch(value)) {
      return "Berat produk harus berupa angka";
    }
    return null;
  }

  String vDescriptionShopProduct(String value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Deskripsi produk harus diisi";
    }
    // else if (!regExp.hasMatch(value)) {
    //   return "Nama produk harus memiliki bentuk a-z atau A-Z";
    // }
    return null;
  }

  String vCopywritingProduct(String value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Copywriting produk harus diisi";
    }
    // else if (!regExp.hasMatch(value)) {
    //   return "Nama produk harus memiliki bentuk a-z atau A-Z";
    // }
    return null;
  }

  String vMinBuyGrocir(String value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Min pembelian harus diisi";
    } else if (!regExp.hasMatch(value)) {
      return "Min pembelian harus berupa angka";
    }
    return null;
  }

  String vMinBuyGrocirNullable(String value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return "Min pembelian harus berupa angka";
    }
    return null;
  }

  String vMaxBuyGrocir(String value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Max pembelian harus diisi";
    } else if (!regExp.hasMatch(value)) {
      return "Max pembelian harus berupa angka";
    }
    return null;
  }

  String vPriceGrocir(String value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Harga grosir harus diisi";
    } else if (!regExp.hasMatch(value)) {
      return "Harga grosir harus berupa angka";
    }
    return null;
  }

  String vPriceGrocirNullable(String value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return "Harga grosir harus berupa angka";
    }
    return null;
  }

  //SHOP DATA & ACCOUNT PROFILE
  String vNameShop(String value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Nama toko harus diisi";
    }
    // else if (!regExp.hasMatch(value)) {
    //   return "Nama produk harus memiliki bentuk a-z atau A-Z";
    // }
    return null;
  }

  String vAddress(String value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Detail Alamat harus diisi";
    }
    // else if (!regExp.hasMatch(value)) {
    //   return "Nama produk harus memiliki bentuk a-z atau A-Z";
    // }
    return null;
  }

  String vProvinceShop(String value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Provinsi harus diisi";
    }
    // else if (!regExp.hasMatch(value)) {
    //   return "Nama produk harus memiliki bentuk a-z atau A-Z";
    // }
    return null;
  }

  String vCityShop(String value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Kota harus diisi";
    }
    // else if (!regExp.hasMatch(value)) {
    //   return "Nama produk harus memiliki bentuk a-z atau A-Z";
    // }
    return null;
  }

  String vDistrictShop(String value) {
    if (value.length == 0) {
      return "Kecamatan harus diisi";
    }
    // else if (!regExp.hasMatch(value)) {
    //   return "Nama produk harus memiliki bentuk a-z atau A-Z";
    // }
    return null;
  }

  String vKelurahan(String value) {
    if (value.length == 0) {
      return "Kelurahan harus diisi";
    }
    return null;
  }

  String vRt(String value) {
    if (value.length == 0) {
      return "RT harus diisi";
    }
    return null;
  }

  String vRw(String value) {
    if (value.length == 0) {
      return "RW harus diisi";
    }
    return null;
  }

  //ADD RECEIPT NUMBER
  String vAddReceiptNumber(String value) {
    if (value.length == 0) {
      return "No. Resi harus diisi";
    } else if (value.indexOf(' ') >= 0) {
      return "No. Resi tidak boleh di spasi";
    }
    return null;
  }

  //SHOP PRODUCT LIST
  String vStokSellerProduct(String value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Stok produk harus diisi";
    } else if (!regExp.hasMatch(value)) {
      return "Format harus angka";
    }
    return null;
  }

  String vPriceSellerProduct(String value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Stok produk harus diisi";
    } else if (!regExp.hasMatch(value)) {
      return "Format harus angka";
    }
    return null;
  }

  //FORM REGISTERATION - GABUNG MITRAPANEN
  String vNameMitraRegisteration(String value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Nama harus diisi";
    }
    // else if (!regExp.hasMatch(value)) {
    //   return "Nama produk harus memiliki bentuk a-z atau A-Z";
    // }
    return null;
  }

  // REMOVE ALL FIRST ZERO FROM PHONE
  String vRemoveZeroNumberPhone(String value) {
    String pattern = r'^0+';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return "";
    }
  }
}
