import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:riskfactor/constants/config.dart';
import 'package:riskfactor/constants/routes.dart';
import 'package:riskfactor/widgets/AuthForm.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _stepNumber = 0;
  List<AuthFormStep> _steps = [
    AuthFormStep(
      titleText: "Please input your email address and password below",
      fields: [
        InputField(
          validator: InputValidationTechnique.email.build(),
          placeholderText: "Email",
          inputType: TextInputType.emailAddress,
          textCapitalization: TextCapitalization.none,
          value: "",
        ),
        InputField(
          validator: InputValidationTechnique.text.build(),
          placeholderText: "Password",
          inputType: TextInputType.text,
          textCapitalization: TextCapitalization.none,
          autocorrect: false,
          obscureText: true,
          enableSuggestions: false,
          textInputAction: TextInputAction.go,
          value: "",
        ),
      ],
    ),
  ];
  bool _loading = false;
  String _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                if (_loading) CircularProgressIndicator(),
                if (!_loading)
                  Column(
                    children: [
                      Text(
                        "Sign In",
                        style: GoogleFonts.sourceSansPro(fontSize: 64),
                      ),
                      Text(
                        _steps[_stepNumber].titleText,
                        style: GoogleFonts.sourceSansPro(fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _error,
                      style: GoogleFonts.sourceSansPro(
                          fontSize: 12.0, color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                Spacer(),
                Form(
                  key: _formKey,
                  child: AuthForm(
                    step: _steps[_stepNumber],
                    stepNumber: _stepNumber,
                    stepsLength: _steps.length,
                    onTextChanged: (val, fieldNumber) {
                      setState(() {
                        _steps[_stepNumber].fields[fieldNumber].value = val;
                      });
                    },
                    advanceStep: () async {
                      var values = _steps[0].fields;
                      var email = values[0].value, password = values[1].value;

                      final devMode =
                          Provider.of<Config>(context, listen: false).devMode;

                      if (devMode || _formKey.currentState.validate()) {
                        if (!devMode) {
                          final firebaseAuth =
                              Provider.of<FirebaseAuth>(context, listen: false);
                          setState(() {
                            _loading = true;
                          });
                          try {
                            UserCredential userCredential =
                                await firebaseAuth.signInWithEmailAndPassword(
                                    email: email, password: password);
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                Routes.home, (_) => false);
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              _error = e.message;
                            });
                          } catch (e) {
                            setState(() {
                              _error = e.toString();
                            });
                          }
                          setState(() {
                            _loading = false;
                          });
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
