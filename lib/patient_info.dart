import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vaccination_pro/check_appointment.dart';
import 'package:vaccination_pro/vaccine_info.dart';

class PatientInfo extends StatelessWidget {
  final uid;
  const PatientInfo({Key? key, required String this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var user = FirebaseFirestore.instance.doc("Users/$uid");
    bool exist = false;

    return StreamBuilder(
        stream: user.snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            EasyLoading.dismiss();
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          EasyLoading.dismiss();
          var data = snapshot.data;
          return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: const Text("Patient Info"),
                elevation: 0,
              ),
              bottomNavigationBar: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 0.51 * width,
                    child: ElevatedButton(
                      child: const Text("Check Appointment"),
                      onPressed: () {
                        data["verification"]
                            ? Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                return CheckAppointment(data2: data);
                              }))
                            : EasyLoading.showError("This user is unverified!");
                      },
                    ),
                  ),
                  SizedBox(width: 0.01 * width),
                  SizedBox(
                    width: 0.45 * width,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green)),
                      child: const Text("Create QR Code"),
                      onPressed: () {
                        data["verification"]
                            ? Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                return VaccineInfo(data: data);
                              }))
                            : EasyLoading.showError("This user is unverified!");
                      },
                    ),
                  ),
                ],
              ),
              body: SafeArea(
                  child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(0.02 * width),
                        width: 0.8 * width,
                        decoration: BoxDecoration(color: Colors.grey[300]),
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
                                    data["verification"]
                                        ? const Text("√Verified",
                                            style:
                                                TextStyle(color: Colors.green))
                                        : const Text("×Unverified",
                                            style:
                                                TextStyle(color: Colors.red)),
                                    data["verification"] == false
                                        ? SizedBox(
                                            height: 20,
                                            width: 80,
                                            child: ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.red)),
                                                onPressed: () async {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("Users")
                                                      .where("verification",
                                                          isEqualTo: true)
                                                      .where("id",
                                                          isEqualTo: data["id"])
                                                      .get()
                                                      .then((value) {
                                                    if (value.docs.isNotEmpty) {
                                                      exist = true;
                                                    }
                                                  });
                                                  !exist
                                                      ? showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                'Confirm',
                                                              ),
                                                              content:
                                                                  const Text(
                                                                'Are you sure to verify this user?',
                                                              ),
                                                              actions: <Widget>[
                                                                ElevatedButton(
                                                                  child:
                                                                      const Text(
                                                                          'YES'),
                                                                  onPressed:
                                                                      () async {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    EasyLoading.show(
                                                                        maskType:
                                                                            EasyLoadingMaskType.black);
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .doc(
                                                                            "Users/${data["uid"]}")
                                                                        .update({
                                                                      "verification":
                                                                          true
                                                                    });
                                                                    EasyLoading
                                                                        .showSuccess(
                                                                            "Verified");
                                                                    EasyLoading
                                                                        .dismiss();
                                                                  },
                                                                ),
                                                                ElevatedButton(
                                                                  child:
                                                                      const Text(
                                                                          'NO'),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                ),
                                                              ],
                                                              elevation: 20,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                            );
                                                          },
                                                        )
                                                      : EasyLoading.showError(
                                                          "User already existed");
                                                },
                                                child: const Text("Verify")),
                                          )
                                        : Container(),
                                    infoFormat(width, height, "Name:",
                                        data["displayName"]),
                                    infoFormat(
                                        width,
                                        height,
                                        data["nationality"] == "Thai"
                                            ? "ID Card:"
                                            : "Passport:",
                                        data["id"]),
                                    infoFormat(width, height, "Gender:",
                                        data["gender"]),
                                    infoFormat(width, height, "DOB:",
                                        "${data["dob"].toDate().year}-${data["dob"].toDate().month.toString().padLeft(2, '0')}-${data["dob"].toDate().day.toString().padLeft(2, '0')}"),
                                    Row(
                                      children: [
                                        SizedBox(
                                            width: 0.25 * width,
                                            child: const Text("address:",
                                                style:
                                                    TextStyle(fontSize: 16))),
                                        Container(
                                          width: 0.5 * width,
                                          padding:
                                              EdgeInsets.all(0.01 * height),
                                          child: Text(
                                            data["address"],
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                            maxLines: 5,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    infoFormat(width, height, "Nationality:",
                                        data["nationality"]),
                                    infoFormat(width, height, "E-mail:",
                                        data["email"]),
                                    infoFormat(
                                        width, height, "phone:", data["phone"]),
                                    infoFormat(width, height, "Blood group:",
                                        data["bloodGroup"]),
                                    infoFormat(width, height, "weight:",
                                        data["weight"]),
                                    infoFormat(width, height, "height:",
                                        data["height"]),
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )));
        });
  }
}

Row infoFormat(double width, double height, String title, String data) {
  return Row(
    children: [
      SizedBox(
          width: 0.25 * width,
          child: Text(title, style: const TextStyle(fontSize: 16))),
      Padding(
        padding: EdgeInsets.all(0.01 * height),
        child: Text(
          data,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    ],
  );
}
