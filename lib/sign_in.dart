import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vaccination_pro/home.dart';

class SignIn extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  SignIn({Key? key}) : super(key: key);
  late String _password;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.blue,
          body: Stack(children: [
            Center(
              child: Container(
                padding: EdgeInsets.only(top: 0.25 * height),
                child: Column(children: [
                  SvgPicture.asset("assets/icons/vaccines.svg",
                      color: Colors.white,
                      height: 50,
                      semanticsLabel: 'vaccines icon'),
                  const Text("Vaccinations Pro",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w500))
                ]),
              ),
            ),
            Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "PASSWORD",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2),
                    ),
                    const SizedBox(height: 10),
                    Form(
                      key: _formKey,
                      child: SizedBox(
                        width: 0.7 * width,
                        child: TextFormField(
                          style: const TextStyle(fontSize: 14),
                          obscureText: true,
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide.none)),
                          onSaved: (password) => _password = password!,
                          onFieldSubmitted: (v) async {
                            await signInMethod(context);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 0.25 * width,
                      //Sign in button
                      child: ElevatedButton(
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue[900]),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)))),
                          onPressed: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            await signInMethod(context);
                          },
                          child: const Text("Sign In")),
                    ),
                  ]),
            ),
          ]),
        ));
  }

  //Sign in with firebase and loading animation
  Future<void> signInMethod(BuildContext context) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      EasyLoading.show(maskType: EasyLoadingMaskType.black);
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: "admin@admin.com", password: _password);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return const Home();
        }));
        EasyLoading.dismiss();
      } catch (e) {
        EasyLoading.showError(e.toString());
      }
    }
  }
}
