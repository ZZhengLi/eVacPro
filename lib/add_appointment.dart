import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';

class AddAppointment extends StatelessWidget {
  final data;

  AddAppointment({Key? key, required DocumentSnapshot<Object?> this.data})
      : super(key: key);

  final _formKey = GlobalKey<FormState>();

  late String _place, _dose, _name, _id, _provider;

  DateTime _time = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Add New Appointment"),
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
                                validator: RequiredValidator(
                                    errorText: "Vaccine Name is required"),
                                onSaved: (name) => _name = name!,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: const [
                                  Text("Provider Name"),
                                ],
                              ),
                              TextFormField(
                                validator: RequiredValidator(
                                    errorText: "Provider is required"),
                                onSaved: (provider) => _provider = provider!,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: const [
                                  Text("Dose Count(number only)"),
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
                                  Text("Date"),
                                ],
                              ),
                              Material(
                                child: InkWell(
                                    onTap: () {
                                      DatePicker.showDateTimePicker(context,
                                          showTitleActions: true,
                                          minTime: DateTime.now(),
                                          maxTime: DateTime(2222, 1, 1),
                                          onChanged: (date) {
                                        _time = date;
                                      }, onConfirm: (date) {
                                        _time = date;
                                      },
                                          currentTime: DateTime.now(),
                                          locale: LocaleType.en);
                                    },
                                    child: Text(
                                      "${_time.year.toString()}-${_time.month.toString().padLeft(2, '0')}-${_time.day.toString().padLeft(2, '0')} ${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            EasyLoading.show(
                                maskType: EasyLoadingMaskType.black);
                            try {
                              await FirebaseFirestore.instance
                                  .doc("Users/${data["uid"]}")
                                  .collection("Appointment")
                                  .doc(_name + _dose)
                                  .set({
                                "vaccine_name": _name,
                                "provider_name": _provider,
                                "time": _time,
                                "place_of_service": _place,
                                "dose_number": _dose
                              });
                            } catch (e) {
                              EasyLoading.showError(e.toString());
                            }
                            EasyLoading.dismiss();
                            Navigator.of(context).pop();
                            EasyLoading.showSuccess(
                                "New appointment added successfully!");
                          }
                        },
                        child: const Text("Add")),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
