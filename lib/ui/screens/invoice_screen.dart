// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui' as ui;

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:intl/intl.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path/path.dart' as p;
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

// import 'package:marketplace/utils/colors.dart' as AppColor;
// import 'package:marketplace/utils/constants.dart' as AppConst;
// import 'package:marketplace/utils/extensions.dart' as AppExt;
// import 'package:marketplace/utils/images.dart' as AppImg;
// import 'package:marketplace/utils/transitions.dart' as AppTrans;
// import 'package:marketplace/utils/typography.dart' as AppTypo;
// import 'package:pdf/widgets.dart' as pw;

// enum InvoiceType { warung, pelanggan, general }

// const Map<InvoiceType, InvoiceTypeConstVal> invoiceTypeConst = {
//   InvoiceType.pelanggan: InvoiceTypeConstVal("Invoice Pelanggan", "PEL"),
//   InvoiceType.warung: InvoiceTypeConstVal("Invoice Reseller", "RES"),
//   InvoiceType.general: InvoiceTypeConstVal("Invoice"),
// };

// class InvoiceTypeConstVal {
//   const InvoiceTypeConstVal(this.screenTitle, [this.filenamePrefix]);

//   final String screenTitle;
//   final String filenamePrefix;
// }

// class InvoiceScreen extends StatefulWidget {
//   const InvoiceScreen({
//     Key key,
//     @required this.data,
//     this.type = InvoiceType.general,
//   }) : super(key: key);

//   final InvoiceType type;

//   @override
//   _InvoiceScreenState createState() => _InvoiceScreenState();
// }

// class _InvoiceScreenState extends State<InvoiceScreen> {
//   final GlobalKey genKey = GlobalKey();
//   final Color tableBorderColor = Colors.grey[400];
//   final double tableBorderWidth = 0.7;

//   String get invoiceNumber => widget.data.kodeInvoice ?? "-";

//   final pdf = pw.Document();
//   var anchor;

//   // savePDF() async {
//   //   Uint8List pdfInBytes = await pdf.save();
//   //   final blob = html.Blob([pdfInBytes], 'application/pdf');
//   //   final url = html.Url.createObjectUrlFromBlob(blob);
//   //   anchor = html.document.createElement('a') as html.AnchorElement
//   //     ..href = url
//   //     ..style.display = 'none'
//   //     ..download = 'pdf.pdf';
//   //   html.document.body.children.add(anchor);
//   // }

//   createPDF() async {
//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) => pw.Column(
//           children: [
//             pw.Text('Hello World', style: pw.TextStyle(fontSize: 40)),
//           ],
//         ),
//       ),
//     );
//     // savePDF();
//   }

//   @override
//   void initState() {
//     super.initState();
//     // createPDF();
//   }

//   Future<Uint8List> takePicture() async {
//     RenderRepaintBoundary boundary = genKey.currentContext.findRenderObject();
//     ui.Image image = await boundary.toImage(pixelRatio: 1.5);
//     ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//     Uint8List data = byteData.buffer.asUint8List();
//     return data;
//   }

//   Future<void> saveToGallery(Uint8List data, String fileName) async {
//     String filenameRes = invoiceTypeConst[widget.type].filenamePrefix ?? "";
//     filenameRes += filenameRes.isNotEmpty ? '_$fileName' : fileName;
//     if (await _requestPermission(Permission.storage)) {
//       var res = await ImageGallerySaver.saveImage(
//         Uint8List.fromList(data),
//         quality: 100,
//         name: "$filenameRes",
//       );

//       debugPrint(res.toString());

