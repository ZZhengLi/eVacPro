import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CheckAppointment extends StatefulWidget {
  final data;

  CheckAppointment({Key? key, required DocumentSnapshot<Object?> this.data})
      : super(key: key);

  @override
  State<CheckAppointment> createState() => _CheckAppointmentState();
}

class _CheckAppointmentState extends State<CheckAppointment> {
  DateTime _date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var collection = FirebaseFirestore.instance
        .doc("Users/${widget.data["uid"]}")
        .collection("Appointment");
    final vaccines = collection.orderBy("time", descending: true);
    return StreamBuilder(
      stream: vaccines.snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          EasyLoading.dismiss();
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        EasyLoading.dismiss();
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("History Appointments"),
            elevation: 0,
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    minTime: DateTime.now(),
                    maxTime: DateTime(2200), onChanged: (date) {
                  _date = date;
                }, onConfirm: (date) {
                  _date = date;
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Add New Appointment'),
                        content: Text(
                          "${_date.year.toString()}-${_date.month.toString()}-${_date.day.toString()}",
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          ElevatedButton(
                            child: const Text('Confirm'),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await collection
                                  .add({"time": Timestamp.fromDate(_date)});
                            },
                          ),
                        ],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      );
                    },
                  );
                }, currentTime: _date, locale: LocaleType.en);
              },
              child: const Icon(Icons.add),
              tooltip: "Add New Appointment",
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              shape: const CircleBorder()),
          body: SafeArea(
            child: ListView(
              children: [
                ...snapshot.data!.docs.map((QueryDocumentSnapshot data) {
                  final DateTime time = data["time"].toDate();

                  return time.isBefore(DateTime(2200))
                      ? Card(
                          child: ListTile(
                              title: Text(
                            "${time.year.toString()}-${time.month.toString()}-${time.day.toString()}",
                          )),
                        )
                      : Container();
                })
              ],
            ),
          ),
        );
      },
    );
  }
}
