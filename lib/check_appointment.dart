import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vaccination_hospital/add_new_appointment.dart';

class CheckAppointment extends StatelessWidget {
  final data;
  CheckAppointment(
      {Key? key, required QueryDocumentSnapshot<Object?> this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vaccines = FirebaseFirestore.instance
        .doc("Users/${data["uid"]}")
        .collection("Appointment")
        .orderBy("time", descending: true);
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
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AddNewAppointment(uid: data["uid"]);
                }));
              },
              child: IconButton(icon: const Icon(Icons.add), onPressed: () {}),
              tooltip: "Add New Appointment",
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              shape: const CircleBorder()),
          body: SafeArea(
            child: ListView(
              children: [
                ...snapshot.data!.docs.map((QueryDocumentSnapshot data) {
                  final DateTime time = data["time"].toDate();

                  return time.isAfter(DateTime(2000))
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