//       if (res['isSuccess'] ?? false) {
//         ScaffoldMessenger.of(context)
//           ..hideCurrentSnackBar()
//           ..showSnackBar(
//             SnackBar(
//               content: Text('${p.basename(res['filePath'])} berhasil disimpan'),
//               action: SnackBarAction(
//                 label: "Buka",
//                 onPressed: () async {
//                   var openRes = await OpenFile.open(p.fromUri(res['filePath']));
//                 },
//               ),
//               behavior: SnackBarBehavior.floating,
//               duration: Duration(seconds: 5),
//               margin: EdgeInsets.all(15),
//             ),
//           );
//       } else {
//         _showFailureSnackbar('Terjadi kesalahan saat menyimpan');
//       }
//     } else {
//       _showFailureSnackbar('Terjadi kesalahan\npenyimpanan tidak diijinkan');
//     }
//   }

//   Future<void> saveToPath(
//     String filePath,
//     String fileExt,
//     Uint8List data,
//   ) async {
//     File imgFile = File('$filePath.$fileExt');
//     await imgFile.writeAsBytes(data);
//   }

//   // Future<bool> determinePath(String fileName) async {
//   //   Directory directory;
//   //   try {
//   //     if (Platform.isAndroid) {
//   //       if (await _requestPermission(Permission.storage)) {
//   //         directory = await getExternalStorageDirectory();

//   //         String newPath = "";

//   //         List<String> folders = directory.path.split("/");
//   //         for (var i = 1; i < folders.length; i++) {
//   //           String folder = folders[i];
//   //           if (folder != "Android") {
//   //             newPath += "/" + folder;
//   //           } else {
//   //             break;
//   //           }
//   //         }
//   //         newPath = newPath + "/Panen-Panen";
//   //         directory = Directory(newPath);
//   //       } else {
//   //         return false;
//   //       }
//   //     } else {
//   //       throw UnimplementedError("save file iOS not implemented yet");
//   //     }
//   //     if (!await directory.exists()) {
//   //       await directory.create(recursive: true);
//   //     }
//   //     if (await directory.exists()) {
//   //       File saveFile = File(directory.path + "/$fileName");
//   //       //TODO: run file saver
//   //       return true;
//   //     }
//   //   } catch (e) {}
//   //   return false;
//   // }

//   Future<bool> _requestPermission(Permission permission) async {
//     if (await permission.isGranted) {
//       return true;
//     } else {
//       var result = await permission.request();
//       if (result == PermissionStatus.granted) {
//         return true;
//       } else {
//         return false;
//       }
//     }
//   }

//   void _handleDownload() async {
//     if (kIsWeb)
//       // anchor.click();
//       return;
//     else
//       await saveToGallery(
//         await takePicture(),
//         invoiceNumber.replaceAll('/', '_'),
//       );
//   }

