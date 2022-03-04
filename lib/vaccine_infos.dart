import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vaccination_pro/scanner.dart';
import 'package:vaccination_pro/vaccine_info.dart';

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
              return const Scanner();
            }));
          },
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(50, 20, 0, 0),
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(
                      width: 150,
                      child: Text("Name: ", style: TextStyle(fontSize: 20))),
                  Text(
                    "${data["name"]}",
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const SizedBox(
                      width: 150,
                      child:
                          Text("Lot Number: ", style: TextStyle(fontSize: 20))),
                  Text(
                    "${data["id"]}",
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const SizedBox(
                      width: 150,
                      child: Text("Manufacturer: ",
                          style: TextStyle(fontSize: 20))),
                  Text(
                    "${data["manufacturer"]}",
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
