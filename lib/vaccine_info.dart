import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vaccination_pro/vaccine_qr_code.dart';

class VaccineInfo extends StatelessWidget {
  final data;
  const VaccineInfo(
      {Key? key, required QueryDocumentSnapshot<Object?> this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Vaccine Info"),
          elevation: 0,
        ),
        bottomNavigationBar: ElevatedButton(
          child: const Text("Create QR Code"),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return VaccineQrCode(data: data);
            }));
          },
        ),
        body: Container());
  }
}
