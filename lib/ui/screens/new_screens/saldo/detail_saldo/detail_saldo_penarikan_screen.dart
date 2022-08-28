import 'package:flutter/material.dart';

class DetailSaldoPenarikanScreen extends StatefulWidget {
  const DetailSaldoPenarikanScreen({ Key key }) : super(key: key);

  @override
  State<DetailSaldoPenarikanScreen> createState() => _DetailSaldoPenarikanScreenState();
}

class _DetailSaldoPenarikanScreenState extends State<DetailSaldoPenarikanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("penarikan"),),
    );
  }
}