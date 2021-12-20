import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:vaccination_pro/vaccine_data.dart';

class AddVaccine extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  AddVaccine({Key? key}) : super(key: key);
  late String _adjuvant,
      _antigen,
      _brandName,
      _description,
      _id,
      _manufacturer,
      _name,
      _provider,
      _type,
      _virulence;
  DateTime _expiryDate = DateTime.now(), _manufactureDate = DateTime.now();

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
                        SizedBox(height: 0.025 * height),
                        const Text("Adjuvant"),
                        TextFormField(
                          validator: RequiredValidator(
                              errorText: "Adjuvant is required"),
                          onSaved: (adjuvant) => _adjuvant = adjuvant!,
                        ),
                        SizedBox(height: 0.025 * height),
                        const Text("Antigen"),
                        TextFormField(
                          validator: RequiredValidator(
                              errorText: "Antigen is required"),
                          onSaved: (antigen) => _antigen = antigen!,
                        ),
                        SizedBox(height: 0.025 * height),
                        const Text("Description"),
                        TextFormField(
                          validator: RequiredValidator(
                              errorText: "Description is required"),
                          onSaved: (description) => _description = description!,
                        ),
                        SizedBox(height: 0.025 * height),
                        const Text("Brand Name"),
                        TextFormField(
                          validator: RequiredValidator(
                              errorText: "Brand Name is required"),
                          onSaved: (brandName) => _brandName = brandName!,
                        ),
                        SizedBox(height: 0.025 * height),
                        const Text("Manufacturer"),
                        TextFormField(
                          validator: RequiredValidator(
                              errorText: "Manufacturer is required"),
                          onSaved: (manufacturer) =>
                              _manufacturer = manufacturer!,
                        ),
                        SizedBox(height: 0.025 * height),
                        const Text("Provider"),
                        TextFormField(
                          validator: RequiredValidator(
                              errorText: "Provideris required"),
                          onSaved: (provider) => _provider = provider!,
                        ),
                        SizedBox(height: 0.025 * height),
                        const Text("Type"),
                        TextFormField(
                          validator:
                              RequiredValidator(errorText: "Type is required"),
                          onSaved: (type) => _type = type!,
                        ),
                        SizedBox(height: 0.025 * height),
                        const Text("Virulence"),
                        TextFormField(
                          validator: RequiredValidator(
                              errorText: "Virulence is required"),
                          onSaved: (virulence) => _virulence = virulence!,
                        ),
                        SizedBox(height: 0.025 * height),
                        const Text("Manufacture Date"),
                        Material(
                          color: Colors.transparent,
                          child: TextButton(
                              onPressed: () {
                                DatePicker.showDatePicker(context,
                                    showTitleActions: true,
                                    minTime: DateTime(1900, 1, 1),
                                    maxTime: DateTime.now(), onChanged: (date) {
                                  _manufactureDate = date;
                                }, onConfirm: (date) {
                                  _manufactureDate = date;
                                },
                                    currentTime: _manufactureDate,
                                    locale: LocaleType.en);
                              },
                              child: Text(
                                "${_manufactureDate.year.toString()}-${_manufactureDate.month.toString()}-${_manufactureDate.day.toString()}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              )),
                        ),
                        SizedBox(height: 0.025 * height),
                        const Text("Expiry Date"),
                        Material(
                          color: Colors.transparent,
                          child: TextButton(
                              onPressed: () {
                                DatePicker.showDatePicker(context,
                                    showTitleActions: true,
                                    minTime: DateTime.now(),
                                    maxTime: DateTime(2200), onChanged: (date) {
                                  _expiryDate = date;
                                }, onConfirm: (date) {
                                  _expiryDate = date;
                                },
                                    currentTime: _expiryDate,
                                    locale: LocaleType.en);
                              },
                              child: Text(
                                "${_expiryDate.year.toString()}-${_expiryDate.month.toString()}-${_expiryDate.day.toString()}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              )),
                        ),
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
                              "adjuvant": _adjuvant,
                              "antigen": _antigen,
                              "brand_name": _brandName,
                              "description": _description,
                              "manufacturer": _manufacturer,
                              "provider": _provider,
                              "type": _type,
                              "virulence": _virulence,
                              "expiry_date": Timestamp.fromDate(_expiryDate),
                              "manufacture_date":
                                  Timestamp.fromDate(_manufactureDate)
                            });
                            EasyLoading.showSuccess(
                                "New vaccine added Successfully!");
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