//   void _showFailureSnackbar(String msg) {
//     ScaffoldMessenger.of(context)
//       ..removeCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(
//           content: Text(msg),
//           action: SnackBarAction(
//             textColor: AppColor.textPrimaryInverted,
//             label: "Tutup",
//             onPressed: () =>
//                 ScaffoldMessenger.of(context).hideCurrentSnackBar(),
//           ),
//           behavior: SnackBarBehavior.floating,
//           duration: Duration(seconds: 5),
//           margin: EdgeInsets.all(15),
//           backgroundColor: AppColor.danger,
//         ),
//       );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.navScaffoldBg,
//       appBar: kIsWeb
//           ? null
//           : AppBar(
//               elevation: 7,
//               title: Text(invoiceTypeConst[widget.type].screenTitle,
//                   style: AppTypo.subtitle2),
//               centerTitle: true,
//               backgroundColor: Colors.white,
//               brightness: Brightness.light,
//               actions: [
//                 IconButton(
//                   icon: Icon(Icons.save_alt),
//                   tooltip: 'Download',
//                   onPressed: _handleDownload,
//                 ),
//               ],
//             ),
//       body: SizedBox.expand(
//         child: InteractiveViewer(
//           boundaryMargin: const EdgeInsets.all(50),
//           minScale: 0.1,
//           maxScale: 50,
//           child: FittedBox(
//             fit: BoxFit.contain,
//             child: Container(
//               decoration: BoxDecoration(
//                 boxShadow: [
//                   BoxShadow(
//                     blurRadius: 20,
//                     color: Colors.black.withOpacity(0.1),
//                   )
//                 ],
//               ),
//               child: RepaintBoundary(
//                 key: genKey,
//                 child: Container(
//                   width: 595,
//                   padding: EdgeInsets.all(30),
//                   color: Colors.white,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       Image.asset(
//                         AppImg.img_logo,
//                         height: 36,
//                       ),
//                       SizedBox(height: 30),
//                       _buildHead(),
//                       SizedBox(height: 15),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Expanded(child: _buildPublish()),
//                           SizedBox(width: 25),
//                           Expanded(child: _buildRecipent()),
//                         ],
//                       ),
//                       SizedBox(height: 20),
//                       _buildOrder(),
//                       SizedBox(height: 20),
//                       Row(
//                         children: [
//                           Spacer(),
//                           Expanded(
//                             child: Column(
//                               children: [
//                                 _buildShipping(),
//                                 SizedBox(height: 20),
//                                 // TODO: implement voucher if available
//                                 // _buildVoucher(),
//                                 // SizedBox(height: 20),
//                                 _buildTotal(),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Table _buildHead() {
//     return Table(
//       // border: TableBorder.all(),
//       columnWidths: const <int, TableColumnWidth>{
//         0: IntrinsicColumnWidth(),
//         1: FixedColumnWidth(25),
//         2: FlexColumnWidth(),
//       },
//       defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//       children: <TableRow>[
//         TableRow(
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 5),
//               child: Text(
//                 "Nomor Invoice",
//                 style: AppTypo.overline.copyWith(fontWeight: FontWeight.w700),
//               ),
//             ),
//             SizedBox(),
//             Text(
//               "${invoiceNumber}",
//               style: AppTypo.overline.copyWith(
//                 fontWeight: FontWeight.w700,
//                 color: AppColor.primary,
//               ),
//             ),
//           ],
//         ),
//         TableRow(
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 5),
//               child: Text(
//                 "Tanggal Transaksi",
//                 style: AppTypo.overline.copyWith(fontWeight: FontWeight.w700),
//               ),
//             ),
//             SizedBox(),
//             Text(
//               widget.data.paymentdate == null
//                   ? '-'
//                   : DateFormat(
//                       "d MMMM yyyy",
//                       "id_ID",
//                     ).format(
//                       widget.data.paymentdate,
//                     ),
//               style: AppTypo.overline,
//             ),
//           ],
//         ),
//         TableRow(
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 5),
//               child: Text(
//                 "Pembayaran",
//                 style: AppTypo.overline.copyWith(fontWeight: FontWeight.w700),
//               ),
//             ),
//             SizedBox(),
//             Text(
//               "${widget.data.paymentMethod}",
//               style: AppTypo.overline,
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildPublish() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 5),
//           child: Text(
//             "Diterbitkan atas nama",
//             style: AppTypo.overline,
//           ),
//         ),
//         Table(
//           // border: TableBorder.all(),
//           columnWidths: const <int, TableColumnWidth>{
//             0: IntrinsicColumnWidth(),
//             1: FixedColumnWidth(25),
//             2: FlexColumnWidth(),
//           },
//           defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//           children: <TableRow>[
//             TableRow(
//               children: <Widget>[
//                 TableCell(
//                   verticalAlignment: TableCellVerticalAlignment.top,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 5),
//                     child: Text(
//                       "Penjual",
//                       style: AppTypo.overline
//                           .copyWith(fontWeight: FontWeight.w700),
//                     ),
//                   ),
//                 ),
//                 SizedBox(),
//                 TableCell(
//                   verticalAlignment: TableCellVerticalAlignment.top,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 5),
//                     child: Text(
//                       "${widget.data.sellerName}",
//                       style: AppTypo.overline,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             TableRow(
//               children: <Widget>[
//                 TableCell(
//                   verticalAlignment: TableCellVerticalAlignment.top,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 5),
//                     child: Text(
//                       "Alamat",
//                       style: AppTypo.overline
//                           .copyWith(fontWeight: FontWeight.w700),
//                     ),
//                   ),
//                 ),
//                 SizedBox(),
//                 TableCell(
//                   verticalAlignment: TableCellVerticalAlignment.top,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 5),
//                     child: Text(
//                       "${widget.data.sellerAddress}",
//                       style: AppTypo.overline,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildRecipent() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 5),
//           child: Text(
//             "Tujuan Pengiriman",
//             style: AppTypo.overline,
//           ),
//         ),
//         Table(
//           // border: TableBorder.all(),
//           columnWidths: const <int, TableColumnWidth>{
//             0: IntrinsicColumnWidth(),
//             1: FixedColumnWidth(25),
//             2: FlexColumnWidth(),
//           },
//           defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//           children: <TableRow>[
//             TableRow(
//               children: <Widget>[
//                 TableCell(
//                   verticalAlignment: TableCellVerticalAlignment.top,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 5),
//                     child: Text(
//                       "Nama",
//                       style: AppTypo.overline
//                           .copyWith(fontWeight: FontWeight.w700),
//                     ),
//                   ),
//                 ),
//                 SizedBox(),
//                 TableCell(
//                   verticalAlignment: TableCellVerticalAlignment.top,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 5),
//                     child: Text(
//                       "${widget.data.recipentName}",
//                       style: AppTypo.overline,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             TableRow(
//               children: <Widget>[
//                 TableCell(
//                   verticalAlignment: TableCellVerticalAlignment.top,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 5),
//                     child: Text(
//                       "Alamat",
//                       style: AppTypo.overline
//                           .copyWith(fontWeight: FontWeight.w700),
//                     ),
//                   ),
//                 ),
//                 SizedBox(),
//                 TableCell(
//                   verticalAlignment: TableCellVerticalAlignment.top,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 5),
//                     child: Text(
//                       "${widget.data.address}, ${widget.data.recipentSubdistrict}\n${widget.data.recipentCity}, ${widget.data.recipentProvince}\n+${widget.data.recipentPhone}",
//                       style: AppTypo.overline,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildOrder() {
//     var datas = [
//       _ProdData("Bayam Hijau", 4, 1, 13000),
//       _ProdData("Daging Ayam", 1, 2, 15000),
//       _ProdData("Sate", 3, 1, 7000),
//       _ProdData("Susu", 6, 2, 9000),
//       _ProdData("Tempe", 3, 1, 33000),
//     ];

