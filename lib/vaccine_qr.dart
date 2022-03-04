import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class VaccineQR extends StatelessWidget {
  final data;
  const VaccineQR({Key? key, required String this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Vaccine QR Code"),
        elevation: 0,
      ),
      body: Center(
          child: QrImage(
        data: data,
        size: 300,
      )),
    );
  }
}
