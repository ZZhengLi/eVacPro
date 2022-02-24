import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vaccination_pro/vaccine_data.dart';

class VaccineQrCode extends StatefulWidget {
  final data, vaccineData;

  VaccineQrCode(
      {Key? key,
      required DocumentSnapshot<Object?> this.data,
      required DocumentSnapshot<Object?> this.vaccineData})
      : super(key: key);

  @override
  State<VaccineQrCode> createState() => _VaccineQrCodeState();
}

class _VaccineQrCodeState extends State<VaccineQrCode> {
  final _formKey = GlobalKey<FormState>();

  late String _randomString;

  late String _place, _dose;

  var _qrData = "";

  bool qrState = false;

  @override
  Widget build(BuildContext context) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Vaccine QR Code"),
            elevation: 0,
          ),
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Column(
              children: [
                Form(
                    key: _formKey,
                    child: SizedBox(
                      width: 300,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: const [
                              Text("Place of Service"),
                            ],
                          ),
                          TextFormField(
                            validator: RequiredValidator(
                                errorText: "Place of Service is required"),
                            onSaved: (place) => _place = place!,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: const [
                              Text("Dose Count"),
                            ],
                          ),
                          TextFormField(
                            validator: RequiredValidator(
                                errorText: "Dose Count is required"),
                            onSaved: (dose) => _dose = dose!,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    )),
                ElevatedButton(
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        EasyLoading.show(maskType: EasyLoadingMaskType.black);
                        _randomString = getRandomString(15);
                        try {
                          await FirebaseFirestore.instance.doc("QR/temp").set({
                            "uid": widget.data["uid"],
                            "code": _randomString,
                            "name": widget.vaccineData["name"],
                            "id": widget.vaccineData["id"],
                            "adjuvant": widget.vaccineData["adjuvant"],
                            "antigen": widget.vaccineData["antigen"],
                            "brand_name": widget.vaccineData["brand_name"],
                            "description": widget.vaccineData["description"],
                            "manufacturer": widget.vaccineData["manufacturer"],
                            "provider": widget.vaccineData["provider"],
                            "type": widget.vaccineData["type"],
                            "virulence": widget.vaccineData["virulence"],
                            "expiry_date": widget.vaccineData["expiry_date"],
                            "manufacture_date":
                                widget.vaccineData["manufacture_date"],
                            "date": Timestamp.fromDate(DateTime.now()),
                            "place_of_service": _place,
                            "dose_count": _dose
                          });
                          _qrData = _randomString;
                          setState(() {
                            qrState = true;
                          });
                        } catch (e) {
                          EasyLoading.showError(e.toString());
                        }
                        EasyLoading.dismiss();
                      }
                    },
                    child: const Text("Create")),
                Expanded(
                  child: Center(
                      child: QrImage(
                    foregroundColor: qrState ? null : Colors.transparent,
                    data: _qrData,
                    size: 300,
                  )),
                )
              ],
            ),
          )),
    );
  }
}
