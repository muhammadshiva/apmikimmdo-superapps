import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:marketplace/data/blocs/new_cubit/recipent/fetch_selected_recipent/fetch_selected_recipent_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/fetch_transaction_tracking/fetch_transaction_tracking_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/repositories.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as p;
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

class InvoiceWaitingPaymentScreen extends StatefulWidget {
  const InvoiceWaitingPaymentScreen({Key key, this.data}) : super(key: key);

  final OrderDetailMenungguPembayaranResponseData data;

  @override
  State<InvoiceWaitingPaymentScreen> createState() =>
      _InvoiceWaitingPaymentScreenState();
}

class _InvoiceWaitingPaymentScreenState
    extends State<InvoiceWaitingPaymentScreen> {
  final RecipentRepository recipentRepo = RecipentRepository();
  final GlobalKey genKey = GlobalKey();
  final pdf = pw.Document();
  final Color tableBorderColor = Colors.grey[400];
  final double tableBorderWidth = 0.7;

  String get invoiceNumber => widget.data.transactionCode ?? "-";

  var anchor;
  var isPublicResellerShop = false;

  FetchSelectedRecipentCubit _fetchSelectedRecipentCubit;
  FetchTransactionTrackingCubit _fetchTransactionTrackingCubit;

  @override
  void initState() {
    super.initState();
    _fetchSelectedRecipentCubit = FetchSelectedRecipentCubit()
      ..fetchSelectedRecipent();
    _fetchTransactionTrackingCubit = FetchTransactionTrackingCubit()
      ..getTrackingOrder(orderId: widget.data.id);
    // createPDF();
  }

  @override
  void dispose() {
    _fetchSelectedRecipentCubit.close();
    super.dispose();
  }

  createPDF() async {
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          children: [
            pw.Text('Hello World', style: pw.TextStyle(fontSize: 40)),
          ],
        ),
      ),
    );
    // savePDF();
  }

  Future<Uint8List> takePicture() async {
    RenderRepaintBoundary boundary = genKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: 1.5);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List data = byteData.buffer.asUint8List();
    return data;
  }

  Future<void> saveToGallery(Uint8List data, String fileName) async {
    // String filenameRes = invoiceTypeConst[widget.type].filenamePrefix ?? "";
    String filenameRes = 'INVOICE';
    filenameRes += filenameRes.isNotEmpty ? '_$fileName' : fileName;
    if (await _requestPermission(Permission.storage)) {
      var res = await ImageGallerySaver.saveImage(
        Uint8List.fromList(data),
        quality: 100,
        name: "$filenameRes",
      );

      debugPrint(res.toString());

      if (res['isSuccess'] ?? false) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('${p.basename(res['filePath'])} berhasil disimpan'),
              action: SnackBarAction(
                label: "Buka",
                onPressed: () async {
                  var openRes = await OpenFile.open(p.fromUri(res['filePath']));
                },
              ),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 5),
              margin: EdgeInsets.all(15),
            ),
          );
      } else {
        _showFailureSnackbar('Terjadi kesalahan saat menyimpan');
      }
    } else {
      _showFailureSnackbar('Terjadi kesalahan\npenyimpanan tidak diijinkan');
    }
  }

  Future<void> saveToPath(
    String filePath,
    String fileExt,
    Uint8List data,
  ) async {
    File imgFile = File('$filePath.$fileExt');
    await imgFile.writeAsBytes(data);
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  void _handleDownload() async {
    if (kIsWeb)
      // anchor.click();
      return;
    else
      await saveToGallery(
        await takePicture(),
        invoiceNumber.replaceAll('/', '_'),
      );
  }

  void _showFailureSnackbar(String msg) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(msg),
          action: SnackBarAction(
            textColor: AppColor.textPrimaryInverted,
            label: "Tutup",
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentSnackBar(),
          ),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 5),
          margin: EdgeInsets.all(15),
          backgroundColor: AppColor.danger,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.navScaffoldBg,
      appBar: kIsWeb
          ? null
          : AppBar(
              elevation: 0,
              title: Text('Invoice', style: AppTypo.subtitle2),
              centerTitle: true,
              backgroundColor: Colors.white,
              brightness: Brightness.light,
              iconTheme: IconThemeData(color: Colors.black),
              actions: [
                IconButton(
                  icon: Icon(Icons.save_alt),
                  tooltip: 'Download',
                  onPressed: _handleDownload,
                ),
              ],
            ),
      body: SizedBox.expand(
        child: InteractiveViewer(
          boundaryMargin: const EdgeInsets.all(50),
          minScale: 0.1,
          maxScale: 50,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    color: Colors.black.withOpacity(0.1),
                  )
                ],
              ),
              child: RepaintBoundary(
                key: genKey,
                child: Column(
                  children: [
                    Container(
                      width: 595,
                      padding: EdgeInsets.all(30),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Image.asset(
                              AppImg.img_logo,
                              fit: BoxFit.contain,
                              height: 36,
                            ),
                          ),
                          SizedBox(height: 30),
                          _buildHeadMultipleSeller(),
                          SizedBox(height: 20),
                          _buildOrderMultipleSeller(widget.data),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Spacer(),
                              Expanded(
                                child: Column(
                                  children: [
                                    // _buildVoucher(),
                                    // SizedBox(height: 20),
                                    _buildTotalMultipleSeler(widget.data),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    for (var index = 0;
                        index < widget.data.orders.length;
                        index++)
                      Container(
                        width: 595,
                        padding: EdgeInsets.all(30),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  AppImg.img_logo,
                                  fit: BoxFit.contain,
                                  height: 36,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Nomor Invoice",
                                        style: AppTypo.overline.copyWith(
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30),
                            _buildHead(),
                            SizedBox(height: 15),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: _buildPublish(widget.data, index)),
                                SizedBox(width: 25),
                                Expanded(child: _buildRecipent()),
                              ],
                            ),
                            SizedBox(height: 20),
                            _buildOrder(widget.data, index),
                            SizedBox(height: 20),
                            _buildNote(widget.data, index),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Spacer(),
                                Expanded(
                                  child: Column(
                                    children: [
                                      _buildShipping(widget.data, index),
                                      SizedBox(height: 20),
                                      // TODO: implement voucher if available
                                      // _buildVoucher(),
                                      // SizedBox(height: 20),
                                      _buildBiayaPenanganan(),
                                      SizedBox(height: 20),
                                      _buildTotal(widget.data, index),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Table _buildHead() {
    return Table(
      // border: TableBorder.all(),
      columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(),
        1: FixedColumnWidth(25),
        2: FlexColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        TableRow(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                "Nomor Resi",
                style: AppTypo.overline.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(),
            Text(
              "${invoiceNumber}",
              style: AppTypo.overline.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColor.primary,
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                "Tanggal Transaksi",
                style: AppTypo.overline.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(),
            Text(
              widget.data.orderDate == null ? '-' : widget.data.orderDate,
              style: AppTypo.overline,
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                "Pembayaran",
                style: AppTypo.overline.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(),
            Text(
              "${widget.data.bankName}",
              style: AppTypo.overline,
            ),
          ],
        ),
      ],
    );
  }

  Table _buildHeadMultipleSeller() {
    return Table(
      // border: TableBorder.all(),
      columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(),
        1: FixedColumnWidth(25),
        2: FlexColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        TableRow(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                "Tanggal Transaksi",
                style: AppTypo.overline.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(),
            Text(
              widget.data.orderDate == null ? '-' : widget.data.orderDate,
              style: AppTypo.overline,
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                "Pembayaran",
                style: AppTypo.overline.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(),
            Text(
              "${widget.data.bankName}",
              style: AppTypo.overline,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPublish(
      OrderDetailMenungguPembayaranResponseData data, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            "Diterbitkan atas nama",
            style: AppTypo.overline,
          ),
        ),
        Table(
          // border: TableBorder.all(),
          columnWidths: const <int, TableColumnWidth>{
            0: IntrinsicColumnWidth(),
            1: FixedColumnWidth(25),
            2: FlexColumnWidth(),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: <TableRow>[
            TableRow(
              children: <Widget>[
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.top,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      "Penjual",
                      style: AppTypo.overline
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                SizedBox(),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.top,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      "${data.orders[index].sellerName}",
                      style: AppTypo.overline,
                    ),
                  ),
                ),
              ],
            ),
            TableRow(
              children: <Widget>[
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.top,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      "Alamat",
                      style: AppTypo.overline
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                SizedBox(),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.top,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      "${data.orders[index].sellerAddress}",
                      style: AppTypo.overline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecipent() {
    return BlocBuilder<FetchSelectedRecipentCubit, FetchSelectedRecipentState>(
      cubit: _fetchSelectedRecipentCubit,
      builder: (context, state) {
        if (state is FetchSelectedRecipentSuccess) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  "Tujuan Pengiriman",
                  style: AppTypo.overline,
                ),
              ),
              Table(
                // border: TableBorder.all(),
                columnWidths: const <int, TableColumnWidth>{
                  0: IntrinsicColumnWidth(),
                  1: FixedColumnWidth(25),
                  2: FlexColumnWidth(),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: <TableRow>[
                  TableRow(
                    children: <Widget>[
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.top,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            "Nama",
                            style: AppTypo.overline
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      SizedBox(),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.top,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            // "${BlocProvider.of<UserDataCubit>(context).state.user.name}",
                            state.recipent.name ?? "",
                            style: AppTypo.overline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.top,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            "Alamat",
                            style: AppTypo.overline
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      SizedBox(),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.top,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            "${state.recipent.address ?? ""} ${state.recipent.city ?? ""} ${state.recipent.province ?? ""} \n${state.recipent.phone ?? ""}",
                            style: AppTypo.overline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        }
        return SizedBox();
      },
    );
  }

  Widget _buildOrder(
      OrderDetailMenungguPembayaranResponseData data, int index) {
    final totalHargaPerReseller = data.orders[index].items
        .map((e) => e.productPrice * e.quantity)
        .toList()
        .reduce((a, b) => a + b);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: tableBorderColor,
          width: tableBorderWidth,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Table(
            // border: TableBorder.all(),
            columnWidths: const <int, TableColumnWidth>{
              0: FixedColumnWidth(15),
              1: FlexColumnWidth(),
              2: FixedColumnWidth(25),
              3: IntrinsicColumnWidth(),
              4: FixedColumnWidth(25),
              5: IntrinsicColumnWidth(),
              6: FixedColumnWidth(25),
              7: IntrinsicColumnWidth(),
              8: FixedColumnWidth(25),
              9: IntrinsicColumnWidth(),
              10: FixedColumnWidth(15),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: <TableRow>[
              TableRow(
                decoration: BoxDecoration(color: Colors.grey[200]),
                children: <Widget>[
                  SizedBox(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      "Nama Produk",
                      style: AppTypo.overline
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(),
                  Text(
                    "Jumlah",
                    style:
                        AppTypo.overline.copyWith(fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(),
                  Text(
                    "Berat",
                    style:
                        AppTypo.overline.copyWith(fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(),
                  Text(
                    "Harga Barang",
                    style:
                        AppTypo.overline.copyWith(fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(),
                  Text(
                    "Subtotal",
                    style:
                        AppTypo.overline.copyWith(fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(),
                ],
              ),
              for (var item in data.orders[index].items)
                TableRow(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: tableBorderColor,
                        width: tableBorderWidth,
                      ),
                    ),
                  ),
                  children: <Widget>[
                    SizedBox(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        item.productName,
                        style: AppTypo.overline.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColor.primary,
                        ),
                      ),
                    ),
                    SizedBox(),
                    Text(
                      "${item.quantity}",
                      style: AppTypo.overline,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(),
                    // SizedBox(),
                    Text(
                      "1Kg",
                      style: AppTypo.overline,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(),
                    Text(
                      item.productPrice,
                      style: AppTypo.overline,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(),
                    Text(
                      item.totalPrice,
                      style: AppTypo.overline,
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(),
                  ],
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Total Harga",
                      style: AppTypo.overline.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Text(
                  data.orders[index].subtotal,
                  style: AppTypo.overline,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderMultipleSeller(
      OrderDetailMenungguPembayaranResponseData data) {
    final int totalInvoice = data.orders.length;

    // final totalHargaPerReseller = data.cart[index].product
    //     .map((e) => e.enduserPrice * e.quantity)
    //     .toList()
    //     .reduce((a, b) => a + b);

    // final totalHargaPerReseller = data.orders
    //     .map((c) => c.items
    //         .map((p) => p.productPrice * p.quantity)
    //         .toList()
    //         .reduce((a, b) => a + b))
    //     .toList();

    // final totalPlusOngkir = totalHargaPerReseller.map((e) => e + data.orders[totalHargaPerReseller.indexOf(e)].ongkir).toList();

    // debugPrint("ongkir $totalPlusOngkir");

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: tableBorderColor,
          width: tableBorderWidth,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Table(
            // border: TableBorder.all(),
            columnWidths: const <int, TableColumnWidth>{
              0: FixedColumnWidth(15),
              1: FlexColumnWidth(),
              2: FixedColumnWidth(25),
              3: IntrinsicColumnWidth(),
              4: FixedColumnWidth(25),
              5: IntrinsicColumnWidth(),
              6: FixedColumnWidth(25),
              7: IntrinsicColumnWidth(),
              8: FixedColumnWidth(25),
              9: IntrinsicColumnWidth(),
              10: FixedColumnWidth(15),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: <TableRow>[
              TableRow(
                decoration: BoxDecoration(color: Colors.grey[200]),
                children: <Widget>[
                  SizedBox(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      "Ringkasan Pembayaran $totalInvoice invoice",
                      style: AppTypo.overline
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(),
                  SizedBox(),
                  SizedBox(),
                  SizedBox(),
                  SizedBox(),
                  SizedBox(),
                  SizedBox(),
                  SizedBox(),
                  SizedBox(),
                ],
              ),
              for (var index = 0; index < data.orders.length; index++)
                TableRow(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: tableBorderColor,
                        width: tableBorderWidth,
                      ),
                    ),
                  ),
                  children: <Widget>[
                    SizedBox(),
                    // nama toko
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(data.orders[index].sellerName,
                          style: AppTypo.overline),
                    ),
                    SizedBox(),
                    // invoice number
                    Text(
                      "",
                      style: AppTypo.overline,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(),
                    // SizedBox(),
                    SizedBox(),
                    SizedBox(),
                    SizedBox(),
                    SizedBox(),
                    // harga subtotal
                    Text(
                      data.orders[index].totalPayment,
                      style: AppTypo.overline,
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(),
                  ],
                ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "Subtotal Belanja",
                    style: AppTypo.overline.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  data.totalPayment,
                  style: AppTypo.overline,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "Voucher",
                    style: AppTypo.overline.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  "- Rp ${AppExt.toRupiah(0)}",
                  style: AppTypo.overline.copyWith(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNote(OrderDetailMenungguPembayaranResponseData data, int index) {
    return Container(
      width: tableBorderWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Catatan: ",
            style: AppTypo.caption.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "${data.orders[index].note ?? "-"}",
            style: AppTypo.caption,
          )
        ],
      ),
    );
  }

  Widget _buildShipping(
      OrderDetailMenungguPembayaranResponseData data, int index) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
        color: tableBorderColor,
        width: tableBorderWidth,
      )),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  data.orders[index].courier,
                  style: AppTypo.overline,
                ),
              ),
            ),
            Text(
              data.orders[index].ongkir,
              style: AppTypo.overline,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoucher() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
        color: tableBorderColor,
        width: tableBorderWidth,
      )),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Voucher",
                    style: AppTypo.overline,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Gratis Ongkir Rp 5.000",
                    style: AppTypo.overline.copyWith(
                      fontSize: 7,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              "-Rp ${AppExt.toRupiah(5000)}",
              style: AppTypo.overline.copyWith(color: AppColor.danger),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBiayaPenanganan() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
        color: tableBorderColor,
        width: tableBorderWidth,
      )),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Biaya Penanganan",
                  style: AppTypo.overline,
                ),
              ),
            ),
            Text(
              "Rp -",
              style: AppTypo.overline,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotal(
      OrderDetailMenungguPembayaranResponseData data, int index) {
    final totalHargaPerReseller = data.orders[index].items
        .map((e) => e.productPrice * e.quantity)
        .toList()
        .reduce((a, b) => a + b);
    final total = totalHargaPerReseller + data.orders[index].ongkir;
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
        color: tableBorderColor,
        width: tableBorderWidth,
      )),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Total Pembayaran",
                  style: AppTypo.overline.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ),
            Text(
              data.orders[index].totalPayment,
              style: AppTypo.overline.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalMultipleSeler(
      OrderDetailMenungguPembayaranResponseData data) {
    final totalHargaPerReseller = data.orders
        .map((c) => c.items
            .map((p) => p.productPrice * p.quantity)
            .toList()
            .reduce((a, b) => a + b))
        .toList();

    final totalPlusOngkir = totalHargaPerReseller
        .map((e) => e + data.orders[totalHargaPerReseller.indexOf(e)].ongkir)
        .toList();

    return Container(
      decoration: BoxDecoration(
          border: Border.all(
        color: tableBorderColor,
        width: tableBorderWidth,
      )),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Total Pembayaran",
                  style: AppTypo.overline.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ),
            Text(
              data.totalPayment,
              style: AppTypo.overline.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
