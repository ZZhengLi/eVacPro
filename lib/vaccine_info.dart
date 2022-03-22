import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:vaccination_pro/vaccine_qr.dart';

class VaccineInfo extends StatefulWidget {
  final data;
  String name, dose, place;

  VaccineInfo(
      {Key? key,
      required DocumentSnapshot<Object?> this.data,
      this.name = "",
      this.dose = "",
      this.place = ""})
      : super(key: key);

  @override
  State<VaccineInfo> createState() => _VaccineInfoState();
}

class _VaccineInfoState extends State<VaccineInfo> {
  final _formKey = GlobalKey<FormState>();

  late String _randomString;

  late String _id, _manufacturer;

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
            title: const Text("Vaccine Info"),
            elevation: 0,
          ),
          body: SafeArea(
            child: ListView(
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                        key: _formKey,
                        child: SizedBox(
                          width: 300,
                          child: Column(
                            children: [
                              Row(
                                children: const [
                                  Text("Vaccine Name"),
                                ],
                              ),
                              TextFormField(
                                controller:
                                    TextEditingController(text: widget.name),
                                validator: RequiredValidator(
                                    errorText: "Vaccine Name is required"),
                                onSaved: (name) => widget.name = name!,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: const [
                                  Text("Lot Number"),
                                ],
                              ),
                              TextFormField(
                                validator: RequiredValidator(
                                    errorText: "Lot Number is required"),
                                onSaved: (id) => _id = id!,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: const [
                                  Text("Manufacturer"),
                                ],
                              ),
                              TextFormField(
                                validator: RequiredValidator(
                                    errorText: "Manufacturer is required"),
                                onSaved: (manufacturer) =>
                                    _manufacturer = manufacturer!,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: const [
                                  Text("Dose Number"),
                                ],
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                controller:
                                    TextEditingController(text: widget.dose),
                                validator: RequiredValidator(
                                    errorText: "Dose Number is required"),
                                onSaved: (dose) => widget.dose = dose!,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: const [
                                  Text("Place of Service"),
                                ],
                              ),
                              TextFormField(
                                controller:
                                    TextEditingController(text: widget.place),
                                validator: RequiredValidator(
                                    errorText: "Place of Service is required"),
                                onSaved: (place) => widget.place = place!,
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
                            EasyLoading.show(
                                maskType: EasyLoadingMaskType.black);
                            _randomString = getRandomString(15);
                            try {
                              await FirebaseFirestore.instance
                                  .doc("QR/temp")
                                  .set({
                                "uid": widget.data["uid"],
                                "displayName": widget.data["displayName"],
                                "dob": widget.data["dob"],
                                "gender": widget.data["gender"],
                                "idC": widget.data["id"],
                                "address": widget.data["address"],
                                "code": _randomString,
                                "name": widget.name,
                                "id": _id,
                                "manufacturer": _manufacturer,
                                "date": Timestamp.fromDate(DateTime.now()),
                                "place_of_service": widget.place,
                                "dose_number": widget.dose
                              });
                              _qrData = _randomString;
                              setState(() {
                                qrState = true;
                              });
                            } catch (e) {
                              EasyLoading.showError(e.toString());
                            }
                            EasyLoading.dismiss();
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return VaccineQR(data: _qrData);
                            }));
                          }
                        },
                        child: const Text("Create")),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
