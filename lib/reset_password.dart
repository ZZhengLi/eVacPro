import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';

class ResetPassword extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  ResetPassword({Key? key}) : super(key: key);
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
        appBar: AppBar(title: const Text("Setting"), centerTitle: true),
        body: Form(
          key: _formKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 0.8 * width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Password:",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: "********",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5))),
                      validator: RequiredValidator(
                          errorText: "Password can't be null"),
                      onSaved: (password) => _password = password!,
                      onChanged: (pass) => _password = pass,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Confirm Password:",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: "********",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5))),
                      validator: (pass) =>
                          MatchValidator(errorText: "Password do not  match")
                              .validateMatch(pass!, _password),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            child: const Text("Confirm"),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                EasyLoading.show(
                                    maskType: EasyLoadingMaskType.black);
                                try {
                                  final User? user =
                                      FirebaseAuth.instance.currentUser;
                                  await user!.updatePassword(_password);
                                  EasyLoading.showSuccess(
                                      "Password Reset Successfully!");
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                } catch (e) {
                                  EasyLoading.showError(e.toString());
                                }
                              }
                            }),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final passwordValidator = MultiValidator(
  [
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'passwords must have at least one special character')
  ],
);
