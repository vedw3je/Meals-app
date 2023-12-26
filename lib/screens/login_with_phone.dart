import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'verify_code.dart';
import 'package:meals/utils/utils.dart';
import 'package:meals/widgets/round_button.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({Key? key}) : super(key: key);

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  bool loading = false;
  final phoneNumberController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meals'),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                alignment: Alignment.topCenter,
                'https://cdn.pixabay.com/photo/2016/04/02/17/58/service-1303313_1280.jpg',
                height: 270,
                width: 350,
                fit: BoxFit.contain,
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                alignment: Alignment.center,
                child: Text('WELCOME!',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        letterSpacing: 4,
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                textAlign: TextAlign.left,
                'Enter Your Mobile Number ',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                controller: phoneNumberController,
                decoration: InputDecoration(
                  hintText: '+1 234 3455 234',
                  focusColor: Colors.black,
                  hoverColor: Colors.black,
                ),
              ),
              SizedBox(
                height: 35,
              ),
              RoundButton(
                  title: 'Login',
                  loading: loading,
                  onTap: () {
                    setState(() {
                      loading = true;
                    });
                    auth.verifyPhoneNumber(
                        phoneNumber: phoneNumberController.text,
                        verificationCompleted: (_) {
                          setState(() {
                            loading = false;
                          });
                        },
                        verificationFailed: (e) {
                          setState(() {
                            loading = false;
                          });
                          Utils().toastMessage(e.toString());
                        },
                        codeSent: (String verificationId, int? token) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VerifyCodeScreen(
                                        verificationId: verificationId,
                                      )));
                          setState(() {
                            loading = false;
                          });
                        },
                        codeAutoRetrievalTimeout: (e) {
                          Utils().toastMessage(e.toString());
                          setState(() {
                            loading = false;
                          });
                        });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
