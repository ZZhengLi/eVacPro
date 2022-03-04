import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:vaccination_pro/vaccine_data.dart';

class AddVaccine extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  AddVaccine({Key? key}) : super(key: key);
  late String 
      _id,
      _manufacturer,
      _name;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Add New Vaccine"),
          elevation: 0,
        ),
        body: Center(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                  0.05 * width, 0.01 * height, 0.05 * width, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Name"),
                        TextFormField(
                          validator:
                              RequiredValidator(errorText: "Name is required"),
                          onSaved: (name) => _name = name!,
                        ),
                        SizedBox(height: 0.025 * height),
                        const Text("Lot Number"),
                        TextFormField(
                          validator: RequiredValidator(
                              errorText: "Lot Number is required"),
                          onSaved: (id) => _id = id!,
                        ),
                        const Text("Manufacturer"),
                        TextFormField(
                          validator: RequiredValidator(
                              errorText: "Manufacturer is required"),
                          onSaved: (manufacturer) =>
                              _manufacturer = manufacturer!,
                        ),
                        SizedBox(height: 0.025 * height),
                        // const Text("Manufacture Date"),
                        // Material(
                        //   color: Colors.transparent,
                        //   child: TextButton(
                        //       onPressed: () {
                        //         DatePicker.showDatePicker(context,
                        //             showTitleActions: true,
                        //             minTime: DateTime(1900, 1, 1),
                        //             maxTime: DateTime.now(), onChanged: (date) {
                        //           _manufactureDate = date;
                        //         }, onConfirm: (date) {
                        //           _manufactureDate = date;
                        //         },
                        //             currentTime: _manufactureDate,
                        //             locale: LocaleType.en);
                        //       },
                        //       child: Text(
                        //         "${_manufactureDate.year.toString()}-${_manufactureDate.month.toString()}-${_manufactureDate.day.toString()}",
                        //         style: const TextStyle(
                        //           fontWeight: FontWeight.bold,
                        //           fontSize: 16,
                        //         ),
                        //       )),
                        // ),
                        SizedBox(height: 0.025 * height),
                        const Text("Expiry Date"),
                        // Material(
                        //   color: Colors.transparent,
                        //   child: TextButton(
                        //       onPressed: () {
                        //         DatePicker.showDatePicker(context,
                        //             showTitleActions: true,
                        //             minTime: DateTime.now(),
                        //             maxTime: DateTime(2200), onChanged: (date) {
                        //           _expiryDate = date;
                        //         }, onConfirm: (date) {
                        //           _expiryDate = date;
                        //         },
                        //             currentTime: _expiryDate,
                        //             locale: LocaleType.en);
                        //       },
                        //       child: Text(
                        //         "${_expiryDate.year.toString()}-${_expiryDate.month.toString()}-${_expiryDate.day.toString()}",
                        //         style: const TextStyle(
                        //           fontWeight: FontWeight.bold,
                        //           fontSize: 16,
                        //         ),
                        //       )),
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(height: 0.05 * width),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          EasyLoading.show(maskType: EasyLoadingMaskType.black);
                          try {
                            await FirebaseFirestore.instance
                                .collection("VaccineData")
                                .add({
                              "name": _name,
                              "id": _id,
                              "manufacturer": _manufacturer,
                            });
                            EasyLoading.showSuccess(
                                "New vaccine added successfully!");
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VaccineData()));
                          } catch (e) {
                            EasyLoading.showError(e.toString());
                          }
                        }
                      },
                      child: const Text("Confirm"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