//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: tableBorderColor,
//           width: tableBorderWidth,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Table(
//             // border: TableBorder.all(),
//             columnWidths: const <int, TableColumnWidth>{
//               0: FixedColumnWidth(15),
//               1: FlexColumnWidth(),
//               2: FixedColumnWidth(25),
//               3: IntrinsicColumnWidth(),
//               4: FixedColumnWidth(25),
//               5: IntrinsicColumnWidth(),
//               6: FixedColumnWidth(25),
//               7: IntrinsicColumnWidth(),
//               8: FixedColumnWidth(25),
//               9: IntrinsicColumnWidth(),
//               10: FixedColumnWidth(15),
//             },
//             defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//             children: <TableRow>[
//               TableRow(
//                 decoration: BoxDecoration(color: Colors.grey[200]),
//                 children: <Widget>[
//                   SizedBox(),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 5),
//                     child: Text(
//                       "Nama Produk",
//                       style: AppTypo.overline
//                           .copyWith(fontWeight: FontWeight.w700),
//                     ),
//                   ),
//                   SizedBox(),
//                   Text(
//                     "Jumlah",
//                     style:
//                         AppTypo.overline.copyWith(fontWeight: FontWeight.w700),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(),
//                   Text(
//                     "Berat",
//                     style:
//                         AppTypo.overline.copyWith(fontWeight: FontWeight.w700),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(),
//                   Text(
//                     "Harga Barang",
//                     style:
//                         AppTypo.overline.copyWith(fontWeight: FontWeight.w700),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(),
//                   Text(
//                     "Subtotal",
//                     style:
//                         AppTypo.overline.copyWith(fontWeight: FontWeight.w700),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(),
//                 ],
//               ),
//               for (var item in widget.data.detailorders)
//                 TableRow(
//                   decoration: BoxDecoration(
//                     border: Border(
//                       bottom: BorderSide(
//                         color: tableBorderColor,
//                         width: tableBorderWidth,
//                       ),
//                     ),
//                   ),
//                   children: <Widget>[
//                     SizedBox(),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 10),
//                       child: Text(
//                         "${item.productName}",
//                         style: AppTypo.overline.copyWith(
//                           fontWeight: FontWeight.w700,
//                           color: AppColor.primary,
//                         ),
//                       ),
//                     ),
//                     SizedBox(),
//                     Text(
//                       "${item.quantity}",
//                       style: AppTypo.overline,
//                       textAlign: TextAlign.center,
//                     ),
//                     SizedBox(),
//                     Text(
//                       "${item.weight}${item.unit}",
//                       style: AppTypo.overline,
//                       textAlign: TextAlign.center,
//                     ),
//                     SizedBox(),
//                     Text(
//                       "Rp ${AppExt.toRupiah(item.enduserPrice)}",
//                       style: AppTypo.overline,
//                       textAlign: TextAlign.center,
//                     ),
//                     SizedBox(),
//                     Text(
//                       "Rp ${AppExt.toRupiah(item.subtotal)}",
//                       style: AppTypo.overline,
//                       textAlign: TextAlign.center,
//                     ),
//                     SizedBox(),
//                   ],
//                 ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     child: Text(
//                       "Harga Barang",
//                       style: AppTypo.overline.copyWith(
//                         fontWeight: FontWeight.w700,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ),
//                 Text(
//                   "Rp ${AppExt.toRupiah(widget.data.subtotalPrice)}",
//                   style: AppTypo.overline,
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildShipping() {
//     return Container(
//       decoration: BoxDecoration(
//           border: Border.all(
//         color: tableBorderColor,
//         width: tableBorderWidth,
//       )),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15),
//         child: Row(
//           children: [
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 10),
//                 child: Text(
//                   "${widget.data.shippingName}",
//                   style: AppTypo.overline,
//                 ),
//               ),
//             ),
//             Text(
//               "Rp ${AppExt.toRupiah(widget.data.ongkir)}",
//               style: AppTypo.overline,
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildVoucher() {
//     return Container(
//       decoration: BoxDecoration(
//           border: Border.all(
//         color: tableBorderColor,
//         width: tableBorderWidth,
//       )),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Text(
//                     "Voucher",
//                     style: AppTypo.overline,
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Text(
//                     "Gratis Ongkir Rp 5.000",
//                     style: AppTypo.overline.copyWith(
//                       fontSize: 7,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Text(
//               "-Rp ${AppExt.toRupiah(5000)}",
//               style: AppTypo.overline.copyWith(color: AppColor.danger),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTotal() {
//     return Container(
//       decoration: BoxDecoration(
//           border: Border.all(
//         color: tableBorderColor,
//         width: tableBorderWidth,
//       )),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15),
//         child: Row(
//           children: [
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 10),
//                 child: Text(
//                   "Total Pembayaran",
//                   style: AppTypo.overline.copyWith(fontWeight: FontWeight.w700),
//                 ),
//               ),
//             ),
//             Text(
//               "Rp ${AppExt.toRupiah(widget.data.total)}",
//               style: AppTypo.overline.copyWith(fontWeight: FontWeight.w700),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _ProdData {
//   String name;
//   int qty;
//   int weight;
//   int price;

//   _ProdData(
//     this.name,
//     this.qty,
//     this.weight,
//     this.price,
//   );
// }
