import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:vaccination_hospital/sign_in.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Skills"), centerTitle: true),
      body: Column(
        children: [
          Container(
            child: ElevatedButton(
              child: const Text("Log Out"),
              onPressed: () {
                EasyLoading.show(maskType: EasyLoadingMaskType.black);
                FirebaseAuth.instance.signOut();
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return SignIn();
                }));
                EasyLoading.dismiss();
              },
            ),
          )
        ],
      ),
    );
  }
}
