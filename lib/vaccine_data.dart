import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vaccination_pro/add_vaccine.dart';
import 'package:vaccination_pro/vaccine_info.dart';

class VaccineData extends StatefulWidget {
  VaccineData({Key? key}) : super(key: key);

  @override
  State<VaccineData> createState() => _VaccineDataState();
}

class _VaccineDataState extends State<VaccineData> {
  late TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var users = FirebaseFirestore.instance.collection("VaccineData").get();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Vaccine List"),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddVaccine(),
                ),
              );
            },
          )
        ],
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
                          .where((element) =>
                              element["name"].toString().toLowerCase().contains(
                                  _searchController.text.toLowerCase()) ||
                              element["id"].toString().toLowerCase().contains(
                                  _searchController.text.toLowerCase()))
                          .map((data) => InkWell(
                                child: Card(
                                  child: ListTile(
                                    leading: SvgPicture.asset(
                                        "assets/icons/vaccines.svg",
                                        color: Colors.blue,
                                        height: 50,
                                        semanticsLabel: 'vaccines icon'),
                                    title: Text(data["name"],
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
                                              VaccineInfo(data: data)));
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
