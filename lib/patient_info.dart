import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PatientInfo extends StatelessWidget {
  final data;
  const PatientInfo(
      {Key? key, required QueryDocumentSnapshot<Object?> this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Patient Info"),
          elevation: 0,
        ),
        body: SafeArea(
            child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 0.8 * width,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: Colors.blueGrey),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(data["photoUrl"]),
                      ),
                      Container(
                          alignment: Alignment.topLeft,
                          child: Column(
                            children: [
                              infoFormat(
                                  width, height, "Name:", data["displayName"]),
                              infoFormat(width, height, "ID Card:", data["id"]),
                              infoFormat(
                                  width, height, "Gender:", data["gender"]),
                              infoFormat(width, height, "DOB:",
                                  "${data["dob"].toDate().year}-${data["dob"].toDate().month}-${data["dob"].toDate().day}"),
                              Row(
                                children: [
                                  SizedBox(
                                      width: 0.2 * width,
                                      child: const Text("address:",
                                          style: TextStyle(fontSize: 14))),
                                  Container(
                                    width: 0.55 * width,
                                    padding: EdgeInsets.all(0.005 * height),
                                    child: Text(
                                      data["address"],
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              infoFormat(width, height, "Nationality:",
                                  data["nationality"]),
                              infoFormat(
                                  width, height, "E-mail:", data["email"]),
                              infoFormat(
                                  width, height, "phone:", data["phone"]),
                              infoFormat(width, height, "Blood group:",
                                  data["bloodGroup"]),
                              infoFormat(
                                  width, height, "weight:", data["weight"]),
                              infoFormat(
                                  width, height, "height:", data["height"]),
                            ],
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ],
        )));
  }
}

Row infoFormat(double width, double height, String title, String data) {
  return Row(
    children: [
      SizedBox(
          width: 0.2 * width,
          child: Text(title, style: const TextStyle(fontSize: 16))),
      Padding(
        padding: EdgeInsets.all(0.005 * height),
        child: Text(
          data,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    ],
  );
}
