import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vaccination_pro/reset_password.dart';
import 'package:vaccination_pro/sign_in.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Setting"), centerTitle: true),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  child: const Text("Reset Password"),
                  onPressed: () {
                    EasyLoading.show(maskType: EasyLoadingMaskType.black);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ResetPassword();
                    }));
                    EasyLoading.dismiss();
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
