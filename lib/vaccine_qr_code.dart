import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:qr_flutter/qr_flutter.dart';

class VaccineQrCode extends StatefulWidget {
  final data;

  VaccineQrCode({Key? key, required QueryDocumentSnapshot<Object?> this.data})
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
                    child: Column(
                      children: [
                        const Text("Place"),
                        TextFormField(
                          validator:
                              RequiredValidator(errorText: "Place is required"),
                          onSaved: (place) => _place = place!,
                        ),
                        const Text("Dose"),
                        TextFormField(
                          validator:
                              RequiredValidator(errorText: "Dose is required"),
                          onSaved: (dose) => _dose = dose!,
                        ),
                      ],
                    )),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        EasyLoading.show(maskType: EasyLoadingMaskType.black);
                        _randomString = getRandomString(15);
                        try {
                          await FirebaseFirestore.instance.doc("QR/temp").set({
                            "code": _randomString,
                            "name": widget.data["name"],
                            "id": widget.data["id"],
                            "adjuvant": widget.data["adjuvant"],
                            "antigen": widget.data["antigen"],
                            "brand_name": widget.data["brand_name"],
                            "description": widget.data["description"],
                            "manufacturer": widget.data["manufacturer"],
                            "provider": widget.data["provider"],
                            "type": widget.data["type"],
                            "virulence": widget.data["virulence"],
                            "expiry_date": widget.data["expiry_date"],
                            "manufacture_date": widget.data["manufacture_date"],
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
