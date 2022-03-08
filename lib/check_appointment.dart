import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vaccination_pro/design_course/design_course_app_theme.dart';
import 'add_appointment.dart';
import 'package:vaccination_pro/fitness_app/fitness_app_theme.dart';

class CheckAppointment extends StatelessWidget {
  final data2;

  CheckAppointment({Key? key, required DocumentSnapshot<Object?> this.data2})
      : super(key: key);

  DateTime _date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var collection = FirebaseFirestore.instance
        .doc("Users/${data2["uid"]}")
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
            title: const Text("Appointments"),
            elevation: 0,
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AddAppointment(data: data2);
                }));
                // DatePicker.showDatePicker(context,
                //     showTitleActions: true,
                //     minTime: DateTime.now(),
                //     maxTime: DateTime(2200), onChanged: (date) {
                //   _date = date;
                // }, onConfirm: (date) {
                //   _date = date;
                //   showDialog(
                //     context: context,
                //     barrierDismissible: false,
                //     builder: (BuildContext context) {
                //       return AlertDialog(
                //         title: const Text('Add New Appointment'),
                //         content: Text(
                //           "${_date.year.toString()}-${_date.month.toString()}-${_date.day.toString()}",
                //         ),
                //         actions: <Widget>[
                //           ElevatedButton(
                //             child: const Text('Cancel'),
                //             onPressed: () {
                //               Navigator.of(context).pop();
                //             },
                //           ),
                //           ElevatedButton(
                //             child: const Text('Confirm'),
                //             onPressed: () async {
                //               Navigator.of(context).pop();
                //               await collection
                //                   .add({"time": Timestamp.fromDate(_date)});
                //             },
                //           ),
                //         ],
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10)),
                //       );
                //     },
                //   );
                // }, currentTime: _date, locale: LocaleType.en);
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
                      ? Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 10, top: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: FitnessAppTheme.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  bottomLeft: Radius.circular(8.0),
                                  bottomRight: Radius.circular(8.0),
                                  topRight: Radius.circular(68.0)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color:
                                        FitnessAppTheme.grey.withOpacity(0.2),
                                    offset: Offset(1.1, 1.1),
                                    blurRadius: 10.0),
                              ],
                            ),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 16,
                                    left: 16,
                                    right: 24,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4, bottom: 8, top: 16),
                                        child: Text(
                                          data["place_of_service"],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily:
                                                  FitnessAppTheme.fontName,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              letterSpacing: -0.1,
                                              color: FitnessAppTheme.darkText),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4, bottom: 3),
                                                child: Text(
                                                  data["vaccine_name"],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: FitnessAppTheme
                                                        .fontName,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 26,
                                                    color: DesignCourseAppTheme
                                                        .nearlyBlue,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8, bottom: 8),
                                                child: Text(
                                                  data["dose_number"],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: FitnessAppTheme
                                                        .fontName,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    letterSpacing: -0.2,
                                                    color: DesignCourseAppTheme
                                                        .nearlyBlue,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.access_time,
                                                    color: FitnessAppTheme.grey
                                                        .withOpacity(0.7),
                                                    size: 16,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 4.0),
                                                    child: Text(
                                                      "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} ",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            FitnessAppTheme
                                                                .fontName,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 15,
                                                        letterSpacing: 0.0,
                                                        color: FitnessAppTheme
                                                            .grey
                                                            .withOpacity(0.7),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 1.5, left: 4.0),
                                                child: Text(
                                                  "${time.year.toString()}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} ",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: FitnessAppTheme
                                                        .fontName,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15,
                                                    letterSpacing: 0.0,
                                                    color: FitnessAppTheme.grey
                                                        .withOpacity(0.7),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4, bottom: 14),
                                                child: Text(
                                                  data["provider_name"],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: FitnessAppTheme
                                                        .fontName,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                    letterSpacing: 0.0,
                                                    color: DesignCourseAppTheme
                                                        .nearlyBlue,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 24, right: 24, top: 8, bottom: 8),
                                  child: Container(
                                    height: 2,
                                    decoration: BoxDecoration(
                                      color: FitnessAppTheme.background,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(4.0)),
                                    ),
                                  ),
                                ),
                                InkWell(
                                    onTap: () async {
                                      await FirebaseFirestore.instance
                                          .doc("Users/${data2["uid"]}")
                                          .collection("Appointment")
                                          .doc(data.reference.id)
                                          .delete();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 24,
                                          right: 24,
                                          top: 8,
                                          bottom: 16),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              height: 42,
                                              decoration: BoxDecoration(
                                                color:
                                                    // Color.fromRGBO(255, 82, 135, 0.8),
                                                    Colors.red.shade400,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(16.0),
                                                ),
                                                boxShadow: <BoxShadow>[
                                                  BoxShadow(
                                                      color: Color.fromRGBO(
                                                              255, 82, 135, 0.8)
                                                          .withOpacity(0.5),
                                                      offset: const Offset(
                                                          1.1, 1.1),
                                                      blurRadius: 10.0),
                                                ],
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Cancel Appointment',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
                                                    letterSpacing: 0.0,
                                                    color: DesignCourseAppTheme
                                                        .nearlyWhite,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ))
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
