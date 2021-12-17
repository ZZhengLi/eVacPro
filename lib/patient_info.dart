import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PatientInfo extends StatelessWidget {
  final data;
  const PatientInfo(
      {Key? key, required QueryDocumentSnapshot<Object?> this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
