import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:vaccination_hospital/patient_info.dart';

class PatientList extends StatefulWidget {
  PatientList({Key? key}) : super(key: key);

  @override
  State<PatientList> createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  late TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var users = FirebaseFirestore.instance.collection("Users").get();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Patient List"),
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _searchController = TextEditingController();
                      setState(() {});
                    },
                  )),
              onChanged: (v) {
                setState(() {
                  _searchController = TextEditingController(text: v);
                  _searchController.selection = TextSelection.fromPosition(
                      TextPosition(offset: _searchController.text.length));
                  setState(() {});
                });
              },
            ),
            FutureBuilder<QuerySnapshot>(
                future: users,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    EasyLoading.dismiss();
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }
                  EasyLoading.dismiss();
                  return Column(
                    children: [
                      ...snapshot.data!.docs
                          .where((element) => element["displayName"]
                              .toString()
                              .toLowerCase()
                              .contains(_searchController.text.toLowerCase()))
                          .map((data) => InkWell(
                                child: Card(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(data["photoUrl"]),
                                    ),
                                    title: Text(data["displayName"],
                                        style: const TextStyle(
                                          fontSize: 20,
                                        )),
                                    subtitle: Text(data["id"]),
                                    trailing: const Icon(Icons.navigate_next),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PatientInfo(data: data)));
                                },
                              ))
                    ],
                  );
                })
          ],
        ),
      ),
    );
  }
}
